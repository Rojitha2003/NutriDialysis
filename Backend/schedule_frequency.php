<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the patient_id from the POST request
    $patient_id = $_POST['patient_id'];

    // Fetch the patient_id from the add_patient table to ensure it exists
    $check_patient_sql = "SELECT patient_id FROM add_patient WHERE patient_id = ?";
    $check_patient_stmt = $conn->prepare($check_patient_sql);
    $check_patient_stmt->bind_param("s", $patient_id);
    $check_patient_stmt->execute();
    $check_patient_stmt->store_result();

    if ($check_patient_stmt->num_rows > 0) {
        // Patient exists, now collect selected days
        $sunday = $_POST['sunday'] === 'yes' ? 'yes' : 'no';
        $monday = $_POST['monday'] === 'yes' ? 'yes' : 'no';
        $tuesday = $_POST['tuesday'] === 'yes' ? 'yes' : 'no';
        $wednesday = $_POST['wednesday'] === 'yes' ? 'yes' : 'no';
        $thursday = $_POST['thursday'] === 'yes' ? 'yes' : 'no';
        $friday = $_POST['friday'] === 'yes' ? 'yes' : 'no';
        $saturday = $_POST['saturday'] === 'yes' ? 'yes' : 'no';

        // Check if a schedule already exists for the patient
        $check_schedule_sql = "SELECT patient_id FROM schedule_frequency WHERE patient_id = ?";
        $check_schedule_stmt = $conn->prepare($check_schedule_sql);
        $check_schedule_stmt->bind_param("s", $patient_id);
        $check_schedule_stmt->execute();
        $check_schedule_stmt->store_result();

        if ($check_schedule_stmt->num_rows > 0) {
            // Record exists, update the schedule
            $sql = "UPDATE schedule_frequency 
                    SET sunday = ?, monday = ?, tuesday = ?, wednesday = ?, thursday = ?, friday = ?, saturday = ?
                    WHERE patient_id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssssssss", $sunday, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday, $patient_id);

            if ($stmt->execute()) {
                echo json_encode([
                    'status' => 'true',
                    'message' => 'Schedule updated successfully'
                ], JSON_PRETTY_PRINT);
            } else {
                echo json_encode([
                    'status' => 'false',
                    'message' => 'Failed to update schedule'
                ], JSON_PRETTY_PRINT);
            }
        } else {
            // No record exists, insert a new schedule
            $sql = "INSERT INTO schedule_frequency (patient_id, sunday, monday, tuesday, wednesday, thursday, friday, saturday) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssssssss", $patient_id, $sunday, $monday, $tuesday, $wednesday, $thursday, $friday, $saturday);

            if ($stmt->execute()) {
                echo json_encode([
                    'status' => 'true',
                    'message' => 'Schedule saved successfully'
                ], JSON_PRETTY_PRINT);
            } else {
                echo json_encode([
                    'status' => 'false',
                    'message' => 'Failed to save schedule'
                ], JSON_PRETTY_PRINT);
            }
        }

        $stmt->close();
        $check_schedule_stmt->close();
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'Invalid patient ID.'
        ], JSON_PRETTY_PRINT);
    }

    $check_patient_stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
