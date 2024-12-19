import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure CaseSheeturl is correctly imported

Future<Map<String, dynamic>> addCaseSheet({
  required String patientId, // Fetch this from the previous page
  required String t2dm,
  required String htn,
  required String cva,
  required String cvd,
  required String description,
  required String ivj,
  required String leftIvj,
  required String rightIvj,
  required String femoral,
  required String leftFemoral,
  required String rightFemoral,
  required String radiocephalicFistula,
  required String leftRadiocephalicFistula,
  required String rightRadiocephalicFistula,
  required String brachiocephalicFistula,
  required String leftBrachiocephalicFistula,
  required String rightBrachiocephalicFistula,
  required String avg,
  required String leftAvg,
  required String rightAvg,
}) async {
  try {
    // Constructing the body as per PHP code requirements
    final Map<String, String> body = {
      'patient_id': patientId,
      't2dm': t2dm,
      'htn': htn,
      'cva': cva,
      'cvd': cvd,
      'description': description,
      'ivj': ivj,
      'left_ivj': leftIvj,
      'right_ivj': rightIvj,
      'femoral': femoral,
      'left_femoral': leftFemoral,
      'right_femoral': rightFemoral,
      'radiocephalic_fistula': radiocephalicFistula,
      'left_radiocephalic_fistula': leftRadiocephalicFistula,
      'right_radiocephalic_fistula': rightRadiocephalicFistula,
      'brachiocephalic_fistula': brachiocephalicFistula,
      'left_brachiocephalic_fistula': leftBrachiocephalicFistula,
      'right_brachiocephalic_fistula': rightBrachiocephalicFistula,
      'avg': avg,
      'left_avg': leftAvg,
      'right_avg': rightAvg,
    };

    // Defining the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Making the POST request
    final response = await http.post(
      Uri.parse(CaseSheeturl),
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
