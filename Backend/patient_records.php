<?php
include '_con.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect the patient_id from the POST request
    $patient_id = $_POST['patient_id'];

    // Step 1: Check if the patient_id exists in the add_patient table
    $add_patient_sql = "SELECT patient_id FROM add_patient WHERE patient_id = ?";
    $add_patient_stmt = $conn->prepare($add_patient_sql);
    $add_patient_stmt->bind_param("s", $patient_id);
    $add_patient_stmt->execute();
    $add_patient_result = $add_patient_stmt->get_result();

    if ($add_patient_result->num_rows === 0) {
        // Patient ID does not exist in add_patient
        echo json_encode([
            'status' => 'false',
            'message' => 'Patient ID not found in add_patient.'
        ], JSON_PRETTY_PRINT);
    } else {
        $response = [];

        // Step 2: Fetch case_sheet data
        $case_sheet_sql = "SELECT patient_id, t2dm, htn, cva, cvd, description, ivj, left_ivj, right_ivj, femoral, left_femoral, right_femoral, radiocephalic_fistula, left_radiocephalic_fistula, right_radiocephalic_fistula, brachiocephalic_fistula, left_brachiocephalic_fistula, right_brachiocephalic_fistula, avg, left_avg, right_avg, time_stamp 
                           FROM case_sheet WHERE patient_id = ?";
        $case_sheet_stmt = $conn->prepare($case_sheet_sql);
        $case_sheet_stmt->bind_param("s", $patient_id);
        $case_sheet_stmt->execute();
        $case_sheet_result = $case_sheet_stmt->get_result();

        if ($case_sheet_result->num_rows > 0) {
            $case_sheet_data = [];
            while ($case_sheet = $case_sheet_result->fetch_assoc()) {
                $time_stamp = date('d/m/Y', strtotime($case_sheet['time_stamp']));
                $co_morbidities = [];
                if ($case_sheet['t2dm'] === 'yes') $co_morbidities[] = 'T2DM';
                if ($case_sheet['htn'] === 'yes') $co_morbidities[] = 'HTN';
                if ($case_sheet['cva'] === 'yes') $co_morbidities[] = 'CVA';
                if ($case_sheet['cvd'] === 'yes') $co_morbidities[] = 'CVD';
                if (!empty($case_sheet['description'])) $co_morbidities[] = $case_sheet['description'];

                $vascular_access = [];
                if ($case_sheet['ivj'] === 'yes') $vascular_access[] = 'IVJ (' . ($case_sheet['left_ivj'] === 'yes' ? 'Left' : 'Right') . ')';
                if ($case_sheet['femoral'] === 'yes') $vascular_access[] = 'Femoral (' . ($case_sheet['left_femoral'] === 'yes' ? 'Left' : 'Right') . ')';
                if ($case_sheet['radiocephalic_fistula'] === 'yes') $vascular_access[] = 'Radiocephalic Fistula (' . ($case_sheet['left_radiocephalic_fistula'] === 'yes' ? 'Left' : 'Right') . ')';
                if ($case_sheet['brachiocephalic_fistula'] === 'yes') $vascular_access[] = 'Brachiocephalic Fistula (' . ($case_sheet['left_brachiocephalic_fistula'] === 'yes' ? 'Left' : 'Right') . ')';
                if ($case_sheet['avg'] === 'yes') $vascular_access[] = 'AVG (' . ($case_sheet['left_avg'] === 'yes' ? 'Left' : 'Right') . ')';

                $case_sheet_data[] = [
                    'time_stamp' => $time_stamp,
                    'co_morbidities' => $co_morbidities,
                    'vascular_access' => $vascular_access
                ];
            }
            $response['case_sheet'] = $case_sheet_data;
        }

        // Step 3: Fetch dialysis_data
        $dialysis_sql = "SELECT weight, weight_gain, pre_bp, post_bp, urine_output, tricep_skinfold_thickness, hand_grip, time_stamp FROM dialysis_data WHERE patient_id = ? ORDER BY time_stamp DESC";
        $dialysis_stmt = $conn->prepare($dialysis_sql);
        $dialysis_stmt->bind_param("s", $patient_id);
        $dialysis_stmt->execute();
        $dialysis_result = $dialysis_stmt->get_result();

        if ($dialysis_result->num_rows > 0) {
            $dialysis_data = [];
            while ($dialysis = $dialysis_result->fetch_assoc()) {
                $dialysis_data[] = [
                    'time_stamp' => date('d/m/Y', strtotime($dialysis['time_stamp'])),
                    'weight' => $dialysis['weight'],
                    'weight_gain' => $dialysis['weight_gain'],
                    'pre_bp' => $dialysis['pre_bp'],
                    'post_bp' => $dialysis['post_bp'],
                    'urine_output' => $dialysis['urine_output'],
                    'tricep_skinfold_thickness' => $dialysis['tricep_skinfold_thickness'],
                    'hand_grip' => $dialysis['hand_grip']
                ];
            }
            $response['dialysis_data'] = $dialysis_data;
        }

        // Step 4: Fetch investigations
        $investigations_sql = "SELECT hemoglobin, pcv, total_wbc_count, creatinine, potassium, serum_cholesterol, serum_albumin, bicarbonate, ejection_fraction, time_stamp FROM investigations WHERE patient_id = ? ORDER BY time_stamp DESC";
        $investigations_stmt = $conn->prepare($investigations_sql);
        $investigations_stmt->bind_param("s", $patient_id);
        $investigations_stmt->execute();
        $investigations_result = $investigations_stmt->get_result();

        if ($investigations_result->num_rows > 0) {
            $investigations_data = [];
            while ($investigation = $investigations_result->fetch_assoc()) {
                $investigations_data[] = [
                    'time_stamp' => date('d/m/Y', strtotime($investigation['time_stamp'])),
                    'hemoglobin' => $investigation['hemoglobin'],
                    'pcv' => $investigation['pcv'],
                    'total_wbc_count' => $investigation['total_wbc_count'],
                    'creatinine' => $investigation['creatinine'],
                    'potassium' => $investigation['potassium'],
                    'serum_cholesterol' => $investigation['serum_cholesterol'],
                    'serum_albumin' => $investigation['serum_albumin'],
                    'bicarbonate' => $investigation['bicarbonate'],
                    'ejection_fraction' => $investigation['ejection_fraction']
                ];
            }
            $response['investigations'] = $investigations_data;
        }

        // Output the combined data
        echo json_encode($response, JSON_PRETTY_PRINT);

        // Close the statements
        $case_sheet_stmt->close();
        $dialysis_stmt->close();
        $investigations_stmt->close();
    }

    // Close the add_patient statement
    $add_patient_stmt->close();

    // Close the connection
    $conn->close();
} else {
    echo json_encode([
        'status' => 'false',
        'message' => 'Invalid request method.'
    ], JSON_PRETTY_PRINT);
}
?>
