<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Step 1: Prepare a SQL statement to select food items
    $food_sql = "SELECT food, quantity, calorie FROM food_items ORDER BY food, quantity";
    $food_stmt = $conn->prepare($food_sql);
    
    // Step 2: Execute the query
    $food_stmt->execute();
    $food_result = $food_stmt->get_result();

    // Step 3: Initialize an array to track food items and their quantities
    $food_data = [];
    
    // Step 4: Process the results
    while ($row = $food_result->fetch_assoc()) {
        // Check if the food already exists in the array
        if (!array_key_exists($row['food'], $food_data)) {
            // First time seeing this food, add it with its first quantity
            preg_match('/([0-9]+)\s*(.*)/', $row['quantity'], $matches);
            $quantity_number = isset($matches[1]) ? $matches[1] : ''; // Numeric part (e.g., 1)
            $quantity_string = isset($matches[2]) ? $matches[2] : ''; // Descriptive part (e.g., "small(100g)")
            
            // Add food with its first quantity details
            $food_data[$row['food']] = [
                'first_quantity' => $row['quantity'],      // Full first quantity (e.g., "1 small(100g)")
                'calorie' => $row['calorie'],              // Calorie count for first quantity
                'quantity_number' => $quantity_number,     // Numeric part (e.g., 1)
                'quantity_string' => $quantity_string,     // Descriptive part (e.g., "small(100g)")
                'all_quantities' => []                     // To store all quantity strings
            ];
        }

        // Add each food's quantity string (without numeric part) to 'all_quantities'
        preg_match('/([0-9]+)\s*(.*)/', $row['quantity'], $matches);
        $quantity_string = isset($matches[2]) ? $matches[2] : '';
        $food_data[$row['food']]['all_quantities'][] = $quantity_string;
    }

    // Step 5: Convert the associative array to a numeric array for JSON output
    $response_data = [];
    foreach ($food_data as $food => $details) {
        $response_item = [
            'food' => $food,
            'first_quantity' => $details['first_quantity'],     // Full first quantity (e.g., "1 small(100g)")
            'calorie' => $details['calorie'],                   // Calorie count for first quantity
            'quantity_number' => $details['quantity_number'],   // Numeric part of first quantity (e.g., 1)
            'quantity_string' => $details['quantity_string']    // Descriptive part of first quantity (e.g., "small(100g)")
        ];

        // Check if the food has more than one quantity
        if (count($details['all_quantities']) > 1) {
            // Add all quantities only if there is more than one quantity
            $response_item['all_quantities'] = implode("\n", $details['all_quantities']);
        }

        // Add the processed food item to the response
        $response_data[] = $response_item;
    }

    // Step 6: Output the food data as a JSON response
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
