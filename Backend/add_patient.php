<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the required details from the POST request
    $patient_name = isset($_POST['patient_name']) ? trim($_POST['patient_name']) : '';
    $age = isset($_POST['age']) ? (int) $_POST['age'] : 0;
    $gender = isset($_POST['gender']) ? trim($_POST['gender']) : '';
    $height = isset($_POST['height']) ? trim($_POST['height']) : '';
    $weight = isset($_POST['weight']) ? trim($_POST['weight']) : '';
    $body_mass_index = isset($_POST['body_mass_index']) ? trim($_POST['body_mass_index']) : ''; // Updated from bmi
    $date_of_initiation = isset($_POST['date_of_initiation']) ? trim($_POST['date_of_initiation']) : '';
    $dialysis_vintage = isset($_POST['dialysis_vintage']) ? trim($_POST['dialysis_vintage']) : '';
    $mobile_number = isset($_POST['mobile_number']) ? trim($_POST['mobile_number']) : '';
    $password = isset($_POST['password']) ? trim($_POST['password']) : '';

    // Validate required fields
    if (empty($patient_name) || empty($age) || empty($gender) || empty($height) || empty($weight) || empty($body_mass_index)) {
        echo json_encode([
            'status' => false,
            'message' => 'Some required fields are missing.',
        ], JSON_PRETTY_PRINT);
        exit;
    }

    // Vegetarian, Non-Vegetarian, Both-Food logic
    $vegetarian = $_POST['vegetarian'] === 'yes' ? 'yes' : 'no';
    $non_vegetarian = $_POST['non_vegetarian'] === 'yes' ? 'yes' : 'no';
    $both_food = $_POST['both_food'] === 'yes' ? 'yes' : 'no';

    // Ensure only one of the food preferences is set to 'yes'
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

    // Generate the patient ID based on the current timestamp in yymmddhhmi format
    $patient_id = date('ymdHi');

    // Prepare the SQL statement with updated column names
    $sql = "INSERT INTO add_patient (patient_id, patient_name, age, gender, height, weight, body_mass_index, date_of_initiation, dialysis_vintage, vegetarian, non_vegetarian, both_food, mobile_number, password) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssssssssssss", $patient_id, $patient_name, $age, $gender, $height, $weight, $body_mass_index, $date_of_initiation, $dialysis_vintage, $vegetarian, $non_vegetarian, $both_food, $mobile_number, $password);

    // Execute the statement
    if ($stmt->execute()) {
        echo json_encode([
            'status' => true,
            'message' => 'Data inserted successfully',
            'patient_id' => $patient_id,
        ], JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => false,
            'message' => 'Failed to add patient.',
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => false,
        'message' => 'Invalid request method.',
    ], JSON_PRETTY_PRINT);
}
?>
