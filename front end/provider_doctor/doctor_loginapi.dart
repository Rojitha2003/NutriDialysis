// doctor_loginapi.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../doctor_home_page.dart';
import '../api.dart'; // Import api.dart to access doctorId and name variables

Future<Map<String, dynamic>> doctorLogin(String inputDoctorId, String password,
    BuildContext context, String url) async {
  try {
    // Send POST request with doctor_id and password as body
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "doctor_id": inputDoctorId,
        "password": password,
      },
    );

    // Check for success response code (200)
    if (response.statusCode == 200) {
      // Decode JSON response
      final data = json.decode(response.body);

      // Check status in response and return data accordingly
      if (data["status"] == "true") {
        // Store fetched doctor_id and name in global variables from api.dart
        doctorId = data["doctor_id"];
        name = data["name"];

        // Successful login, navigate to Doctor HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorHomePage(
              doctorId: doctorId,
              name: name,
            ),
          ),
        );

        return {
          "success": true,
          "message": data["message"],
          "doctor_id": doctorId,
          "name": name,
        };
      } else {
        // If login fails, show error message
        String errorMessage = data["message"] ?? "Unknown error";

        if (errorMessage.contains("incorrect") ||
            errorMessage.contains("Invalid")) {
          _showErrorDialog(
              context, "Invalid doctor ID or password. Please try again.");
        } else {
          _showErrorDialog(context, errorMessage);
        }

        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      // Handle other status codes
      _showErrorDialog(context, "Error: ${response.statusCode}");
      return {
        "success": false,
        "message": "Error: ${response.statusCode}",
      };
    }
  } catch (e) {
    // Handle any errors (e.g., network errors)
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
