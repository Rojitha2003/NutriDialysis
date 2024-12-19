<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the required details from the POST request
    $food = $_POST['food'];
    $quantity = $_POST['quantity'];
    $carbohydrate = $_POST['carbohydrate'];
    $calorie = $_POST['calorie'];
    $protein = $_POST['protein'];
    $sodium = $_POST['sodium'];
    $potassium = $_POST['potassium'];

    // Prepare the SQL statement
    $sql = "INSERT INTO food_items (food, quantity, carbohydrate, calorie, protein, sodium, potassium) 
            VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssss", $food, $quantity, $carbohydrate, $calorie, $protein, $sodium, $potassium);

    // Execute the statement
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'true',
            'message' => 'Food item added successfully'
        ], JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'Failed to add food item'
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
