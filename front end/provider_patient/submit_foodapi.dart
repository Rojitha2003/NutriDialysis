import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure SubmitFoodurl and patientId are correctly imported

Future<Map<String, dynamic>> submitFoodData({
  required String foodTime,
  required List<Map<String, dynamic>> foodSets,
}) async {
  try {
    // Fetch patientId from api.dart
    // ignore: unnecessary_null_comparison
    if (patientId == null || patientId.isEmpty) {
      throw Exception("Patient ID is not set or invalid.");
    }

    // Construct the request body
    final Map<String, dynamic> body = {
      'patient_id': patientId, // Ensure this is fetched directly from api.dart
      'food_time': foodTime,
      'sets': foodSets,
    };

    // Define headers
    final headers = {
      'Content-Type': 'application/json',
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(SubmitFoodurl),
      headers: headers,
      body: json.encode(body),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': responseData['status'] == "true",
        'message': responseData['message'],
      };
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
