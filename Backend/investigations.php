<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect patient_id from the POST request
    $patient_id = $_POST['patient_id']; 

    // Check if patient_id exists in the add_patient table
    $check_sql = "SELECT patient_id FROM add_patient WHERE patient_id = ?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->bind_param("s", $patient_id);
    $check_stmt->execute();
    $check_stmt->store_result();

    if ($check_stmt->num_rows > 0) {
        // If patient_id exists, collect the investigation details
        $hemoglobin = $_POST['hemoglobin'];
        $pcv = $_POST['pcv'];
        $total_wbc_count = $_POST['total_wbc_count'];
        $creatinine = $_POST['creatinine'];
        $potassium = $_POST['potassium'];
        $serum_cholesterol = $_POST['serum_cholesterol'];
        $serum_albumin = $_POST['serum_albumin'];
        $bicarbonate = $_POST['bicarbonate'];
        $ejection_fraction = $_POST['ejection_fraction'];

        // Prepare the SQL statement to insert investigation details
        $sql = "INSERT INTO investigations (patient_id, hemoglobin, pcv, total_wbc_count, creatinine, potassium, serum_cholesterol, serum_albumin, bicarbonate, ejection_fraction) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssssss", $patient_id, $hemoglobin, $pcv, $total_wbc_count, $creatinine, $potassium, $serum_cholesterol, $serum_albumin, $bicarbonate, $ejection_fraction);

        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode([
                'status' => 'true',
                'message' => 'Investigation data inserted successfully',
                'patient_id' => $patient_id,
            ], JSON_PRETTY_PRINT);
        } else {
            echo json_encode([
                'status' => 'false',
                'message' => 'Failed to add investigation data.',
            ], JSON_PRETTY_PRINT);
        }

        // Close the statement
        $stmt->close();
    } else {
        // If patient_id does not exist, return an error message
        echo json_encode([
            'status' => 'false',
            'message' => 'Invalid patient ID. No such patient exists.',
        ], JSON_PRETTY_PRINT);
    }

    // Close the check statement and connection
    $check_stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
