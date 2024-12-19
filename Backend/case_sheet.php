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
        // Patient exists, now collect case sheet parameters (yes or no)
        $t2dm = $_POST['t2dm'] === 'yes' ? 'yes' : 'no';
        $htn = $_POST['htn'] === 'yes' ? 'yes' : 'no';
        $cva = $_POST['cva'] === 'yes' ? 'yes' : 'no';
        $cvd = $_POST['cvd'] === 'yes' ? 'yes' : 'no';
        $description = $_POST['description'];
        
        // Handle ivj logic
        $ivj = $_POST['ivj'] === 'yes' ? 'yes' : 'no';
        if ($ivj === 'yes') {
            // If ivj is yes, only one of left_ivj or right_ivj can be yes
            $left_ivj = $_POST['left_ivj'] === 'yes' ? 'yes' : 'no';
            $right_ivj = ($left_ivj === 'no' && $_POST['right_ivj'] === 'yes') ? 'yes' : 'no';
        } else {
            // If ivj is no, both left_ivj and right_ivj must be no
            $left_ivj = 'no';
            $right_ivj = 'no';
        }

        // Handle femoral logic
        $femoral = $_POST['femoral'] === 'yes' ? 'yes' : 'no';
        if ($femoral === 'yes') {
            // If femoral is yes, only one of left_femoral or right_femoral can be yes
            $left_femoral = $_POST['left_femoral'] === 'yes' ? 'yes' : 'no';
            $right_femoral = ($left_femoral === 'no' && $_POST['right_femoral'] === 'yes') ? 'yes' : 'no';
        } else {
            // If femoral is no, both left_femoral and right_femoral must be no
            $left_femoral = 'no';
            $right_femoral = 'no';
        }

        // Handle radiocephalic fistula logic
        $radiocephalic_fistula = $_POST['radiocephalic_fistula'] === 'yes' ? 'yes' : 'no';
        if ($radiocephalic_fistula === 'yes') {
            $left_radiocephalic_fistula = $_POST['left_radiocephalic_fistula'] === 'yes' ? 'yes' : 'no';
            $right_radiocephalic_fistula = ($left_radiocephalic_fistula === 'no' && $_POST['right_radiocephalic_fistula'] === 'yes') ? 'yes' : 'no';
        } else {
            $left_radiocephalic_fistula = 'no';
            $right_radiocephalic_fistula = 'no';
        }

        // Handle brachiocephalic fistula logic
        $brachiocephalic_fistula = $_POST['brachiocephalic_fistula'] === 'yes' ? 'yes' : 'no';
        if ($brachiocephalic_fistula === 'yes') {
            $left_brachiocephalic_fistula = $_POST['left_brachiocephalic_fistula'] === 'yes' ? 'yes' : 'no';
            $right_brachiocephalic_fistula = ($left_brachiocephalic_fistula === 'no' && $_POST['right_brachiocephalic_fistula'] === 'yes') ? 'yes' : 'no';
        } else {
            $left_brachiocephalic_fistula = 'no';
            $right_brachiocephalic_fistula = 'no';
        }

        // Handle AVG logic
        $avg = $_POST['avg'] === 'yes' ? 'yes' : 'no';
        if ($avg === 'yes') {
            $left_avg = $_POST['left_avg'] === 'yes' ? 'yes' : 'no';
            $right_avg = ($left_avg === 'no' && $_POST['right_avg'] === 'yes') ? 'yes' : 'no';
        } else {
            $left_avg = 'no';
            $right_avg = 'no';
        }

        // Prepare the SQL statement to insert into the case_sheet table
        $sql = "INSERT INTO case_sheet (patient_id, t2dm, htn, cva, cvd, description, ivj, left_ivj, right_ivj, femoral, left_femoral, right_femoral, radiocephalic_fistula, left_radiocephalic_fistula, right_radiocephalic_fistula, brachiocephalic_fistula, left_brachiocephalic_fistula, right_brachiocephalic_fistula, avg, left_avg, right_avg) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sssssssssssssssssssss", $patient_id, $t2dm, $htn, $cva, $cvd, $description, $ivj, $left_ivj, $right_ivj, $femoral, $left_femoral, $right_femoral, $radiocephalic_fistula, $left_radiocephalic_fistula, $right_radiocephalic_fistula, $brachiocephalic_fistula, $left_brachiocephalic_fistula, $right_brachiocephalic_fistula, $avg, $left_avg, $right_avg);

        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode([
                'status' => 'true',
                'message' => 'Case sheet data entered successfully'
            ], JSON_PRETTY_PRINT);
        } else {
            echo json_encode([
                'status' => 'false',
                'message' => 'Failed to enter case sheet data.'
            ], JSON_PRETTY_PRINT);
        }

        // Close the statement and connection
        $stmt->close();
    } else {
        // Patient ID not found
        echo json_encode([
            'status' => 'false',
            'message' => 'Invalid patient ID.'
        ], JSON_PRETTY_PRINT);
    }
    
    // Close the patient check statement
    $check_patient_stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
