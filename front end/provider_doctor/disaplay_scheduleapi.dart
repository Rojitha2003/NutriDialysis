import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart';

Future<Map<String, dynamic>> fetchPatientSchedule(String patientId) async {
  final url = Uri.parse(DisplayScheduleurl);

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({'patient_id': patientId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'success': data['status'] == 'true',
        'schedule': data['schedule'] ?? {},
        'message': data['message'],
      };
    } else {
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}'
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'Error: $e'};
  }
}
