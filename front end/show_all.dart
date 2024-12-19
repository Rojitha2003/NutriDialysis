import 'package:flutter/material.dart';
import 'patient_monitoring.dart';

class ShowAllPage extends StatefulWidget {
  final List<dynamic> patients; // List of all patients

  const ShowAllPage(this.patients, {super.key});

  @override
  _ShowAllPageState createState() => _ShowAllPageState();
}

class _ShowAllPageState extends State<ShowAllPage> {
  List<dynamic> filteredPatients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPatients = widget.patients;
    searchController.addListener(_filterPatients);
  }

  void _filterPatients() {
    setState(() {
      filteredPatients = widget.patients
          .where((patient) =>
              patient['patient_name']
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              patient['patient_id'].toString().contains(searchController.text))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterPatients);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: const Color(0xFF34A0DC),
        title: Center(
          // Center the "All Patients" title
          child: const Text('All Patients'),
        ),
        automaticallyImplyLeading: false, // Remove top-left arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search patients',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  return buildPatientBox(filteredPatients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPatientBox(dynamic patient) {
    return GestureDetector(
      onTap: () {
        // Navigate to PatientMonitoringPage with the selected patient ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientMonitoringPage(
              patientId: patient['patient_id'].toString(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset('assets/image.png', width: 70, height: 70),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Patient id : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${patient['patient_id']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Name : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${patient['patient_name']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "Gender : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${patient['gender']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
