import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file, including `patientId`

// Function to fetch food items for the patient
Future<Map<String, dynamic>> fetchNutritionData(BuildContext context) async {
  final url = Uri.parse(Tableurl); // The URL for your PHP API endpoint

  try {
    // Prepare the body with the patient ID
    final body = json.encode({
      'patient_id': patientId, // Using patientId imported from `api.dart`
    });

    // Send POST request with JSON body
    final response = await http.post(
      url,
      headers: {
        "Content-Type":
            "application/json", // Set Content-Type to application/json
      },
      body: body,
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'true') {
        // Successfully fetched nutrition data
        Map<String, dynamic> nutritionData = data['data'];
        Map<String, dynamic> totals = data['totals'];

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
        };
      } else {
        // Handle case when no food data is found
        return {
          "success": false,
          "message": data["message"] ?? "No nutrition data found.",
          "data": [], // Return empty data when no data is available
        };
      }
    } else {
      // Handle non-200 status codes
      return {
        "success": false,
        "message": "Server returned: ${response.statusCode}",
        "data": [], // Return empty data
      };
    }
  } catch (e) {
    // Handle errors (e.g., network issues)
    return {
      "success": false,
      "message": "An error occurred: $e",
      "data": [], // Return empty data on error
    };
  }
}
