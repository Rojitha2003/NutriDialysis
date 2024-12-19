<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Prepare the SQL statement to fetch all patient details from the add_patient table
    $sql = "SELECT patient_id, patient_name, gender FROM add_patient";
    $result = $conn->query($sql);

    // Check if any patients exist
    if ($result->num_rows > 0) {
        $response = [];

        // Loop through each patient from the add_patient table
        while ($data = $result->fetch_assoc()) {
            $response[] = [
                'patient_id' => $data['patient_id'],
                'patient_name' => $data['patient_name'] ?? 'No Data',
                'gender' => $data['gender'] ?? 'No Data'
            ];
        }

        // Output the combined data with status as true
        echo json_encode([
            'status' => true,
            'data' => $response
        ], JSON_PRETTY_PRINT);
    } else {
        // If no patients are found in the add_patient table
        echo json_encode([
            'status' => false,
            'message' => 'No patients found.'
        ], JSON_PRETTY_PRINT);
    }

    // Close the connection
    $conn->close();
} else {
    echo json_encode([
        'status' => false,
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
