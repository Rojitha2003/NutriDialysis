<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the required details from the POST request
    $name = $_POST['name'];
    $specialization = $_POST['specialization'];
    $password = $_POST['password'];
    $mobile_number = $_POST['mobile_number'];

    // Generate the doctor ID in the format drxxxx where xxxx are random 4 digits
    $doctor_id = 'dr' . str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);

    // Prepare the SQL statement
    $sql = "INSERT INTO doctor (doctor_id, name, specialization, password, mobile_number) 
            VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssss", $doctor_id, $name, $specialization, $password, $mobile_number);

    // Execute the statement
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'true',
            'message' => 'Doctor details added successfully',
            'doctor_id' => $doctor_id,
        ], JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'Failed to add doctor details.',
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
