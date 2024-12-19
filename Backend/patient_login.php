<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the input details from the POST request
    $patient_id = $_POST['patient_id'];
    $password = $_POST['password'];

    // Prepare the SQL statement to fetch patient_id and patient_name if credentials match
    $sql = "SELECT patient_id, patient_name FROM add_patient WHERE patient_id = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $patient_id, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if a matching record is found
    if ($result->num_rows > 0) {
        // Fetch the record
        $row = $result->fetch_assoc();

        // Return the patient_id and patient_name in the response
        echo json_encode([
            'status' => 'true',
            'message' => 'Login successful',
            'patient_id' => $row['patient_id'],
            'patient_name' => $row['patient_name'],
        ], JSON_PRETTY_PRINT);
    } else {
        // No matching record found
        echo json_encode([
            'status' => 'false',
            'message' => 'Invalid patient ID or password.',
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
