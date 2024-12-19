import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart';
import 'provider_patient/submit_foodapi.dart';
import 'data_display.dart'; // Import your DataDisplay page

// Function to fetch food items
Future<Map<String, dynamic>> fetchFoodItems(BuildContext context) async {
  final url = Uri.parse(SearchItemurl);

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'true') {
        List<dynamic> foodItems = data['data'];
        List<Map<String, dynamic>> processedItems = [];

        for (var item in foodItems) {
          Map<String, dynamic> foodItem = {
            'food': item['food'],
          };

          int count = 1;
          while (item.containsKey("quantity_number$count")) {
            foodItem["quantity_number$count"] = item["quantity_number$count"];
            foodItem["quantity_unit$count"] = item["quantity_unit$count"];
            foodItem["calories$count"] = item["calories$count"];
            count++;
          }

          processedItems.add(foodItem);
        }

        return {
          "success": true,
          "data": processedItems,
        };
      } else {
        String errorMessage = data["message"] ?? "No food data found.";
        _showErrorDialog(context, errorMessage);
        return {
          "success": false,
          "message": errorMessage,
        };
      }
    } else {
      String errorMessage = "Server returned: ${response.statusCode}";
      _showErrorDialog(context, errorMessage);
      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
    _showErrorDialog(context, "An error occurred: $e");
    return {
      "success": false,
      "message": "An error occurred: $e",
    };
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

// Function to submit food data
Future<void> submitSelectedFood(BuildContext context, String foodTime,
    List<Map<String, dynamic>> selectedItems) async {
  final result = await submitFoodData(
    foodTime: foodTime,
    foodSets: selectedItems,
  );

  if (result['status']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
  } else {
    _showErrorDialog(context, result['message']);
  }
}

class SearchItemPage extends StatefulWidget {
  final String foodTime;

  const SearchItemPage({required this.foodTime, Key? key}) : super(key: key);

  @override
  _SearchItemPageState createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<bool> selectedCheckboxes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final result = await fetchFoodItems(context);
    if (result["success"] == true) {
      setState(() {
        foodItems = List<Map<String, dynamic>>.from(result["data"]);
        filteredItems = foodItems;
        selectedCheckboxes = List<bool>.filled(foodItems.length, false);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = foodItems
          .where((item) =>
              item['food'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectItems() async {
    // Filter selected items based on checkboxes
    final selectedItems = filteredItems
        .asMap()
        .entries
        .where((entry) => selectedCheckboxes[entry.key])
        .map((entry) {
      final item = entry.value;

      return {
        'food': item['food'],
        'quantity_number': item['currentQuantity'],
        'quantity_unit': item['currentUnit'],
        'isSelected': true,
      };
    }).toList();

    // Check if no items are selected
    if (selectedItems.isEmpty) {
      // Show an informational pop-up dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Note"),
          content:
              const Text("Please select at least one food item to proceed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Proceed with submission if items are selected
    await submitSelectedFood(context, widget.foodTime, selectedItems);

    // Navigate to DataDisplay page after submitting data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataDisplayPage(
          selectedItems: selectedItems,
          patientId: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.foodTime),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Food Item',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return FoodItemTile(
                        item: filteredItems[index],
                        isSelected: selectedCheckboxes[index],
                        onChanged: (value) {
                          setState(() {
                            selectedCheckboxes[index] = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _selectItems,
                    child: Text('Select'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class FoodItemTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  FoodItemTile({
    required this.item,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  _FoodItemTileState createState() => _FoodItemTileState();
}

class _FoodItemTileState extends State<FoodItemTile> {
  late TextEditingController _quantityController;
  late String fetchedCalories;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item['quantity_number1'].toString(),
    );
    fetchedCalories = widget.item['calories1'] ?? 'N/A';

    widget.item['currentQuantity'] = widget.item['quantity_number1'];
    widget.item['currentUnit'] = widget.item['quantity_unit1'];
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.item['food'];

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.lightBlue[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.isSelected,
                  onChanged: widget.onChanged,
                ),
                Text(
                  food,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700]),
                ),
              ],
            ),
            Row(
              children: [
                // Quantity TextField with smaller width
                Container(
                  width: 80, // Adjust width for a smaller box
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Qty', // Shortened label
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      widget.item['currentQuantity'] = value;
                    },
                  ),
                ),
                SizedBox(width: 8),
                // Unit DropdownButton with larger width
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: widget.item['currentUnit'],
                      isExpanded: true, // Makes the dropdown occupy full width
                      items: List.generate(10, (index) {
                        final currentIndex = index + 1;
                        if (widget.item
                            .containsKey("quantity_unit$currentIndex")) {
                          return DropdownMenuItem<String>(
                            value: widget.item["quantity_unit$currentIndex"],
                            child: Text(
                              widget.item["quantity_unit$currentIndex"],
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return null;
                      }).whereType<DropdownMenuItem<String>>().toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.item['currentUnit'] = value;
                            int currentIndex = int.parse(
                              widget.item.entries
                                  .firstWhere((e) => e.value == value)
                                  .key
                                  .replaceAll(RegExp(r'\D'), ''),
                            );
                            widget.item['currentQuantity'] =
                                widget.item['quantity_number$currentIndex'];
                            fetchedCalories =
                                widget.item['calories$currentIndex'] ?? 'N/A';
                            _quantityController.text =
                                widget.item['currentQuantity'].toString();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Spacer(),
                Text(
                  'calories: $fetchedCalories ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
