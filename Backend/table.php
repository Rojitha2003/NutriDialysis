<?php
include '_con.php'; // Include your database connection file

// Step 0: Set the correct time zone
date_default_timezone_set('Asia/Kolkata');

// Step 1: Retrieve the raw POST data
$input_data = file_get_contents('php://input');

// Debugging: Log the received POST data
error_log("Received POST data: " . $input_data);

// Step 2: Validate input data
if (empty($input_data)) {
    echo json_encode([
        'status' => 'false',
        'message' => 'No data received in the POST request.'
    ], JSON_PRETTY_PRINT);
    exit;
}

$data = json_decode($input_data, true); // Decode JSON input

// Step 3: Validate JSON decoding
if ($data === null) {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid JSON data received.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 4: Extract patient_id and validate
$patient_id = $data['patient_id'] ?? null;

if (empty($patient_id)) {
    echo json_encode([
        'status' => 'false',
        'message' => 'patient_id is required.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 5: Fetch weight of the patient
$sql_weight = "SELECT weight FROM add_patient WHERE patient_id = ?";
$stmt_weight = $conn->prepare($sql_weight);
$stmt_weight->bind_param("s", $patient_id);

if (!$stmt_weight->execute()) {
    error_log("SQL Execution Error (Weight): " . $stmt_weight->error);
    echo json_encode([
        'status' => 'false',
        'message' => 'Failed to fetch weight for the given patient_id.'
    ], JSON_PRETTY_PRINT);
    exit;
}

$result_weight = $stmt_weight->get_result();

if ($result_weight->num_rows === 0) {
    echo json_encode([
        'status' => 'false',
        'message' => 'No patient found with the given patient_id.'
    ], JSON_PRETTY_PRINT);
    exit;
}

$weight = $result_weight->fetch_assoc()['weight']; // Patient weight
$stmt_weight->close();

// Step 6: Fetch data for the current date
$current_date = date('Y-m-d'); // Get today's date
$sql = "SELECT food_time, food, quantity_number, quantity_unit, calorie, carbohydrate, protein, sodium, potassium, DATE(time_stamp) AS date_only
        FROM nutrition_display
        WHERE patient_id = ? AND DATE(time_stamp) = ?
        ORDER BY FIELD(food_time, 'early morning', 'breakfast', 'lunch', 'snacks', 'dinner', 'fluids')";

$stmt = $conn->prepare($sql);

// Debugging: Log SQL query
error_log("Prepared SQL Query: " . $sql);

// Bind parameters and execute the query
$stmt->bind_param("ss", $patient_id, $current_date);

if (!$stmt->execute()) {
    error_log("SQL Execution Error: " . $stmt->error); // Log SQL errors
    echo json_encode([
        'status' => 'false',
        'message' => 'Failed to fetch data for the given patient_id.'
    ], JSON_PRETTY_PRINT);
    exit;
}

$result = $stmt->get_result();

// Initialize data structures for results and totals
$nutrition_data = [];
$totals = [
    'carbohydrate' => 0,
    'calorie' => 0,
    'protein' => 0,
    'sodium' => 0,
    'potassium' => 0
];

// Process each row and group by food_time
while ($row = $result->fetch_assoc()) {
    $food_time = $row['food_time'];
    if (!isset($nutrition_data[$food_time])) {
        $nutrition_data[$food_time] = [];
    }

    // Add food details to the respective food_time group
    $nutrition_data[$food_time][] = [
        'food' => $row['food'],
        'quantity' => $row['quantity_number'] . ' ' . $row['quantity_unit'],
        'calorie' => round($row['calorie'], 3),
        'carbohydrate' => round($row['carbohydrate'], 3),
        'protein' => round($row['protein'], 3),
        'sodium' => round($row['sodium'], 3),
        'potassium' => round($row['potassium'], 3)
    ];

    // Update totals
    $totals['carbohydrate'] += $row['carbohydrate'];
    $totals['calorie'] += $row['calorie'];
    $totals['protein'] += $row['protein'];
    $totals['sodium'] += $row['sodium'];
    $totals['potassium'] += $row['potassium'];
}

// Define ideal nutrient values per kg
$ideal_values_per_kg = [
    'carbohydrate' => 55, // grams
    'calorie' => 35,      // kcal
    'protein' => 1.2,     // grams
    'sodium' => 1000,     // mg
    'potassium' => 18     // mg
];

// Calculate ideal values based on weight
$ideal_values = [];
foreach ($ideal_values_per_kg as $key => $value_per_kg) {
    $ideal_values[$key] = $value_per_kg * $weight;
}

// Calculate deficiencies
$deficiencies = [];
foreach ($ideal_values as $key => $ideal_value) {
    $deficiency = $ideal_value - $totals[$key];
    if ($deficiency > 0) {
        $deficiencies[$key] = round($deficiency, 3);
    }
}

// Fetch food suggestions for deficiencies
$food_suggestions = [];
foreach ($deficiencies as $nutrient => $deficiency_value) {
    $sql = "SELECT food, $nutrient, quantity 
            FROM food_items 
            WHERE CAST(SUBSTRING_INDEX($nutrient, ' ', 1) AS DECIMAL) >= ? 
            ORDER BY CAST(SUBSTRING_INDEX($nutrient, ' ', 1) AS DECIMAL) DESC 
            LIMIT 5"; // Fetch top 5 foods with the highest value for the nutrient

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("d", $deficiency_value);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $food_suggestions[$nutrient] = [];
        while ($row = $result->fetch_assoc()) {
            $food_suggestions[$nutrient][] = [
                'food' => $row['food'],
                'nutrient_value' => round(floatval(preg_replace('/[^0-9.]/', '', $row[$nutrient])), 3), // Extract numeric value
                'quantity' => $row['quantity']
            ];
        }

        // Check if no food items met the deficiency threshold
        if (empty($food_suggestions[$nutrient])) {
            // Fetch top 5 foods with the highest values for the nutrient
            $fallback_sql = "SELECT food, $nutrient, quantity 
                             FROM food_items 
                             ORDER BY CAST(SUBSTRING_INDEX($nutrient, ' ', 1) AS DECIMAL) DESC 
                             LIMIT 5";
            $fallback_stmt = $conn->prepare($fallback_sql);

            if ($fallback_stmt->execute()) {
                $fallback_result = $fallback_stmt->get_result();
                while ($row = $fallback_result->fetch_assoc()) {
                    $food_suggestions[$nutrient][] = [
                        'food' => $row['food'],
                        'nutrient_value' => round(floatval(preg_replace('/[^0-9.]/', '', $row[$nutrient])), 3), // Extract numeric value
                        'quantity' => $row['quantity']
                    ];
                }
            }

            $fallback_stmt->close();
        }
    }
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Round totals for precision
foreach ($totals as $key => $value) {
    $totals[$key] = round($value, 3);
}

// Return the response in JSON format
echo json_encode([
    'status' => 'true',
    'message' => 'Nutrition data retrieved successfully.',
    'data' => $nutrition_data,
    'totals' => $totals,
    'deficiencies' => $deficiencies,
    'food_suggestions' => $food_suggestions
], JSON_PRETTY_PRINT);

?>
