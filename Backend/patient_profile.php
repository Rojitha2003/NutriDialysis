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

    $sql = "SELECT patient_name, age, gender, patient_id, height, weight AS dry_weight, body_mass_index AS bmi, date_of_initiation, dialysis_vintage, vegetarian, non_vegetarian, both_food, mobile_number 
            FROM add_patient 
            WHERE patient_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $patient_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $data = $result->fetch_assoc();

        // Determine the type of food consumed
        $type_of_food = 'No Data';
        if ($data['vegetarian'] === 'yes') {
            $type_of_food = 'Vegetarian';
        } elseif ($data['non_vegetarian'] === 'yes') {
            $type_of_food = 'Non-Vegetarian';
        } elseif ($data['both_food'] === 'yes') {
            $type_of_food = 'Both';
        }

        $response = [
            'status' => 'true',
            'name' => $data['patient_name'] ?? 'N/A',
            'age' => $data['age'] ?? 'N/A',
            'gender' => $data['gender'] ?? 'N/A',
            'patient_id' => $data['patient_id'] ?? 'N/A',
            'height' => $data['height'] ?? 'N/A',
            'dry_weight' => $data['dry_weight'] ?? 'N/A',
            'bmi' => $data['bmi'] ?? 'N/A',
            'date_of_initiation' => $data['date_of_initiation'] ?? 'N/A',
            'dialysis_vintage' => $data['dialysis_vintage'] ?? 'N/A',
            'food_type' => $type_of_food,
            'mobile' => $data['mobile_number'] ?? 'N/A',
        ];

        echo json_encode($response, JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'No patient found with the provided ID.',
        ]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.',
    ]);
}
