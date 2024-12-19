<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json'); // Ensure the response is sent as JSON

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Log incoming POST data
    error_log('POST data: ' . print_r($_POST, true)); // Log all POST data for debugging

    $video_id = isset($_POST['video_id']) ? trim($_POST['video_id']) : '';

    // Validate input
    if (empty($video_id)) {
        echo json_encode([
            'status' => false,
            'message' => 'Video ID is required.',
        ]);
        exit;
    }

    // Prepare the SQL statement for deletion
    $sql = "DELETE FROM upload_videos WHERE video_id = ?";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        $stmt->bind_param("s", $video_id);

        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                echo json_encode([
                    'status' => true,
                    'message' => 'Video deleted successfully.',
                ]);
            } else {
                echo json_encode([
                    'status' => false,
                    'message' => 'No video found with the provided ID.',
                ]);
            }
        } else {
            echo json_encode([
                'status' => false,
                'message' => 'Failed to delete the video.',
            ]);
        }
        $stmt->close();
    } else {
        echo json_encode([
            'status' => false,
            'message' => 'Error preparing the statement.',
        ]);
    }

    // Close the database connection
    $conn->close();
} else {
    // Invalid request method
    echo json_encode([
        'status' => false,
        'message' => 'Invalid request method. Use POST instead.',
    ]);
}
?>
