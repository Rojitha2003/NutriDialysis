import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure Addpatienturl is correctly imported

Future<Map<String, dynamic>> addPatient({
  required String patientName,
  required String age,
  required String gender,
  required String height,
  required String weight,
  required String bodyMassIndex,
  required String dateOfInitiation,
  required String dialysisVintage,
  required String mobileNumber,
  required String password,
  required String vegetarian,
  required String nonVegetarian,
  required String bothFood,
}) async {
  try {
    // Constructing the body as per PHP code requirements
    final Map<String, String> body = {
      'patient_name': patientName,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'body_mass_index': bodyMassIndex,
      'date_of_initiation': dateOfInitiation,
      'dialysis_vintage': dialysisVintage,
      'mobile_number': mobileNumber,
      'password': password,
      'vegetarian': vegetarian,
      'non_vegetarian': nonVegetarian,
      'both_food': bothFood,
    };

    // Defining the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Making the POST request
    final response = await http.post(
      Uri.parse(AddPatienturl),
      headers: headers,
      body: body,
    );

    // Checking the response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        return {
          'status': true,
          'message': responseData['message'],
          'patient_id': responseData['patient_id'],
        };
      } else {
        return {'status': false, 'message': responseData['message']};
      }
    } else {
      return {
        'status': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {'status': false, 'message': 'An error occurred: $e'};
  }
}
