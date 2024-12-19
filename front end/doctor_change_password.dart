import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file, which includes doctorId

// Function to change the doctor's password
Future<Map<String, dynamic>> doctorChangePassword(String currentPassword,
    String newPassword, String confirmPassword, BuildContext context) async {
  final url =
      Uri.parse(DoctorChangePasswordurl); // Replace with your actual server URL

  try {
    // Send POST request with required fields as body, using doctorId directly from api.dart
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "doctor_id": doctorId, // Fetch doctorId directly from api.dart
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      },
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = json.decode(response.body);

      // Check if the password change was successful
      if (data['status'] == true) {
        // Password updated successfully
        return {
          "success": true,
          "message": data["message"],
        };
      } else {
        // Handle case when password change fails
        String errorMessage = data["message"] ?? "Password update failed.";
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

class DoctorChangePasswordPage extends StatelessWidget {
  const DoctorChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers to capture input text
    final TextEditingController _currentPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    // Function to handle password reset
    Future<void> _resetPassword() async {
      final currentPassword = _currentPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Call the API function
      final response = await doctorChangePassword(
          currentPassword, newPassword, confirmPassword, context);

      // Show a dialog based on the response
      if (response["success"]) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: Text(response["message"]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );

        // Clear the input fields upon successful password change
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
      // Error is handled inside the doctorChangePassword function
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        automaticallyImplyLeading: true, // Remove the back arrow
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Old Password Text Field
              const Text(
                'Old Password ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _currentPasswordController,
                style:
                    TextStyle(color: Colors.black), // Text color set to black
                decoration: InputDecoration(
                  hintText: 'Enter old password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // New Password Text Field
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                style:
                    TextStyle(color: Colors.black), // Text color set to black
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm New Password Text Field
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style:
                    TextStyle(color: Colors.black), // Text color set to black
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Reset Password Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed:
                        _resetPassword, // Handle password reset functionality
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DoctorChangePasswordPage(),
    debugShowCheckedModeBanner: false,
  ));
}
