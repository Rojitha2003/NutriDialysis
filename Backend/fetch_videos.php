<?php
// Include the database connection file
include '_con.php';

// Set response header to JSON
header('Content-Type: application/json');

// Check if the request method is valid (POST or GET)
if ($_SERVER['REQUEST_METHOD'] === 'POST' || $_SERVER['REQUEST_METHOD'] === 'GET') {
    // Array to store the fetched videos
    $videos = [];

    try {
        // SQL query to fetch video details
        $sql = "SELECT video_id, title, youtube_url FROM upload_videos";
        $result = $conn->query($sql);

        // Check if the query returns any rows
        if ($result && $result->num_rows > 0) {
            // Fetch each row and add it to the videos array
            while ($row = $result->fetch_assoc()) {
                $videos[] = $row;
            }
            // Respond with the videos data
            echo json_encode([
                'status' => true,
                'message' => 'Videos fetched successfully.',
                'videos' => $videos,
            ]);
        } else {
            // Respond if no videos are found
            echo json_encode([
                'status' => false,
                'message' => 'No videos found.',
                'videos' => [],
            ]);
        }
    } catch (Exception $e) {
        // Respond with an error message if an exception occurs
        echo json_encode([
            'status' => false,
            'message' => 'Error fetching videos: ' . $e->getMessage(),
            'videos' => [],
        ]);
    } finally {
        // Close the database connection
        $conn->close();
    }
} else {
    // Respond for invalid request methods
    echo json_encode([
        'status' => false,
        'message' => 'Invalid request method. Use POST or GET.',
        'videos' => [],
    ]);
}
?>
