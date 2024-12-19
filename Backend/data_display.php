<?php
include '_con.php'; // Include your database connection file

// Step 1: Retrieve the raw POST data
$input_data = file_get_contents('php://input');

// Debugging step: Print the raw POST data to the log
error_log("Received POST data: " . $input_data); // This will write to the error log (check server logs)

// Step 2: Check if the POST data is empty or invalid
if (empty($input_data)) {
    echo json_encode([
        'status' => 'false',
        'message' => 'No data received in the POST request.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 3: Decode the JSON data into an associative array
$data = json_decode($input_data, true); // 'true' for associative array

// Step 4: Check if decoding was successful
if ($data === null) {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid JSON data received. Please check the format of the JSON data.'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 5: Retrieve fields from the decoded JSON
$patient_id = $data['patient_id'] ?? null; // patient_id is required
$food = $data['food'] ?? null;             // food is optional
$quantity = $data['quantity'] ?? null;     // quantity is optional
$food_time = $data['food_time'] ?? null;   // food_time is optional

// Step 6: Determine the status (yes or no)
if (!empty($patient_id) && empty($food) && empty($quantity) && empty($food_time)) {
    $status = 'yes'; // Fetch data
} elseif (!empty($patient_id) && !empty($food) && !empty($quantity) && !empty($food_time)) {
    $status = 'no'; // Delete row
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid parameters. Provide either patient_id only (for fetch) or patient_id, food, quantity, and food_time (for delete).'
    ], JSON_PRETTY_PRINT);
    exit;
}

// Step 7: Handle based on the determined status
if ($status === 'yes') {
    // Fetch data for the current date
    $sql = "SELECT food_time, food, quantity_number, quantity_unit, calorie, carbohydrate, protein, sodium, potassium
            FROM nutrition_display
            WHERE patient_id = ? AND DATE(time_stamp) = CURDATE()
            ORDER BY FIELD(food_time, 'early morning', 'breakfast', 'lunch', 'snacks', 'dinner', 'fluids')";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $patient_id);

    if (!$stmt->execute()) {
        echo json_encode([
            'status' => 'false',
            'message' => 'Failed to fetch data for the given patient_id.'
        ], JSON_PRETTY_PRINT);
        exit;
    }

    $result = $stmt->get_result();

    // Organize the results by food_time
    $nutrition_data = [];
    while ($row = $result->fetch_assoc()) {
        $food_time = $row['food_time'];
        
        if (!isset($nutrition_data[$food_time])) {
            $nutrition_data[$food_time] = [];
        }
        
        $nutrition_data[$food_time][] = [
            'food' => $row['food'],
            'quantity' => $row['quantity_number'] . ' ' . $row['quantity_unit'],
            'calorie' => $row['calorie'],
            'carbohydrate' => $row['carbohydrate'],
            'protein' => $row['protein'],
            'sodium' => $row['sodium'],
            'potassium' => $row['potassium']
        ];
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();

    // Return the fetched data in JSON format
    echo json_encode([
        'status' => 'true',
        'message' => 'Nutrition data retrieved successfully.',
        'data' => $nutrition_data
    ], JSON_PRETTY_PRINT);

} elseif ($status === 'no') {
    // Delete row
    $sql = "DELETE FROM nutrition_display
            WHERE patient_id = ? AND food = ? AND CONCAT(quantity_number, ' ', quantity_unit) = ? AND food_time = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $patient_id, $food, $quantity, $food_time);

    if ($stmt->execute() && $stmt->affected_rows > 0) {
        // Deletion successful
        echo json_encode([
            'status' => 'true',
            'message' => 'Item deleted successfully.'
        ], JSON_PRETTY_PRINT);
    } else {
        // Deletion failed
        echo json_encode([
            'status' => 'false',
            'message' => 'Failed to delete the item. It may not exist.'
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
}
?>
