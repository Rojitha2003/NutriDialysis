import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart'; // Import your API constants file

class PatientTableScreen extends StatefulWidget {
  final String patientId;

  const PatientTableScreen({required this.patientId, Key? key})
      : super(key: key);

  @override
  _PatientTableScreenState createState() => _PatientTableScreenState();
}

class _PatientTableScreenState extends State<PatientTableScreen> {
  List<Map<String, dynamic>> nutritionData = [];
  Map<String, dynamic>? totals;
  Map<String, dynamic>? deficiencies;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final result = await fetchNutritionData(widget.patientId);

    setState(() {
      isLoading = false;
      if (result['success']) {
        nutritionData = result['data'];
        totals = result['totals'];
        deficiencies = result['deficiencies']; // Fetch deficiencies
      } else {
        nutritionData = []; // No data available
        totals = null; // Clear totals
        deficiencies = null; // Clear deficiencies
      }
    });
  }

  Future<Map<String, dynamic>> fetchNutritionData(String patientId) async {
    final url = Uri.parse(PatientTableurl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "patient_id": patientId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'true') {
          List<Map<String, dynamic>> processedItems = [];
          (data['data'] as Map<String, dynamic>).forEach((foodTime, items) {
            for (var item in items) {
              processedItems.add({
                'food_time': foodTime,
                'food': item['food'],
                'quantity': item['quantity'],
                'calorie': item['calorie'] ?? 0,
                'carbohydrate': item['carbohydrate'] ?? 0,
                'protein': item['protein'] ?? 0,
                'sodium': item['sodium'] ?? 0,
                'potassium': item['potassium'] ?? 0,
              });
            }
          });

          return {
            "success": true,
            "data": processedItems,
            "totals": data['totals'],
            "deficiencies": data['deficiencies'], // Return deficiencies
          };
        } else {
          return {
            "success": false,
            "message": data["message"] ?? "No nutrition data found."
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server returned: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "An error occurred: $e"};
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : nutritionData.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Patient Nutrition Table',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(Colors.blue[100]!),
                          columns: [
                            DataColumn(
                                label: Text('Food Time',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Food',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Carbohydrate',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Calorie',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Protein',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Sodium',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Potassium',
                                    style: TextStyle(color: Colors.black))),
                          ],
                          rows: [
                            ..._buildDataRows(),
                            if (totals != null) _buildTotalRow(),
                          ],
                        ),
                      ),
                      if (totals !=
                          null) // Add Divider below "Total" if totals are present
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 20,
                        ),
                      if (deficiencies != null) _buildDeficienciesSection(),
                    ],
                  ),
                ),
    );
  }

  List<DataRow> _buildDataRows() {
    String? previousFoodTime;
    return nutritionData.map((item) {
      bool isFirstItemInFoodTime = item['food_time'] != previousFoodTime;
      previousFoodTime = item['food_time'];

      return DataRow(cells: [
        DataCell(Text(
          isFirstItemInFoodTime ? item['food_time'] ?? '' : '',
          style: TextStyle(color: Colors.blue),
        )),
        DataCell(
            Text(item['food'] ?? '', style: TextStyle(color: Colors.black))),
        DataCell(Text(item['carbohydrate'].toString(),
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['calorie'].toString(),
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['protein'].toString(),
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['sodium'].toString(),
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['potassium'].toString(),
            style: TextStyle(color: Colors.black))),
      ]);
    }).toList();
  }

  DataRow _buildTotalRow() {
    return DataRow(cells: [
      DataCell(Text(
        'Total',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      )),
      DataCell(Text('')),
      DataCell(Text(totals!['carbohydrate'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['calorie'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['protein'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['sodium'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['potassium'].toString(),
          style: TextStyle(color: Colors.black))),
    ]);
  }

  Widget _buildDeficienciesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensures all items align left
        children: [
          Align(
            alignment: Alignment.centerLeft, // Aligns the green box to the left
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Deficiencies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (deficiencies!['carbohydrate'] != null)
            Align(
              alignment: Alignment.centerLeft, // Aligns the text to the left
              child: Text(
                'Carbohydrate: ${deficiencies!['carbohydrate']} g',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          if (deficiencies!['calorie'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Calorie: ${deficiencies!['calorie']} Kcal',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          if (deficiencies!['protein'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Protein: ${deficiencies!['protein']} g',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          if (deficiencies!['sodium'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sodium: ${deficiencies!['sodium']} mg',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          if (deficiencies!['potassium'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Potassium: ${deficiencies!['potassium']} mg',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
