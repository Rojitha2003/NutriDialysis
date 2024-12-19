<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the patient_id from the POST request
    $patient_id = $_POST['patient_id'];
    
    // Get the current date in 'YYYY-MM-DD' format
    $current_date = date('Y-m-d');
    
    // Fetch the patient_id and case sheet data for today using the time_stamp field
    $sql = "SELECT t2dm, htn, cva, cvd, description, ivj, left_ivj, right_ivj, femoral, left_femoral, right_femoral,
                   radiocephalic_fistula, left_radiocephalic_fistula, right_radiocephalic_fistula, brachiocephalic_fistula,
                   left_brachiocephalic_fistula, right_brachiocephalic_fistula, avg, left_avg, right_avg
            FROM case_sheet
            WHERE patient_id = ? AND DATE(time_stamp) = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $patient_id, $current_date);
    $stmt->execute();
    $stmt->store_result();
    
    if ($stmt->num_rows > 0) {
        // Fetch the data as an associative array
        $stmt->bind_result($t2dm, $htn, $cva, $cvd, $description, $ivj, $left_ivj, $right_ivj, $femoral, $left_femoral, 
                           $right_femoral, $radiocephalic_fistula, $left_radiocephalic_fistula, $right_radiocephalic_fistula, 
                           $brachiocephalic_fistula, $left_brachiocephalic_fistula, $right_brachiocephalic_fistula, $avg, 
                           $left_avg, $right_avg);
        
        $case_data = array();
        while ($stmt->fetch()) {
            $case_data[] = array(
                't2dm' => $t2dm,
                'htn' => $htn,
                'cva' => $cva,
                'cvd' => $cvd,
                'description' => $description,
                'ivj' => $ivj,
                'left_ivj' => $left_ivj,
                'right_ivj' => $right_ivj,
                'femoral' => $femoral,
                'left_femoral' => $left_femoral,
                'right_femoral' => $right_femoral,
                'radiocephalic_fistula' => $radiocephalic_fistula,
                'left_radiocephalic_fistula' => $left_radiocephalic_fistula,
                'right_radiocephalic_fistula' => $right_radiocephalic_fistula,
                'brachiocephalic_fistula' => $brachiocephalic_fistula,
                'left_brachiocephalic_fistula' => $left_brachiocephalic_fistula,
                'right_brachiocephalic_fistula' => $right_brachiocephalic_fistula,
                'avg' => $avg,
                'left_avg' => $left_avg,
                'right_avg' => $right_avg
            );
        }
        
        echo json_encode([
            'status' => 'true',
            'message' => 'Case sheet data fetched successfully',
            'data' => $case_data
        ], JSON_PRETTY_PRINT);
    } else {
        echo json_encode([
            'status' => 'false',
            'message' => 'No case sheet data found for today.'
        ], JSON_PRETTY_PRINT);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
