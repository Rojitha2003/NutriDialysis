import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api.dart'; // Ensure Investigationsurl is correctly imported

class InvestigationPage extends StatefulWidget {
  final String patientId;

  const InvestigationPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  _InvestigationPageState createState() => _InvestigationPageState();
}

class _InvestigationPageState extends State<InvestigationPage> {
  // Controllers for the input fields
  final TextEditingController _hemoglobinController = TextEditingController();
  final TextEditingController _pcvController = TextEditingController();
  final TextEditingController _totalWbcCountController =
      TextEditingController();
  final TextEditingController _creatinineController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _serumCholesterolController =
      TextEditingController();
  final TextEditingController _serumAlbuminController = TextEditingController();
  final TextEditingController _bicarbonateController = TextEditingController();
  final TextEditingController _ejectionFractionController =
      TextEditingController();

  Future<void> _saveInvestigationData() async {
    // Retrieve input data
    final hemoglobin = _hemoglobinController.text.trim();
    final pcv = _pcvController.text.trim();
    final totalWbcCount = _totalWbcCountController.text.trim();
    final creatinine = _creatinineController.text.trim();
    final potassium = _potassiumController.text.trim();
    final serumCholesterol = _serumCholesterolController.text.trim();
    final serumAlbumin = _serumAlbuminController.text.trim();
    final bicarbonate = _bicarbonateController.text.trim();
    final ejectionFraction = _ejectionFractionController.text.trim();

    // Call the API function
    final response = await addInvestigation(
      patientId: widget.patientId,
      hemoglobin: hemoglobin,
      pcv: pcv,
      totalWbcCount: totalWbcCount,
      creatinine: creatinine,
      potassium: potassium,
      serumCholesterol: serumCholesterol,
      serumAlbumin: serumAlbumin,
      bicarbonate: bicarbonate,
      ejectionFraction: ejectionFraction,
    );

    // Display the response message
    if (response['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set background color of the page to white
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.pink[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Investigations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  InvestigationField(
                    label: "Hemoglobin",
                    controller: _hemoglobinController,
                  ),
                  InvestigationField(
                    label: "PCV",
                    controller: _pcvController,
                  ),
                  InvestigationField(
                    label: "Total WBC count",
                    controller: _totalWbcCountController,
                  ),
                  InvestigationField(
                    label: "Creatinine",
                    controller: _creatinineController,
                  ),
                  InvestigationField(
                    label: "Potassium",
                    controller: _potassiumController,
                  ),
                  InvestigationField(
                    label: "Serum Cholesterol",
                    controller: _serumCholesterolController,
                  ),
                  InvestigationField(
                    label: "Serum albumin",
                    controller: _serumAlbuminController,
                  ),
                  InvestigationField(
                    label: "Bicarbonate",
                    controller: _bicarbonateController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ECHO",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  InvestigationField(
                    label: "Ejection Fraction",
                    suffixText: "%",
                    controller: _ejectionFractionController,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveInvestigationData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvestigationField extends StatelessWidget {
  final String label;
  final String? suffixText;
  final TextEditingController controller;

  const InvestigationField({
    Key? key,
    required this.label,
    this.suffixText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label :",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Set label text color to black
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixText: suffixText,
                filled: true,
                fillColor:
                    Colors.grey[100], // Set light background for the field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              style: const TextStyle(
                  color: Colors.black), // Set text color to black
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> addInvestigation({
  required String patientId,
  required String hemoglobin,
  required String pcv,
  required String totalWbcCount,
  required String creatinine,
  required String potassium,
  required String serumCholesterol,
  required String serumAlbumin,
  required String bicarbonate,
  required String ejectionFraction,
}) async {
  try {
    final Map<String, String> body = {
      'patient_id': patientId,
      'hemoglobin': hemoglobin,
      'pcv': pcv,
      'total_wbc_count': totalWbcCount,
      'creatinine': creatinine,
      'potassium': potassium,
      'serum_cholesterol': serumCholesterol,
      'serum_albumin': serumAlbumin,
      'bicarbonate': bicarbonate,
      'ejection_fraction': ejectionFraction,
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    final response = await http.post(
      Uri.parse(Investigationsurl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'true') {
        return {
          'status': true,
          'message': responseData['message'],
          'patient_id': responseData['patient_id'],
        };
      } else {
        return {'status': false, 'message': responseData['message']};
      }
    } else {
      return {
        'status': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {'status': false, 'message': 'An error occurred: $e'};
  }
}
