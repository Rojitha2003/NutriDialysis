<?php
include '_con.php'; // Include your database connection file

// Set header for JSON response
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the posted data and trim whitespace
    $doctor_id = isset($_POST['doctor_id']) ? trim($_POST['doctor_id']) : '';
    $current_password = isset($_POST['current_password']) ? trim($_POST['current_password']) : '';
    $new_password = isset($_POST['new_password']) ? trim($_POST['new_password']) : '';
    $confirm_password = isset($_POST['confirm_password']) ? trim($_POST['confirm_password']) : '';

    // Validate that all required fields are provided
    if (empty($doctor_id) || empty($current_password) || empty($new_password) || empty($confirm_password)) {
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

    // Fetch the stored password for the doctor
    $sql = "SELECT password FROM doctor WHERE doctor_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $doctor_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        // Doctor ID not found
        echo json_encode([
            'status' => false,
            'message' => 'Doctor not found.',
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

    // Update the password in the database with plain text
    $update_sql = "UPDATE doctor SET password = ? WHERE doctor_id = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("ss", $new_password, $doctor_id);

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
