<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Step 1: Prepare a SQL statement to select food items
    $food_sql = "SELECT food, quantity, calorie FROM food_items";
    $food_stmt = $conn->prepare($food_sql);

    // Step 2: Execute the query
    $food_stmt->execute();
    $food_result = $food_stmt->get_result();

    // Step 3: Initialize an array to track unique food items
    $food_data = [];

    // Step 4: Process the results
    while ($row = $food_result->fetch_assoc()) {
        $food_name = $row['food'];
        $quantity = $row['quantity'];
        $calorie = $row['calorie'];

        // Extract numeric part and unit using regex
        $quantity_number = '';
        $quantity_unit = '';

        if (isset($quantity) && !empty($quantity)) {
            preg_match('/([0-9]+[\.,0-9]*)([^\d].*)?/', $quantity, $matches);
            if (isset($matches[1])) {
                $quantity_number = $matches[1]; // Numeric part
            }
            if (isset($matches[2])) {
                $quantity_unit = trim($matches[2]); // Unit part
            }
        }

        // If the food item is not already in the array, initialize it
        if (!array_key_exists($food_name, $food_data)) {
            $food_data[$food_name] = [
                'food' => $food_name,
                'quantity_numbers' => [], // To hold all quantity numbers
                'units' => [], // To hold unit and calorie pairs
                'calories' => [] // To hold calories for each quantity
            ];
        }

        // Add the quantity number, unit, and calorie values
        $food_data[$food_name]['quantity_numbers'][] = $quantity_number;
        $food_data[$food_name]['units'][] = $quantity_unit;
        $food_data[$food_name]['calories'][] = $calorie;
    }

    // Step 5: Convert the associative array into the required output format
    $response_data = [];

    foreach ($food_data as $food => $details) {
        $response_item = [];

        // Add the food item
        $response_item['food'] = $details['food'];

        // Add each quantity_number, quantity_unit, and calorie
        foreach ($details['quantity_numbers'] as $index => $quantity_number) {
            $response_item["quantity_number" . ($index + 1)] = $quantity_number;
            $response_item["quantity_unit" . ($index + 1)] = $details['units'][$index];
            $response_item["calories" . ($index + 1)] = $details['calories'][$index];
        }

        // Add the formatted item to the response data
        $response_data[] = $response_item;
    }

    // Step 6: Output the food data in JSON format
    echo json_encode([
        'status' => 'true',
        'data' => $response_data
    ], JSON_PRETTY_PRINT);

    // Close the statement
    $food_stmt->close();

    // Close the connection
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
