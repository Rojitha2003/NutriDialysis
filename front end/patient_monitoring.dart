import 'package:flutter/material.dart';
import 'case_sheet.dart';
import 'investigations.dart';
import 'patient_details.dart';
import 'patient_records.dart';
import 'patient_table.dart';
import 'schedule_frequency.dart'; // Import the ScheduleFrequencyPage

class PatientMonitoringPage extends StatelessWidget {
  final String patientId;

  const PatientMonitoringPage({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34A0DC),
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back arrow
        title: const Center(
          child: Text(
            'Patient Monitoring',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              // Patient ID Box below AppBar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(
                    bottom: 20), // Space between AppBar and box
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54, width: 2),
                ),
                child: Text(
                  'Patient ID: $patientId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Buttons for navigation
              Expanded(
                child: ListView(
                  children: [
                    _buildCard(
                      'Patient Details',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToDetails(context);
                      },
                    ),
                    _buildCard(
                      'Case Sheet',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToCaseSheet(context);
                      },
                    ),
                    _buildCard(
                      'Dialysis Data',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToScheduleFrequency(context);
                      },
                    ),
                    _buildCard(
                      'Investigations',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToInvestigations(context);
                      },
                    ),
                    _buildCard(
                      'Patient Records',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToRecords(context);
                      },
                    ),
                    _buildCard(
                      'Patient Nutrition Table',
                      Colors.blue[100]!,
                      onTap: () {
                        _navigateToTable(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a card widget
  Widget _buildCard(String title, Color backgroundColor,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80, // Reduced height to make buttons smaller
        margin: const EdgeInsets.only(bottom: 12), // Space between boxes
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54, width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Helper methods for navigation actions
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsPage(patientId: patientId),
      ),
    );
  }

  void _navigateToCaseSheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaseSheet(patientId: patientId),
      ),
    );
  }

  void _navigateToRecords(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientRecordsPage(patientId: patientId),
      ),
    );
  }

  void _navigateToInvestigations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestigationPage(patientId: patientId),
      ),
    );
  }

  void _navigateToScheduleFrequency(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleFrequencyPage(patientId: patientId),
      ),
    );
  }

  void _navigateToTable(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientTableScreen(patientId: patientId),
      ),
    );
  }
}
