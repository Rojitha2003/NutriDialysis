import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Ensure this imports patientId correctly

// Function to change the patient's password
Future<Map<String, dynamic>> patientChangePassword(
  String currentPassword,
  String newPassword,
  String confirmPassword,
  BuildContext context,
) async {
  final url = Uri.parse(PatientChangePasswordurl);

  try {
    // Send POST request with required fields as body
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "patient_id":
            patientId, // Ensure this is fetched directly from api.dart
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the password change was successful
      if (data['status'] == true) {
        return {
          "success": true,
          "message": data["message"],
        };
      } else {
        String errorMessage = data["message"] ?? "Password update failed.";
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      String errorMessage = "Server returned: ${response.statusCode}";
      _showErrorDialog(context, errorMessage);
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
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
