import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api.dart';

Future<Map<String, dynamic>> updateScheduleFrequency({
  required String patientId,
  required Map<String, String> schedule,
}) async {
  final url = Uri.parse(ScheduleFrequencyurl);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'patient_id': patientId, ...schedule}, // Corrected key
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'status': data['status'] == 'true', 'message': data['message']};
    } else {
      return {'status': false, 'message': 'Server error'};
    }
  } catch (e) {
    return {'status': false, 'message': 'Error: $e'};
  }
}
