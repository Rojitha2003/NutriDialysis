import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Ensure this imports the patientId and Tableurl correctly

// Function to fetch deficiencies and food suggestions
Future<Map<String, dynamic>> fetchDeficienciesAndSuggestions(
    BuildContext context) async {
  final url = Uri.parse(Tableurl); // Ensure the endpoint URL is correct

  try {
    debugPrint("Sending POST request to URL: $url with patient_id: $patientId");

    // Send POST request with the required patient_id
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "patient_id":
            patientId, // Ensure this is fetched correctly from api.dart
      }),
    );

    debugPrint("Response received with status code: ${response.statusCode}");

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint("Response body: $data");

      // Check the status in the API response
      if (data['status'] == 'true') {
        final deficiencies = data["deficiencies"] ?? {};

        // Explicitly parse food_suggestions to match the expected Map<String, List<Map<String, dynamic>>>
        final foodSuggestionsRaw = data["food_suggestions"] ?? {};
        Map<String, List<Map<String, dynamic>>> foodSuggestions = {};

        // Convert each food suggestion entry to the appropriate format
        foodSuggestionsRaw.forEach((key, value) {
          if (value is List) {
            foodSuggestions[key] = List<Map<String, dynamic>>.from(
                value.map((item) => Map<String, dynamic>.from(item)));
          }
        });

        debugPrint("Deficiencies: $deficiencies");
        debugPrint("Food Suggestions: $foodSuggestions");

        return {
          "success": true,
          "deficiencies": deficiencies,
          "food_suggestions": foodSuggestions,
        };
      } else {
        String errorMessage = data["message"] ?? "Failed to fetch data.";
        debugPrint("API Error: $errorMessage");
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      String errorMessage = "Server returned: ${response.statusCode}";
      debugPrint("HTTP Error: $errorMessage");
      _showErrorDialog(context, errorMessage);
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
    // Handle errors
    debugPrint("Exception occurred: $e");
    _showErrorDialog(context, "An error occurred: $e");
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
  }
}

// Function to show an error dialog
void _showErrorDialog(BuildContext context, String message) {
  debugPrint("Showing error dialog with message: $message");
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
