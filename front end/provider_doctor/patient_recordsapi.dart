import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dialysis_nutrition/api.dart';

// Function to fetch patient records
Future<Map<String, dynamic>> fetchPatientRecords({
  required String patientId,
  required BuildContext context,
}) async {
  final url = Uri.parse(PatientRecordsurl); // API URL from api.dart
  print("Requesting API with URL: $url");

  try {
    // Validate patientId
    if (patientId.isEmpty) {
      return {
        "success": false,
        "message": "Patient ID is missing. Please try again.",
      };
    }

    // Send POST request
    print("Sending POST request with patient_id: $patientId");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "patient_id": patientId,
      },
    );

    print("API Response Body: ${response.body}");

    // Handle API response
    if (response.statusCode == 200) {
      final responseBody = response.body;

      if (responseBody.isNotEmpty) {
        final data = json.decode(responseBody);

        if (data.containsKey("status") && data["status"] == "false") {
          return {
            "success": false,
            "message": data["message"] ?? "Unknown error occurred.",
          };
        }

        // Parse the data and return success
        return {
          "success": true,
          "data": {
            "case_sheet": data["case_sheet"] ?? [],
            "dialysis_data": data["dialysis_data"] ?? [],
            "investigations": data["investigations"] ?? [],
          },
        };
      } else {
        return {
          "success": false,
          "message": "Empty response body from server.",
        };
      }
    } else {
      return {
        "success": false,
        "message": "Server returned status code: ${response.statusCode}",
      };
    }
  } catch (e) {
    print("Error during API request: $e");
    return {
      "success": false,
      "message": "An error occurred while fetching patient records: $e",
    };
  }
}

// Function to display an error dialog
void showErrorDialog(BuildContext context, String message) {
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
