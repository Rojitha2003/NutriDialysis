<?php
// Include the database connection file
include '_con.php';

// Set the headers to force the browser to download the file
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="add_patient_data_export.csv"');

// Open the output stream
$output = fopen('php://output', 'w');

// Use a SQL query to fetch all rows from the 'add_patient' table
$query = "SELECT patient_id, patient_name, age, gender, height, weight, body_mass_index, date_of_initiation, dialysis_vintage, 
vegetarian, non_vegetarian, both_food, mobile_number, password FROM add_patient";

$result = $conn->query($query);

// Check if there are results
if ($result && $result->num_rows > 0) {
    // Fetch the field names (column headers) from the first row
    $fields = $result->fetch_fields();
    $header = [];
    foreach ($fields as $field) {
        $header[] = $field->name;  // Get the column name
    }

    // Write the column headers to the CSV file
    fputcsv($output, $header);

    // Write the data rows to the CSV file
    while ($row = $result->fetch_assoc()) {
        fputcsv($output, $row);  // Write each row
    }
} else {
    // Write a message if no data is found
    echo "No data found.";
}

// Close the output stream
fclose($output);

// Close the database connection
$conn->close();
?>
