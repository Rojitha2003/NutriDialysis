import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure the correct URL is imported for DisplayCaseSheeturl

Future<Map<String, dynamic>> fetchCaseSheetData(
    {required String patientId}) async {
  try {
    // Constructing the body for the request
    final Map<String, String> body = {
      'patient_id': patientId,
    };

    // Defining the headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // Making the POST request to DisplayCaseSheeturl
    final response = await http.post(
      Uri.parse(DisplayCaseSheeturl),
      headers: headers,
      body: body,
    );

    // Checking the response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'true') {
        // Return the fetched data if the status is true
        return {
          'status': true,
          'message': responseData['message'],
          'data': responseData['data'], // Here, the fetched data is returned
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
    return {
      'status': false,
      'message': 'An error occurred: $e',
    };
  }
}
