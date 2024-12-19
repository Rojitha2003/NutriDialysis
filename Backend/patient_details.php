<?php
include '_con.php'; // Include your database connection file

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the patient_id from the POST request
    $patient_id = $_POST['patient_id'];

    // Prepare the SQL statement to fetch the patient details based on patient_id
    $sql = "SELECT patient_name, age, gender, patient_id, height, weight, body_mass_index, date_of_initiation, dialysis_vintage, vegetarian, non_vegetarian, both_food, mobile_number 
            FROM add_patient 
            WHERE patient_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $patient_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $data = $result->fetch_assoc();
        
        // Determine the type of food consumed
        if ($data['vegetarian'] === 'yes') {
            $type_of_food = 'Vegetarian';
        } elseif ($data['non_vegetarian'] === 'yes') {
            $type_of_food = 'Non-Vegetarian';
        } elseif ($data['both_food'] === 'yes') {
            $type_of_food = 'Both';
        } else {
            $type_of_food = 'No Data'; // In case no type is specified
        }

        $response = [
            'patient_id' => $data['patient_id'] ?? 'No Data',
            'patient_name' => $data['patient_name'] ?? 'No Data',
            'age' => $data['age'] ?? 'No Data',
            'gender' => $data['gender'] ?? 'No Data',
            'height' => $data['height'] ?? 'No Data',
            'weight' => $data['weight'] ?? 'No Data',
            'body_mass_index' => $data['body_mass_index'] ?? 'No Data',
            'date_of_initiation' => $data['date_of_initiation'] ?? 'No Data',
            'dialysis_vintage' => $data['dialysis_vintage'] ?? 'No Data',
            'type_of_food_consumed' => $type_of_food,
            'mobile_number' => $data['mobile_number'] ?? 'No Data'
        ];

        // Output the patient data
        echo json_encode($response, JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'No patient found with the provided ID.',
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
