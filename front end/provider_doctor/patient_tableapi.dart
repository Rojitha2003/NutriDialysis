import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file

// Function to fetch food items and deficiencies for the patient
Future<Map<String, dynamic>> fetchNutritionData(
    String patientId, BuildContext context) async {
  final url =
      Uri.parse(PatientTableurl); // Use PatientTableurl as your endpoint

  try {
    // Send POST request with patient_id as form-urlencoded body
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
      final data = json.decode(response.body);

      if (data['status'] == 'true') {
        // Successfully fetched nutrition data
        Map<String, dynamic> nutritionData = data['data'];
        Map<String, dynamic> totals = data['totals'];
        Map<String, dynamic> deficiencies =
            data['deficiencies']; // Fetch deficiencies

        // Process nutrition data to match expected format
        List<Map<String, dynamic>> processedItems = [];
        nutritionData.forEach((foodTime, items) {
          for (var item in items) {
            processedItems.add({
              'food_time': foodTime,
              'food': item['food'],
              'quantity': item['quantity'],
              'calorie': item['calorie'] ?? 0,
              'carbohydrate': item['carbohydrate'] ?? 0,
              'protein': item['protein'] ?? 0,
              'sodium': item['sodium'] ?? 0,
              'potassium': item['potassium'] ?? 0,
            });
          }
        });

        // Return the formatted data
        return {
          "success": true,
          "data": processedItems,
          "totals": totals,
          "deficiencies": deficiencies, // Include deficiencies in the response
        };
      } else {
        // Handle case when no food data is found
        String errorMessage = data["message"] ?? "No nutrition data found.";
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
