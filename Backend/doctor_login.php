<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the input details from the POST request
    $doctor_id = $_POST['doctor_id'];
    $password = $_POST['password'];

    // Prepare the SQL statement to fetch doctor_id and name if credentials match
    $sql = "SELECT doctor_id, name FROM doctor WHERE doctor_id = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $doctor_id, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if a matching record is found
    if ($result->num_rows > 0) {
        // Fetch the doctor's details
        $row = $result->fetch_assoc();

        echo json_encode([
            'status' => 'true',
            'message' => 'Login successful',
            'doctor_id' => $row['doctor_id'],
            'name' => $row['name'],
        ], JSON_PRETTY_PRINT);
    } else {
        // No matching record found
        echo json_encode([
            'status' => 'false',
            'message' => 'Invalid doctor ID or password.',
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    // Invalid request method
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
