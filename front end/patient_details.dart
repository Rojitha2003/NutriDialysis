import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Import your API constants file

class PatientDetailsPage extends StatefulWidget {
  final String patientId;

  const PatientDetailsPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, String> patientData = {
    'Name': 'Loading...',
    'Age': 'Loading...',
    'Gender': 'Loading...',
    'Patient ID': 'Loading...',
    'Height': 'Loading...',
    'Dry Weight': 'Loading...',
    'BMI': 'Loading...',
    'Date of Initiation': 'Loading...',
    'Dialysis Vintage': 'Loading...',
    'Type of food consumed': 'Loading...',
    'Mobile number': 'Loading...',
  };

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails(widget.patientId);
  }

  Future<void> _fetchPatientDetails(String patientId) async {
    try {
      final url = Uri.parse(PatientProfileurl);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"patient_id": patientId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'true') {
          setState(() {
            patientData = {
              'Name': data['name'] ?? 'N/A',
              'Age': data['age'] ?? 'N/A',
              'Gender': data['gender'] ?? 'N/A',
              'Patient ID': data['patient_id'] ?? 'N/A',
              'Height': data['height'] ?? 'N/A',
              'Dry Weight': data['dry_weight'] ?? 'N/A',
              'BMI': data['bmi'] ?? 'N/A',
              'Date of Initiation': data['date_of_initiation'] ?? 'N/A',
              'Dialysis Vintage': data['dialysis_vintage'] ?? 'N/A',
              'Type of food consumed': data['food_type'] ?? 'N/A',
              'Mobile number': data['mobile'] ?? 'N/A',
            };
            isLoading = false;
            hasError = false;
          });
        } else {
          setState(() {
            isLoading = false;
            hasError = true;
            errorMessage = data['message'] ?? 'Failed to load patient details.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _fetchPatientDetails(widget.patientId),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.pink[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Remove Edit icon and text
                ],
              ),
              const SizedBox(height: 30),
              _buildProfileField(Icons.person, 'Name', patientData['Name']!),
              _buildProfileField(Icons.cake, 'Age', patientData['Age']!),
              _buildProfileField(Icons.male, 'Gender', patientData['Gender']!),
              _buildProfileField(
                  Icons.numbers, 'Patient ID', patientData['Patient ID']!),
              _buildProfileField(
                  Icons.height, 'Height', patientData['Height']!),
              _buildProfileField(Icons.monitor_weight, 'Dry Weight',
                  patientData['Dry Weight']!),
              _buildProfileField(Icons.calculate, 'BMI', patientData['BMI']!),
              _buildProfileField(Icons.date_range, 'Date of Initiation',
                  patientData['Date of Initiation']!),
              _buildProfileField(Icons.timeline, 'Dialysis Vintage',
                  patientData['Dialysis Vintage']!),
              _buildProfileField(Icons.food_bank, 'Type of food consumed',
                  patientData['Type of food consumed']!),
              _buildProfileField(
                  Icons.phone, 'Mobile number', patientData['Mobile number']!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 30),
              const SizedBox(width: 15),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
