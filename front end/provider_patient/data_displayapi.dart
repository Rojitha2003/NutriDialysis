import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file, including `patientId`

// Function to fetch food items for the patient
Future<Map<String, dynamic>> fetchFoodItems(BuildContext context) async {
  final url = Uri.parse(DataDisplayurl); // The URL for your PHP API endpoint

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
        // Successfully fetched food data
        Map<String, dynamic> nutritionData = data['data'];

        // Process nutrition data to match expected format
        List<Map<String, dynamic>> processedItems = [];
        nutritionData.forEach((foodTime, items) {
          for (var item in items) {
            processedItems.add({
              'food_time': foodTime,
              'food': item['food'],
              'quantity': item['quantity'],
              'calories': item['calorie'],
              'carbohydrate': item['carbohydrate'],
              'protein': item['protein'],
              'sodium': item['sodium'],
              'potassium': item['potassium'],
            });
          }
        });

        return {
          "success": true,
          "data": processedItems,
        };
      } else {
        // Handle case when no food data is found
        return {
          "success": false,
          "message": data["message"] ?? "No food data found.",
        };
      }
    } else {
      // Handle non-200 status codes
      return {
        "success": false,
        "message": "Server returned: ${response.statusCode}",
      };
    }
  } catch (e) {
    // Handle errors (e.g., network issues)
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
  }
}

// Function to delete a food item
Future<Map<String, dynamic>> deleteFoodItem(
    BuildContext context, String food, String quantity, String foodTime) async {
  final url = Uri.parse(DataDisplayurl); // The URL for your PHP API endpoint

  try {
    // Prepare the body with the required fields
    final body = json.encode({
      'patient_id': patientId, // Patient ID from `api.dart`
      'food': food, // Food name to delete
      'quantity': quantity, // Quantity of food
      'food_time': foodTime, // Time of the food
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
        // Successfully deleted the food item
        return {
          "success": true,
          "message": data["message"] ?? "Item deleted successfully.",
        };
      } else {
        // Deletion failed
        return {
          "success": false,
          "message": data["message"] ?? "Failed to delete the item.",
        };
      }
    } else {
      // Handle non-200 status codes
      return {
        "success": false,
        "message": "Server returned: ${response.statusCode}",
      };
    }
  } catch (e) {
    // Handle errors (e.g., network issues)
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
  }
}
