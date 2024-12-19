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
        // If the food item is not already in the array, add it
        if (!array_key_exists($row['food'], $food_data)) {
            // Regex to split quantity into number part and descriptive part
            preg_match('/([0-9]+)\s*(.*)/', $row['quantity'], $matches);
            $quantity_number = isset($matches[1]) ? $matches[1] : ''; // Numeric part (e.g., 1, 2)
            $quantity_string = isset($matches[2]) ? $matches[2] : ''; // Descriptive part (e.g., "medium(200g)")
            
            // Store the data with quantity split into two parts
            $food_data[$row['food']] = [
                'quantity' => $row['quantity'],      // Full quantity (e.g., "1 medium(200g)")
                'quantity_number' => $quantity_number,  // Numeric part (e.g., 1)
                'quantity_string' => $quantity_string,  // Descriptive part (e.g., "medium(200g)")
                'calorie' => $row['calorie']        // Calorie count
            ];
        }
    }

    // Step 5: Convert the associative array to a numeric array for JSON output
    $response_data = [];
    foreach ($food_data as $food => $details) {
        $response_data[] = [
            'food' => $food,
            'quantity' => $details['quantity'],         // Full quantity
            'calorie' => $details['calorie'],           // Calorie count
            'quantity_number' => $details['quantity_number'], // Numeric part of quantity (e.g., 1)
            'quantity_string' => $details['quantity_string']   // Descriptive part of quantity (e.g., "medium(200g)")
        ];
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
        'status' => 'true',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
