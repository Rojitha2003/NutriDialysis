import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api.dart'; // Ensure CheckScheduleurl and DialysisDataurl are correctly imported

class DialysisDataPage extends StatefulWidget {
  final String patientId;

  const DialysisDataPage({Key? key, required this.patientId}) : super(key: key);

  @override
  _DialysisDataPageState createState() => _DialysisDataPageState();
}

class _DialysisDataPageState extends State<DialysisDataPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController weightGainController = TextEditingController();
  final TextEditingController preBPController = TextEditingController();
  final TextEditingController postBPController = TextEditingController();
  final TextEditingController urineOutputController = TextEditingController();
  final TextEditingController tricepSkinfoldController =
      TextEditingController();
  final TextEditingController handGripController = TextEditingController();

  bool isScheduled = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    _checkSchedule();
  }

  Future<void> _checkSchedule() async {
    final result = await checkScheduleFrequency(patientId: widget.patientId);

    setState(() {
      isScheduled = result['status'] == true;
      message = result['message'] ?? "";
    });
  }

  Future<void> _saveDialysisData() async {
    final result = await saveDialysisData(
      patientId: widget.patientId,
      weight: weightController.text,
      weightGain: weightGainController.text,
      preBP: preBPController.text,
      postBP: postBPController.text,
      urineOutput: urineOutputController.text,
      tricepSkinfoldThickness: tricepSkinfoldController.text,
      handGrip: handGripController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? "An error occurred.")),
    );

    if (result['status'] == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: isScheduled
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.pink[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Dialysis Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildEditableFieldWithIcon(
                      "Enter Date",
                      Icons.calendar_today,
                      dateController,
                      onIconTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          dateController.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildEditableFieldWithIcon(
                        "Enter Weight", Icons.monitor_weight, weightController),
                    const SizedBox(height: 16),
                    _buildEditableFieldWithIcon("Enter Weight gain",
                        Icons.line_weight, weightGainController),
                    const SizedBox(height: 16),
                    _buildEditableFieldWithIcon(
                        "Enter Pre - BP", Icons.bloodtype, preBPController),
                    const SizedBox(height: 16),
                    _buildEditableFieldWithIcon(
                        "Enter Post - BP", Icons.bloodtype, postBPController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Urine Output",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: urineOutputController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Enter output (ml)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "ml",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabeledField(
                        "Tricep Skinfold Thickness", tricepSkinfoldController),
                    const SizedBox(height: 16),
                    _buildLabeledField("Hand grip", handGripController),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveDialysisData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 40),
                        ),
                        child: const Text(
                          "Save Dialysis Data",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEditableFieldWithIcon(
      String hintText, IconData icon, TextEditingController controller,
      {VoidCallback? onIconTap}) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onIconTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}

// Add the checkScheduleFrequency and saveDialysisData methods here.
Future<Map<String, dynamic>> checkScheduleFrequency(
    {required String patientId}) async {
  final url = Uri.parse(CheckScheduleurl);
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'patient_id': patientId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'status': data['status'] == 'true',
        'message': data['message'],
      };
    } else {
      return {'status': false, 'message': 'Server error.'};
    }
  } catch (e) {
    return {'status': false, 'message': 'Error: $e'};
  }
}

Future<Map<String, dynamic>> saveDialysisData({
  required String patientId,
  required String weight,
  required String weightGain,
  required String preBP,
  required String postBP,
  required String urineOutput,
  required String tricepSkinfoldThickness,
  required String handGrip,
}) async {
  try {
    final body = {
      'patient_id': patientId,
      'weight': weight,
      'weight_gain': weightGain,
      'pre_bp': preBP,
      'post_bp': postBP,
      'urine_output': urineOutput,
      'tricep_skinfold_thickness': tricepSkinfoldThickness,
      'hand_grip': handGrip,
    };

    final response = await http.post(
      Uri.parse(DialysisDataurl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'status': data['status'] == 'true', 'message': data['message']};
    } else {
      return {'status': false, 'message': 'Server error.'};
    }
  } catch (e) {
    return {'status': false, 'message': 'Error: $e'};
  }
}
