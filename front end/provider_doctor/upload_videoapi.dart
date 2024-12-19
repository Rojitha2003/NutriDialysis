import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file

// Function to upload video details
Future<Map<String, dynamic>> uploadVideo({
  required String videoTitle,
  required String videoUrl,
  required BuildContext context,
}) async {
  final url = Uri.parse(UploadVideourl); // Your server's video upload URL

  try {
    // Validate inputs before making the API call
    if (videoTitle.isEmpty || videoUrl.isEmpty) {
      _showErrorDialog(context, "Video title and URL are required.");
      return {
        "success": false,
        "message": "Video title and URL are required.",
      };
    }

    // Send POST request
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "video_title": videoTitle,
        "video_url": videoUrl,
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the video was uploaded successfully
      if (data['status'] == true) {
        return {
          "success": true,
          "message": data["message"],
          "video_id": data["video_id"], // Return the video ID
        };
      } else {
        String errorMessage = data["message"] ?? "Failed to upload video.";
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
