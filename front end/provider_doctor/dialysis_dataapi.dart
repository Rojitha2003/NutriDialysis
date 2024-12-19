import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure DialysisDataurl is correctly imported

Future<Map<String, dynamic>> saveDialysisData({
  required String patientId,
  required String weight,
  required String weightGain,
  required String preBP,
  required String postBP,
  required String urineOutput,
  required String tricepSkinfoldThickness,
  required String handGrip,
}) async {
  try {
    // Log inputs to verify data being sent
    print('Saving Dialysis Data for Patient ID: $patientId');
    print('Weight: $weight');
    print('Weight Gain: $weightGain');
    print('Pre BP: $preBP');
    print('Post BP: $postBP');
    print('Urine Output: $urineOutput');
    print('Tricep Skinfold Thickness: $tricepSkinfoldThickness');
    print('Hand Grip: $handGrip');

    // Constructing the body as per PHP code requirements
    final Map<String, String> body = {
      'patient_id': patientId,
      'weight': weight,
      'weight_gain': weightGain,
      'pre_bp': preBP,
      'post_bp': postBP,
      'urine_output': urineOutput,
      'tricep_skinfold_thickness': tricepSkinfoldThickness,
      'hand_grip': handGrip,
    };

    // Log the body content
    print('Request Body: $body');

    // Defining the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Making the POST request
    final response = await http.post(
      Uri.parse(DialysisDataurl),
      headers: headers,
      body: body,
    );

    // Log response status and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Checking the response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Log the decoded response
      print('Decoded Response: $responseData');

      if (responseData['status'] == 'true') {
        return {
          'status': true,
          'message': responseData['message'],
        };
      } else if (responseData['status'] == 'info') {
        return {
          'status': 'info',
          'message': responseData['message'],
        };
      } else {
        return {
          'status': false,
          'message': responseData['message'],
        };
      }
    } else {
      return {
        'status': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    // Log the error
    print('Error: $e');
    return {'status': false, 'message': 'An error occurred: $e'};
  }
}
