import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file, including patientId

// Function to edit patient profile
Future<Map<String, dynamic>> patientEditProfile({
  required String patientName,
  required String age,
  required String gender,
  required String height,
  required String dryWeight,
  required String bmi,
  required String dateOfInitiation,
  required String dialysisVintage,
  required String vegetarian,
  required String nonVegetarian,
  required String bothFood,
  required String mobileNumber,
  required BuildContext context,
}) async {
  final url = Uri.parse(PatientEditProfileurl); // Your actual server URL

  try {
    // Check if patientId is available
    // Assuming patientId is stored globally (e.g., in api.dart)
    // ignore: unnecessary_null_comparison
    if (patientId == null || patientId.isEmpty) {
      // If patientId is missing, show an error dialog
      _showErrorDialog(context, "Patient ID is missing. Please try again.");
      return {
        "success": false,
        "message": "Patient ID is missing. Please try again.",
      };
    }

    // Send POST request with the required fields, including the patientId
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "patient_id": patientId, // Use patientId from api.dart
        "patient_name": patientName,
        "age": age,
        "gender": gender,
        "height": height,
        "dry_weight": dryWeight,
        "bmi": bmi,
        "date_of_initiation": dateOfInitiation,
        "dialysis_vintage": dialysisVintage,
        "vegetarian": vegetarian,
        "non_vegetarian": nonVegetarian,
        "both_food": bothFood,
        "mobile_number": mobileNumber,
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the profile update was successful
      if (data['status'] == "true") {
        return {
          "success": true,
          "message": data["message"],
        };
      } else {
        String errorMessage = data["message"] ?? "Profile update failed.";
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
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
