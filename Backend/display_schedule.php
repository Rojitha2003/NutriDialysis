<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the raw POST data and decode it
    $input = json_decode(file_get_contents('php://input'), true);

    // Check if patient_id is sent in the request body
    if (isset($input['patient_id'])) {
        $patient_id = $input['patient_id'];

        // Fetch the patient_id from the add_patient table to ensure it exists
        $check_patient_sql = "SELECT patient_id FROM add_patient WHERE patient_id = ?";
        $check_patient_stmt = $conn->prepare($check_patient_sql);
        $check_patient_stmt->bind_param("s", $patient_id);
        $check_patient_stmt->execute();
        $check_patient_stmt->store_result();

        if ($check_patient_stmt->num_rows > 0) {
            // Patient exists, now fetch schedule data
            $fetch_schedule_sql = "SELECT sunday, monday, tuesday, wednesday, thursday, friday, saturday FROM schedule_frequency WHERE patient_id = ?";
            $fetch_schedule_stmt = $conn->prepare($fetch_schedule_sql);
            $fetch_schedule_stmt->bind_param("s", $patient_id);
            $fetch_schedule_stmt->execute();
            $fetch_schedule_result = $fetch_schedule_stmt->get_result();

            if ($fetch_schedule_result->num_rows > 0) {
                $schedule = $fetch_schedule_result->fetch_assoc();

                echo json_encode([
                    'status' => 'true',
                    'message' => 'Schedule retrieved successfully',
                    'schedule' => [
                        'sunday' => $schedule['sunday'],
                        'monday' => $schedule['monday'],
                        'tuesday' => $schedule['tuesday'],
                        'wednesday' => $schedule['wednesday'],
                        'thursday' => $schedule['thursday'],
                        'friday' => $schedule['friday'],
                        'saturday' => $schedule['saturday']
                    ]
                ], JSON_PRETTY_PRINT);
            } else {
                echo json_encode([
                    'status' => 'false',
                    'message' => 'No schedule found for the provided patient ID',
                ], JSON_PRETTY_PRINT);
            }

            $fetch_schedule_stmt->close();
        } else {
            echo json_encode([
                'status' => 'false',
                'message' => 'Invalid patient ID.',
            ], JSON_PRETTY_PRINT);
        }

        $check_patient_stmt->close();
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'Patient ID is missing in request body.',
        ], JSON_PRETTY_PRINT);
    }

    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
