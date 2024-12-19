import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file

// Function to fetch patient details
Future<Map<String, dynamic>> fetchPatientProfile(
    String patientId, BuildContext context) async {
  final url =
      Uri.parse(PatientProfileurl); // Replace with your actual server URL

  try {
    // Send POST request with patient_id as body
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "patient_id": patientId,
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = json.decode(response.body);

      // Check if the response contains valid data
      if (data['status'] == 'true') {
        // Successfully fetched patient data
        return {
          "success": true,
          "data": data,
        };
      } else {
        // Handle case when patient data is not found
        String errorMessage = data["message"] ?? "No patient found.";
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      // Handle non-200 status codes
      String errorMessage = "Server returned: ${response.statusCode}";
      _showErrorDialog(context, errorMessage);
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
    // Handle errors (e.g., network issues)
    _showErrorDialog(context, "An error occurred: $e");
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
  }
}

// Function to show error dialog
void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}
