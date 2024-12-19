// patient_loginapi.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../patient_home_page.dart';
import '../api.dart'; // Import to access global variables

Future<Map<String, dynamic>> patientLogin(String inputPatientId,
    String password, BuildContext context, String url) async {
  try {
    // Send POST request with patient_id and password
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "patient_id": inputPatientId,
        "password": password,
      },
    );

    // Check for success response code (200)
    if (response.statusCode == 200) {
      // Decode JSON response
      final data = json.decode(response.body);

      // Check if the login was successful
      if (data["status"] == "true") {
        // Store fetched patientId and patientName in global variables
        patientId = data["patient_id"];
        patientName = data["patient_name"];

        // Successful login, navigate to PatientHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientHomePage(
              patientId: patientId,
              patientName: patientName,
            ),
          ),
        );

        return {
          "success": true,
          "message": data["message"],
          "patient_id": patientId,
          "patient_name": patientName,
        };
      } else {
        // Display error message if login fails
        String errorMessage =
            data["message"] ?? "Invalid patient ID or password.";
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      // Handle unexpected status code
      _showErrorDialog(context, "Error: ${response.statusCode}");
      return {
        "success": false,
        "message": "Error: ${response.statusCode}",
      };
    }
  } catch (e) {
    // Handle any other errors
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
      title: Text("Login Failed"),
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
