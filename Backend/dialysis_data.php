<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json'); // Ensure JSON response

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the patient_id and dialysis details from the POST request
    $patient_id = $_POST['patient_id'] ?? null;
    $weight = $_POST['weight'] ?? null;
    $weight_gain = $_POST['weight_gain'] ?? null;
    $pre_bp = $_POST['pre_bp'] ?? null;
    $post_bp = $_POST['post_bp'] ?? null;
    $urine_output = $_POST['urine_output'] ?? null;
    $tricep_skinfold_thickness = $_POST['tricep_skinfold_thickness'] ?? null;
    $hand_grip = $_POST['hand_grip'] ?? null;

    // Ensure all required fields are provided
    if (!$patient_id || !$weight || !$weight_gain || !$pre_bp || !$post_bp || !$urine_output || !$tricep_skinfold_thickness || !$hand_grip) {
        echo json_encode([
            'status' => 'false',
            'message' => 'All fields are required to save dialysis data.'
        ], JSON_PRETTY_PRINT);
        exit;
    }

    try {
        // Save the dialysis data into the database
        $sql = "INSERT INTO dialysis_data (patient_id, weight, weight_gain, pre_bp, post_bp, urine_output, tricep_skinfold_thickness, hand_grip) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssss", $patient_id, $weight, $weight_gain, $pre_bp, $post_bp, $urine_output, $tricep_skinfold_thickness, $hand_grip);

        if ($stmt->execute()) {
            echo json_encode([
                'status' => 'true',
                'message' => 'Dialysis data saved successfully.'
            ], JSON_PRETTY_PRINT);
        } else {
            echo json_encode([
                'status' => 'false',
                'message' => 'Failed to save dialysis data.'
            ], JSON_PRETTY_PRINT);
        }

        $stmt->close();
    } catch (Exception $e) {
        echo json_encode([
            'status' => 'false',
            'message' => 'An error occurred: ' . $e->getMessage()
        ], JSON_PRETTY_PRINT);
    }

    // Close the database connection
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
