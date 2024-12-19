<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json'); // Ensure the response is sent as JSON

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Log incoming POST data
    error_log('POST data: ' . print_r($_POST, true)); // Log all POST data for debugging

    $video_title = isset($_POST['video_title']) ? trim($_POST['video_title']) : '';
    $video_url = isset($_POST['video_url']) ? trim($_POST['video_url']) : '';

    // Validate inputs
    if (empty($video_title) || empty($video_url)) {
        echo json_encode([
            'status' => false,
            'message' => 'Video title and URL are required.',
        ]);
        exit;
    }

    // Generate a random video ID
    $video_id = str_pad(mt_rand(1000, 9999), 4, '0', STR_PAD_LEFT);

    // Prepare the SQL statement for insertion
    $sql = "INSERT INTO upload_videos (video_id, title, youtube_url) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        $stmt->bind_param("sss", $video_id, $video_title, $video_url);

        if ($stmt->execute()) {
            echo json_encode([
                'status' => true,
                'message' => 'Video added successfully.',
                'video_id' => $video_id,
            ]);
        } else {
            echo json_encode([
                'status' => false,
                'message' => 'Failed to add video.',
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
