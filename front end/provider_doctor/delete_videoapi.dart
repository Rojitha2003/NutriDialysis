import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file, including DeleteVideourl

// Function to delete a video
Future<Map<String, dynamic>> deleteVideo({
  required String videoId,
  required BuildContext context,
}) async {
  final url = Uri.parse(DeleteVideourl); // Use your actual delete-video URL

  try {
    // Validate input
    if (videoId.isEmpty) {
      _showErrorDialog(context, "Video ID is missing. Please try again.");
      return {
        "success": false,
        "message": "Video ID is missing. Please try again.",
      };
    }

    // Send POST request
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "video_id": videoId,
      },
    );

    // Handle server response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == true) {
        return {
          "success": true,
          "message": data["message"] ?? "Video deleted successfully.",
        };
      } else {
        String errorMessage = data["message"] ?? "Failed to delete the video.";
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
