<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json'); // Ensure JSON response

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Debugging: Log raw POST data
    $raw_post_data = file_get_contents('php://input');
    error_log("Raw POST data: " . $raw_post_data); // Check server logs for this output

    // Collect the patient_id from the POST request
    $patient_id = $_POST['patient_id'] ?? null;

    // Debugging: Log received POST data
    error_log("Received POST data: " . json_encode($_POST));

    if (!$patient_id) {
        echo json_encode([
            'status' => 'false',
            'message' => 'Patient ID is required.'
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Get the current day of the week
    $current_day = strtolower(date('l')); // e.g., 'monday', 'tuesday'

    try {
        // Check if the patient exists in the schedule_frequency table
        $check_schedule_sql = "SELECT $current_day FROM schedule_frequency WHERE patient_id = ?";
        $stmt = $conn->prepare($check_schedule_sql);
        $stmt->bind_param("s", $patient_id);
        $stmt->execute();
        $stmt->bind_result($day_status);
        $stmt->fetch();
        $stmt->close();

        if ($day_status === 'yes') {
            echo json_encode([
                'status' => 'true',
                'message' => 'Dialysis is scheduled for today.',
                'current_day' => ucfirst($current_day),
                'day_status' => $day_status
            ], JSON_PRETTY_PRINT);
        } else {
            // Find the next scheduled day
            $next_day = getNextScheduledDay($patient_id, $current_day, $conn);
            if ($next_day) {
                echo json_encode([
                    'status' => 'false',
                    'message' => 'No dialysis scheduled for today. Next schedule is on ' . ucfirst($next_day) . '.',
                    'current_day' => ucfirst($current_day),
                    'day_status' => 'no',
                    'next_scheduled_day' => ucfirst($next_day)
                ], JSON_PRETTY_PRINT);
            } else {
                echo json_encode([
                    'status' => 'false',
                    'message' => 'No dialysis is scheduled in the future.',
                    'current_day' => ucfirst($current_day),
                    'day_status' => 'no'
                ], JSON_PRETTY_PRINT);
            }
        }
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

// Helper function to find the next scheduled day
function getNextScheduledDay($patient_id, $current_day, $conn) {
    $days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    $current_day_index = array_search($current_day, $days);

    for ($i = 1; $i < 7; $i++) {
        $next_day_index = ($current_day_index + $i) % 7;
        $next_day = $days[$next_day_index];

        $sql = "SELECT $next_day FROM schedule_frequency WHERE patient_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $patient_id);
        $stmt->execute();
        $stmt->bind_result($day_status);
        $stmt->fetch();
        $stmt->close();

        if ($day_status === 'yes') {
            return $next_day;
        }
    }

    return null; // No future scheduled days found
}
?>
