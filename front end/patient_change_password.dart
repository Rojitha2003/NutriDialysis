import 'package:flutter/material.dart';
import 'provider_patient/patient_change_passwordapi.dart';

class PatientChangePasswordPage extends StatefulWidget {
  const PatientChangePasswordPage({Key? key}) : super(key: key);

  @override
  _PatientChangePasswordPageState createState() =>
      _PatientChangePasswordPageState();
}

class _PatientChangePasswordPageState extends State<PatientChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _resetPassword() async {
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showErrorDialog("New password and confirm password do not match.");
      return;
    }

    final response = await patientChangePassword(
      currentPassword,
      newPassword,
      confirmPassword,
      context,
    );

    if (response["success"] == true) {
      _showSuccessDialog(response["message"]);
    } else {
      _showErrorDialog(response["message"]);
    }

    // Clear all text fields after password reset attempt
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void _showErrorDialog(String message) {
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Text('Old Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: currentPasswordController,
                obscureText: false, // No longer obscure the old password
                style: const TextStyle(
                    color: Colors.black), // Text color for entered text
                decoration: InputDecoration(
                  hintText: 'Enter Old Password',
                  hintStyle:
                      const TextStyle(color: Colors.grey), // Placeholder color
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('New Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true, // Still obscure the new password
                style: const TextStyle(
                    color: Colors.black), // Text color for entered text
                decoration: InputDecoration(
                  hintText: 'Enter New Password',
                  hintStyle:
                      const TextStyle(color: Colors.grey), // Placeholder color
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Confirm New Password',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true, // Still obscure the confirm password
                style: const TextStyle(
                    color: Colors.black), // Text color for entered text
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle:
                      const TextStyle(color: Colors.grey), // Placeholder color
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                    onPressed: _resetPassword,
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
    home: PatientChangePasswordPage(),
    debugShowCheckedModeBanner: false,
  ));
}
