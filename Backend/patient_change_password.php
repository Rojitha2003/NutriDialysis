<?php
include '_con.php'; // Include your database connection file

// Set header for JSON response
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the posted data and trim whitespace
    $patient_id = isset($_POST['patient_id']) ? trim($_POST['patient_id']) : '';
    $current_password = isset($_POST['current_password']) ? trim($_POST['current_password']) : '';
    $new_password = isset($_POST['new_password']) ? trim($_POST['new_password']) : '';
    $confirm_password = isset($_POST['confirm_password']) ? trim($_POST['confirm_password']) : '';

    // Validate that all required fields are provided
    if (empty($patient_id) || empty($current_password) || empty($new_password) || empty($confirm_password)) {
        echo json_encode([
            'status' => false,
            'message' => 'All fields are required.',
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Check if the new password and confirm password match
    if ($new_password !== $confirm_password) {
        echo json_encode([
            'status' => false,
            'message' => 'New password and confirm password do not match.',
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Fetch the stored password for the patient
    $sql = "SELECT password FROM add_patient WHERE patient_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $patient_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        // Patient ID not found
        echo json_encode([
            'status' => false,
            'message' => 'Patient not found.',
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Fetch the stored password from the result
    $row = $result->fetch_assoc();
    $stored_password = $row['password'];

    // Check if the current password matches the stored password
    if ($current_password !== $stored_password) {
        // Current password is incorrect
        echo json_encode([
            'status' => false,
            'message' => 'Incorrect current password.',
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Update the password in the database with plain text (consider hashing for production)
    $update_sql = "UPDATE add_patient SET password = ? WHERE patient_id = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("ss", $new_password, $patient_id);

    if ($update_stmt->execute()) {
        echo json_encode([
            'status' => true,
            'message' => 'Password updated successfully.',
        ], JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => false,
            'message' => 'Failed to update password.',
        ], JSON_PRETTY_PRINT);
    }

    // Close the statements and connection
    $stmt->close();
    $update_stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => false,
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
