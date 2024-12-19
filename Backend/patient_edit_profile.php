<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $patient_id = $_POST['patient_id'] ?? '';

    if (empty($patient_id)) {
        echo json_encode([
            'status' => 'false',
            'message' => 'Patient ID is required.',
        ]);
        exit;
    }

    // Define variables for each field, with default values if not provided
    $patient_name = $_POST['patient_name'] ?? null;
    $age = $_POST['age'] ?? null;
    $gender = $_POST['gender'] ?? null;
    $height = $_POST['height'] ?? null;
    $dry_weight = $_POST['dry_weight'] ?? null;
    $bmi = $_POST['bmi'] ?? null;
    $date_of_initiation = $_POST['date_of_initiation'] ?? null;
    $dialysis_vintage = $_POST['dialysis_vintage'] ?? null;
    $vegetarian = $_POST['vegetarian'] ?? null;
    $non_vegetarian = $_POST['non_vegetarian'] ?? null;
    $both_food = $_POST['both_food'] ?? null;
    $mobile_number = $_POST['mobile_number'] ?? null;

    // Logic to ensure only one food type is set to 'yes'
    if ($vegetarian === 'yes') {
        $non_vegetarian = 'no';
        $both_food = 'no';
    } elseif ($non_vegetarian === 'yes') {
        $vegetarian = 'no';
        $both_food = 'no';
    } elseif ($both_food === 'yes') {
        $vegetarian = 'no';
        $non_vegetarian = 'no';
    }

    // Create the SQL query dynamically based on which fields are provided
    $sql = "UPDATE add_patient SET ";
    $params = [];
    $types = "";

    if ($patient_name) {
        $sql .= "patient_name = ?, ";
        $params[] = &$patient_name;
        $types .= "s";
    }
    if ($age) {
        $sql .= "age = ?, ";
        $params[] = &$age;
        $types .= "i";
    }
    if ($gender) {
        $sql .= "gender = ?, ";
        $params[] = &$gender;
        $types .= "s";
    }
    if ($height) {
        $sql .= "height = ?, ";
        $params[] = &$height;
        $types .= "s";
    }
    if ($dry_weight) {
        $sql .= "weight = ?, ";
        $params[] = &$dry_weight;
        $types .= "s";
    }
    if ($bmi) {
        $sql .= "body_mass_index = ?, ";
        $params[] = &$bmi;
        $types .= "s";
    }
    if ($date_of_initiation) {
        $sql .= "date_of_initiation = ?, ";
        $params[] = &$date_of_initiation;
        $types .= "s";
    }
    if ($dialysis_vintage) {
        $sql .= "dialysis_vintage = ?, ";
        $params[] = &$dialysis_vintage;
        $types .= "s";
    }
    if ($vegetarian) {
        $sql .= "vegetarian = ?, ";
        $params[] = &$vegetarian;
        $types .= "s";
    }
    if ($non_vegetarian) {
        $sql .= "non_vegetarian = ?, ";
        $params[] = &$non_vegetarian;
        $types .= "s";
    }
    if ($both_food) {
        $sql .= "both_food = ?, ";
        $params[] = &$both_food;
        $types .= "s";
    }
    if ($mobile_number) {
        $sql .= "mobile_number = ?, ";
        $params[] = &$mobile_number;
        $types .= "s";
    }

    // Remove the trailing comma and space, and add the WHERE clause
    $sql = rtrim($sql, ', ') . " WHERE patient_id = ?";
    $params[] = &$patient_id;
    $types .= "s";

    // Prepare the statement
    $stmt = $conn->prepare($sql);

    // Check if the statement prepared successfully
    if (!$stmt) {
        echo json_encode([
            'status' => 'false',
            'message' => 'Database error: ' . $conn->error,
        ]);
        exit;
    }

    // Bind parameters dynamically
    $stmt->bind_param($types, ...$params);

    // Execute the query
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'true',
            'message' => 'Patient profile updated successfully.',
        ]);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'Failed to update patient profile.',
        ]);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ]);
}
?>
