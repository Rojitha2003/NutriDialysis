import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Ensure FetchVideourl is defined here

// Function to fetch video details
Future<Map<String, dynamic>> fetchVideos(BuildContext context) async {
  final url = Uri.parse(FetchVideourl); // Your API endpoint URL

  try {
    // Send a GET request to the API
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json", // Ensure JSON content type
      },
    );

    // Check for successful response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true) {
        // Success: return the video details
        return {
          "success": true,
          "message": data['message'],
          "videos": data['videos'], // Array of videos
        };
      } else {
        // Failure response with error message from API
        String errorMessage = data['message'] ?? "Failed to fetch videos.";
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
          "videos": [],
        };
      }
    } else {
      // Response with non-200 status code
      String errorMessage = "Server returned status: ${response.statusCode}";
      _showErrorDialog(context, errorMessage);
      return {
        "success": false,
        "message": errorMessage,
        "videos": [],
      };
    }
  } catch (error) {
    // Handle request errors
    _showErrorDialog(context, "An error occurred: $error");
    return {
      "success": false,
      "message": "An error occurred: $error",
      "videos": [],
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
