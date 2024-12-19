import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dialysis_nutrition/api.dart';

Future<Map<String, dynamic>> fetchPatientRecords({
  required String patientId,
}) async {
  final url = Uri.parse(PatientRecordsurl);
  if (patientId.isEmpty) {
    return {"success": false, "message": "Patient ID is required."};
  }

  try {
    final response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "patient_id": patientId,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "false") {
        return {"success": false, "message": data["message"] ?? "Error"};
      }
      return {"success": true, "data": data};
    }
    return {"success": false, "message": "Error: ${response.statusCode}"};
  } catch (e) {
    return {"success": false, "message": "Error: $e"};
  }
}

class PatientRecordsPage extends StatefulWidget {
  final String patientId;

  const PatientRecordsPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  bool isLoading = false;
  Map<String, dynamic>? patientRecords;

  @override
  void initState() {
    super.initState();
    _fetchPatientRecords();
  }

  void _fetchPatientRecords() async {
    setState(() => isLoading = true);
    final response = await fetchPatientRecords(patientId: widget.patientId);
    setState(() {
      isLoading = false;
      if (response['success']) {
        patientRecords = response['data'];
      } else {
        patientRecords = null;
      }
    });
  }

  Widget _buildSection(String title, dynamic data,
      {bool isBlue = false, bool isLowered = false}) {
    if (data == null || !(data is List<dynamic>) || data.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLowered) const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: data
              .map<Widget>((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _buildCell(item, isBlue: isBlue),
                  ))
              .toList(),
        ),
        if (isLowered) const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildCell(Map<String, dynamic> item, {bool isBlue = false}) {
    if (item.containsKey('timestamp')) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${item['timestamp']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (item.containsKey('co_morbidities')) ...[
              const SizedBox(height: 10),
              Text(
                "Co morbidities:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isBlue ? Colors.blue : Colors.black,
                ),
              ),
              ...item['co_morbidities']
                  .map<Widget>((e) => Text(
                        "- $e",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ))
                  .toList(),
            ],
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: item.entries
              .map((e) => e.value is List
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_formatKey(e.key)}:",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ...e.value
                            .map<Widget>((v) => Text(
                                  "- $v",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ))
                            .toList(),
                      ],
                    )
                  : Text(
                      "${_formatKey(e.key)}: ${e.value}",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ))
              .toList(),
        ),
      );
    }
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .toLowerCase()
        .replaceFirst(key[0], key[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                  'Patient Records',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : (patientRecords == null || patientRecords!.isEmpty)
                    ? const Center(child: Text("No data available"))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                              "Case sheet data", patientRecords!['case_sheet']),
                          _buildSection("Co-morbidities",
                              patientRecords!['co_morbidities'],
                              isBlue: true),
                          _buildSection("Vascular access",
                              patientRecords!['vascular_access'],
                              isBlue: true),
                          _buildSection(
                              "Dialysis data", patientRecords!['dialysis_data'],
                              isLowered: true),
                          _buildSection("Investigations",
                              patientRecords!['investigations'],
                              isLowered: true),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
