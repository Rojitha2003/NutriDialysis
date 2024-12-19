import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure Investigationsurl is correctly imported

Future<Map<String, dynamic>> addInvestigation({
  required String patientId,
  required String hemoglobin,
  required String pcv,
  required String totalWbcCount,
  required String creatinine,
  required String potassium,
  required String serumCholesterol,
  required String serumAlbumin,
  required String bicarbonate,
  required String ejectionFraction,
}) async {
  try {
    // Constructing the body as per PHP code requirements
    final Map<String, String> body = {
      'patient_id': patientId,
      'hemoglobin': hemoglobin,
      'pcv': pcv,
      'total_wbc_count': totalWbcCount,
      'creatinine': creatinine,
      'potassium': potassium,
      'serum_cholesterol': serumCholesterol,
      'serum_albumin': serumAlbumin,
      'bicarbonate': bicarbonate,
      'ejection_fraction': ejectionFraction,
    };

    // Defining the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Making the POST request
    final response = await http.post(
      Uri.parse(Investigationsurl),
      headers: headers,
      body: body,
    );

    // Checking the response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'true') {
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
