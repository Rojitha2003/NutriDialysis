import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api.dart'; // Import your API constants

Future<Map<String, dynamic>> checkScheduleFrequency({
  required String patientId,
}) async {
  final url = Uri.parse(CheckScheduleurl); // Replace with your actual API URL

  try {
    // Sending POST request to the server
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'patient_id': patientId},
    );

    if (response.statusCode == 200) {
      // Parse the response body
      final data = json.decode(response.body);
      return {
        'status': data['status'] == 'true',
        'message': data['message'],
        'current_day': data['current_day'],
        'day_status': data['day_status'],
        'next_scheduled_day':
            data['next_scheduled_day'] ?? null, // Optional field
      };
    } else {
      // If server response is not OK
      return {
        'status': false,
        'message': 'Server error. Status code: ${response.statusCode}'
      };
    }
  } catch (e) {
    // Handle exceptions
    return {'status': false, 'message': 'Error: $e'};
  }
}
