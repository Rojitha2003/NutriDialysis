import 'package:flutter/material.dart';
import 'package:dialysis_nutrition/provider_patient/data_displayapi.dart'; // Ensure this is the correct path

class DataDisplayPage extends StatefulWidget {
  final String patientId;
  final List<Map<String, dynamic>> selectedItems;

  const DataDisplayPage({
    Key? key,
    required this.patientId,
    required this.selectedItems,
  }) : super(key: key);

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  late Future<Map<String, dynamic>> _foodDataFuture;

  @override
  void initState() {
    super.initState();
    _foodDataFuture = fetchFoodItems(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Remove back arrow
        backgroundColor: Colors.blue,
        elevation: 0, // Optional: Remove shadow
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: FutureBuilder<Map<String, dynamic>>(
        future: _foodDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No food data available.',
                style:
                    TextStyle(color: Colors.black), // Set text color to black
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!['success'] == false) {
            return const Center(
              child: Text(
                'No food data available.',
                style:
                    TextStyle(color: Colors.black), // Set text color to black
              ),
            );
          }

          final List<Map<String, dynamic>> foodItems =
              (snapshot.data!['data'] as List<dynamic>)
                  .cast<Map<String, dynamic>>();

          if (foodItems.isEmpty) {
            return const Center(
              child: Text('No food data available.'),
            );
          }

          Map<String, List<Map<String, dynamic>>> groupedItems = {};
          for (var item in foodItems) {
            String foodTime = item['food_time'];
            if (!groupedItems.containsKey(foodTime)) {
              groupedItems[foodTime] = [];
            }
            groupedItems[foodTime]!.add(item);
          }

          return Column(
            children: [
              // Pink Box Header
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Nutrition Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: groupedItems.entries.map((entry) {
                    String foodTime = entry.key;
                    List<Map<String, dynamic>> items = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.blue[300],
                              child: Text(
                                foodTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...items
                                .map((item) => _buildFoodItem(item))
                                .toList(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: '${item['food']}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          const TextSpan(text: ' - '),
                          TextSpan(
                            text: '${item['quantity']}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final result = await deleteFoodItem(
                      context,
                      item['food'],
                      item['quantity'],
                      item['food_time'],
                    );
                    if (result['success'] == true) {
                      setState(() {
                        _foodDataFuture = fetchFoodItems(context);
                      });
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNutritionRow('Carbohydrate', item['carbohydrate'], 'g'),
                  _buildNutritionRow('Calorie', item['calories'], 'kcal'),
                  _buildNutritionRow('Protein', item['protein'], 'g'),
                  _buildNutritionRow('Sodium', item['sodium'], 'mg'),
                  _buildNutritionRow('Potassium', item['potassium'], 'mg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, dynamic value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            '$value $unit',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
