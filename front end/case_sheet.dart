import 'package:flutter/material.dart';
import 'dart:async';
import 'provider_doctor/case_sheetapi.dart';

class CaseSheet extends StatefulWidget {
  final String patientId;

  CaseSheet({required this.patientId});

  @override
  _CaseSheetState createState() => _CaseSheetState();
}

class _CaseSheetState extends State<CaseSheet> {
  final Map<String, bool> comorbidities = {
    'T2DM (Type 2 Diabetes mellitus)': false,
    'HTN (Hypertension)': false,
    'CVA (Cerebro Vascular Disease)': false,
    'CVD (Cardio Vascular Disease)': false,
    'Others': false,
  };

  final Map<String, bool> cvcAccess = {
    'IVJ': false,
    'Left IJV': false,
    'Right IJV': false,
    'Femoral': false,
    'Left Femoral': false,
    'Right Femoral': false,
  };

  final Map<String, bool> avfAccess = {
    'Radiocephalic Fistula': false,
    'Left Radiocephalic Fistula': false,
    'Right Radiocephalic Fistula': false,
    'Brachiocephalic Fistula': false,
    'Left Brachiocephalic Fistula': false,
    'Right Brachiocephalic Fistula': false,
  };

  final Map<String, bool> avgAccess = {
    'AVG': false,
    'Left AVG': false,
    'Right AVG': false,
  };

  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _submitCaseSheet() async {
    try {
      final response = await addCaseSheet(
        patientId: widget.patientId,
        t2dm: comorbidities['T2DM (Type 2 Diabetes mellitus)']! ? 'yes' : 'no',
        htn: comorbidities['HTN (Hypertension)']! ? 'yes' : 'no',
        cva: comorbidities['CVA (Cerebro Vascular Disease)']! ? 'yes' : 'no',
        cvd: comorbidities['CVD (Cardio Vascular Disease)']! ? 'yes' : 'no',
        description:
            comorbidities['Others'] == true ? _descriptionController.text : '',
        ivj: cvcAccess['IVJ']! ? 'yes' : 'no',
        leftIvj: cvcAccess['Left IJV']! ? 'yes' : 'no',
        rightIvj: cvcAccess['Right IJV']! ? 'yes' : 'no',
        femoral: cvcAccess['Femoral']! ? 'yes' : 'no',
        leftFemoral: cvcAccess['Left Femoral']! ? 'yes' : 'no',
        rightFemoral: cvcAccess['Right Femoral']! ? 'yes' : 'no',
        radiocephalicFistula:
            avfAccess['Radiocephalic Fistula']! ? 'yes' : 'no',
        leftRadiocephalicFistula:
            avfAccess['Left Radiocephalic Fistula']! ? 'yes' : 'no',
        rightRadiocephalicFistula:
            avfAccess['Right Radiocephalic Fistula']! ? 'yes' : 'no',
        brachiocephalicFistula:
            avfAccess['Brachiocephalic Fistula']! ? 'yes' : 'no',
        leftBrachiocephalicFistula:
            avfAccess['Left Brachiocephalic Fistula']! ? 'yes' : 'no',
        rightBrachiocephalicFistula:
            avfAccess['Right Brachiocephalic Fistula']! ? 'yes' : 'no',
        avg: avgAccess['AVG']! ? 'yes' : 'no',
        leftAvg: avgAccess['Left AVG']! ? 'yes' : 'no',
        rightAvg: avgAccess['Right AVG']! ? 'yes' : 'no',
      );

      if (response['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Case sheet is stored successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                  'Case Sheet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Comorbidities', Colors.green),
            _buildCheckboxGroup(comorbidities),
            if (comorbidities['Others'] == true) _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildSectionHeader('Access', Colors.green),
            _buildSubSection('CVC (Central Venous Catheter)', Colors.blue),
            _buildIndentedCheckboxGroup(
                cvcAccess, 'IVJ', ['Left IJV', 'Right IJV']),
            _buildIndentedCheckboxGroup(
                cvcAccess, 'Femoral', ['Left Femoral', 'Right Femoral']),
            _buildSubSection('AVF (Arteriovenous Fistula)', Colors.blue),
            _buildIndentedCheckboxGroup(avfAccess, 'Radiocephalic Fistula',
                ['Left Radiocephalic Fistula', 'Right Radiocephalic Fistula']),
            _buildIndentedCheckboxGroup(avfAccess, 'Brachiocephalic Fistula', [
              'Left Brachiocephalic Fistula',
              'Right Brachiocephalic Fistula'
            ]),
            _buildSubSection('AVG (Arterio Venous Graft)', Colors.blue),
            _buildIndentedCheckboxGroup(
                avgAccess, 'AVG', ['Left AVG', 'Right AVG']),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: _submitCaseSheet,
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        title,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildSubSection(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup(Map<String, bool> items) {
    return Column(
      children: items.keys.map((key) {
        return Row(
          children: [
            Checkbox(
              value: items[key],
              onChanged: (bool? value) {
                setState(() {
                  items[key] = value!;
                });
              },
            ),
            Expanded(
              child: Text(
                key,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildIndentedCheckboxGroup(
    Map<String, bool> items,
    String parentKey,
    List<String> childKeys,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: items[parentKey],
              onChanged: (bool? value) {
                setState(() {
                  items[parentKey] = value!;
                  if (!value) {
                    for (var child in childKeys) {
                      items[child] = false;
                    }
                  }
                });
              },
            ),
            Text(
              parentKey,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
        if (items[parentKey] == true)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: childKeys.map((childKey) {
                return Row(
                  children: [
                    Checkbox(
                      value: items[childKey],
                      onChanged: (bool? value) {
                        setState(() {
                          items[childKey] = value!;
                        });
                      },
                    ),
                    Text(
                      childKey,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      style: const TextStyle(
          color: Colors.black), // Ensuring description text is black
    );
  }
}
