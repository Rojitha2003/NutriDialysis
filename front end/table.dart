import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart'; // Ensure this file contains `patientId` and `Tableurl`

class NutritionTableScreen extends StatefulWidget {
  @override
  _NutritionTableScreenState createState() => _NutritionTableScreenState();
}

class _NutritionTableScreenState extends State<NutritionTableScreen> {
  List<Map<String, dynamic>> nutritionData = [];
  Map<String, dynamic>? totals; // To store the total row data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the screen is loaded
  }

  // Function to fetch data from the API
  Future<void> fetchData() async {
    final result = await fetchNutritionData(context);

    if (result['success']) {
      setState(() {
        nutritionData = result['data'];
        totals = result['totals']; // Get the totals row directly
        isLoading = false;
      });
    } else {
      print(result[
          'message']); // Log the error message instead of showing a dialog
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : nutritionData.isEmpty
              ? Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Pink box for 'Nutrition Table' text
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors
                                .pink[300], // Pink background for the title
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Nutrition Table',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text color
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue[100]!),
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
                      Container(
                        color: Colors.blue, // Border color for the bottom
                        height: 2, // Border thickness
                      ),
                    ],
                  ),
                ),
    );
  }

  // Builds the data rows while handling the duplicate 'food_time' values
  List<DataRow> _buildDataRows() {
    String? previousFoodTime;
    return nutritionData.map((item) {
      bool isFirstItemInFoodTime = item['food_time'] != previousFoodTime;
      previousFoodTime = item['food_time'];

      // Set the food_time color to blue for the specific categories
      Color foodTimeColor = _getFoodTimeColor(item['food_time']);

      return DataRow(cells: [
        DataCell(Text(
          isFirstItemInFoodTime ? item['food_time'] ?? '' : '',
          style: TextStyle(color: foodTimeColor),
        )),
        DataCell(Text(
          item['food'] ?? '',
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          item['carbohydrate'].toString(),
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          item['calorie']?.toString() ??
              '0', // Ensure correct calories value is fetched
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          item['protein'].toString(),
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          item['sodium'].toString(),
          style: TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          item['potassium'].toString(),
          style: TextStyle(color: Colors.black),
        )),
      ]);
    }).toList();
  }

  // Helper function to get blue color for specific food_time
  Color _getFoodTimeColor(String? foodTime) {
    if (foodTime == 'Early Morning' ||
        foodTime == 'Breakfast' ||
        foodTime == 'Lunch' ||
        foodTime == 'Snacks' ||
        foodTime == 'Dinner' ||
        foodTime == 'Fluids' ||
        foodTime == 'Total') {
      return Colors.blue; // Set color to blue
    }
    return Colors.black; // Default color
  }

  // Builds the total row with the totals
  DataRow _buildTotalRow() {
    return DataRow(cells: [
      DataCell(Text(
        'Total',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      )),
      DataCell(Text('')),
      DataCell(Text(totals!['carbohydrate'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(
          (totals!['calorie'] ?? 0)
              .toString(), // Ensure calories value is handled properly
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['protein'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['sodium'].toString(),
          style: TextStyle(color: Colors.black))),
      DataCell(Text(totals!['potassium'].toString(),
          style: TextStyle(color: Colors.black))),
    ]);
  }
}

// Function to fetch nutrition data from the API
Future<Map<String, dynamic>> fetchNutritionData(BuildContext context) async {
  final url = Uri.parse(Tableurl); // The URL for your PHP API endpoint

  try {
    // Prepare the body with the patient ID
    final body = json.encode({
      'patient_id': patientId, // Using patientId imported from `api.dart`
    });

    // Send POST request with JSON body
    final response = await http.post(
      url,
      headers: {
        "Content-Type":
            "application/json", // Set Content-Type to application/json
      },
      body: body,
    );

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'true') {
        // Successfully fetched nutrition data
        Map<String, dynamic> nutritionData = data['data'];
        Map<String, dynamic> totals = data['totals'];

        // Process nutrition data to match expected format
        List<Map<String, dynamic>> processedItems = [];
        nutritionData.forEach((foodTime, items) {
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

        // Return the formatted data
        return {
          "success": true,
          "data": processedItems,
          "totals": totals,
        };
      } else {
        // Handle case when no food data is found
        String errorMessage = data["message"] ?? "No nutrition data found.";
        print(errorMessage); // Log error instead of showing a dialog
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      // Handle non-200 status codes
      String errorMessage = "Server returned: ${response.statusCode}";
      print(errorMessage); // Log error instead of showing a dialog
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
    // Handle errors (e.g., network issues)
    print("An error occurred: $e"); // Log error instead of showing a dialog
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
  }
}
