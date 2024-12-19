<?php
include '_con.php'; // Include your database connection file

// Step 1: Retrieve the raw POST data
$input_data = file_get_contents('php://input');

// Step 2: Decode the JSON data into an associative array
$data = json_decode($input_data, true); // 'true' for associative array

// Step 3: Check if decoding was successful
if ($data === null) {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid JSON data received.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 4: Retrieve the necessary fields from the decoded JSON
$patient_id = $data['patient_id'] ?? null;
$food_time = $data['food_time'] ?? null; // Common for all
$sets = $data['sets'] ?? null; // This is the array of food sets

// Step 5: Validate if the required fields are present
if (empty($patient_id) || empty($food_time) || empty($sets)) {
    echo json_encode([
        'status' => 'false',
        'message' => 'Missing required fields (patient_id, food_time, or sets).'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 6: Prepare the SQL statement for nutrition_display insertion
$insert_sql = "INSERT INTO nutrition_display (
    patient_id, food, quantity_number, quantity_unit, calorie, food_time, 
    carbohydrate, protein, sodium, potassium
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

// Step 7: Prepare the SQL statement for food_items fetching
$fetch_sql = "SELECT calorie, carbohydrate, protein, sodium, potassium FROM food_items WHERE food = ?";

// Prepare the insert and fetch statements
$insert_stmt = $conn->prepare($insert_sql);
$fetch_stmt = $conn->prepare($fetch_sql);

if ($insert_stmt === false || $fetch_stmt === false) {
    echo json_encode([
        'status' => 'false',
        'message' => 'Failed to prepare the SQL statements.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 8: Loop through the sets and process each selected one
foreach ($sets as $set) {
    if (isset($set['isSelected']) && $set['isSelected']) {
        $food = $set['food'];
        $quantity_number = (float)$set['quantity_number'];
        $quantity_unit = $set['quantity_unit'];

        // Fetch the food details from the food_items table
        $fetch_stmt->bind_param("s", $food);
        if (!$fetch_stmt->execute()) {
            echo json_encode([
                'status' => 'false',
                'message' => 'Failed to fetch details for the food item.'
            ], JSON_PRETTY_PRINT);
            exit;
        }

        $result = $fetch_stmt->get_result();
        if ($result->num_rows === 0) {
            echo json_encode([
                'status' => 'false',
                'message' => "No details found for food item: $food."
            ], JSON_PRETTY_PRINT);
            exit;
        }

        $food_details = $result->fetch_assoc();

        // Extract the nutritional values
        $calorie_per_unit = (float)$food_details['calorie'];
        $carbohydrate_per_unit = (float)$food_details['carbohydrate'];
        $protein_per_unit = (float)$food_details['protein'];
        $sodium_per_unit = (float)$food_details['sodium'];
        $potassium_per_unit = (float)$food_details['potassium'];

        // Calculate the total values based on the quantity and unit
        $total_calorie = ($quantity_unit === "g")
            ? ($quantity_number / 100) * $calorie_per_unit
            : $quantity_number * $calorie_per_unit;

        $total_carbohydrate = ($quantity_unit === "g")
            ? ($quantity_number / 100) * $carbohydrate_per_unit
            : $quantity_number * $carbohydrate_per_unit;

        $total_protein = ($quantity_unit === "g")
            ? ($quantity_number / 100) * $protein_per_unit
            : $quantity_number * $protein_per_unit;

        $total_sodium = ($quantity_unit === "g")
            ? ($quantity_number / 100) * $sodium_per_unit
            : $quantity_number * $sodium_per_unit;

        $total_potassium = ($quantity_unit === "g")
            ? ($quantity_number / 100) * $potassium_per_unit
            : $quantity_number * $potassium_per_unit;

        // Bind and execute the insert statement
        $insert_stmt->bind_param(
            "ssssssssss",
            $patient_id,
            $food,
            $quantity_number,
            $quantity_unit,
            $total_calorie,
            $food_time,
            $total_carbohydrate,
            $total_protein,
            $total_sodium,
            $total_potassium
        );

        if (!$insert_stmt->execute()) {
            echo json_encode([
                'status' => 'false',
                'message' => 'Failed to insert one of the selected sets into the table.'
            ], JSON_PRETTY_PRINT);
            exit;
        }
    }
}

// Step 9: Close the statements and connection
$insert_stmt->close();
$fetch_stmt->close();
$conn->close();

// Step 10: Return success message after all selected sets are inserted
echo json_encode([
    'status' => 'true',
    'message' => 'All selected sets successfully inserted into nutrition_display table.'
], JSON_PRETTY_PRINT);
?>
