import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file

// Function to fetch food items
Future<Map<String, dynamic>> fetchFoodItems(BuildContext context) async {
  final url = Uri.parse(SearchItemurl); // Replace with your actual server URL

  try {
    // Send POST request without body parameters, as per PHP code
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = json.decode(response.body);

      // Check if the response contains valid data
      if (data['status'] == 'true') {
        // Successfully fetched food data, process the 'data' part
        List<dynamic> foodItems = data['data'];

        // Processing food items to match the expected format
        List<Map<String, dynamic>> processedItems = [];

        for (var item in foodItems) {
          Map<String, dynamic> foodItem = {
            'food': item['food'],
          };

          // Loop through the quantity and calorie data
          int count = 1;
          while (item.containsKey("quantity_number$count")) {
            foodItem["quantity_number$count"] = item["quantity_number$count"];
            foodItem["quantity_unit$count"] = item["quantity_unit$count"];
            foodItem["calories$count"] = item["calories$count"];
            count++;
          }

          // Add the processed food item to the list
          processedItems.add(foodItem);
        }

        return {
          "success": true,
          "data": processedItems,
        };
      } else {
        // Handle case when no food data is found
        String errorMessage = data["message"] ?? "No food data found.";
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
