import 'package:flutter/material.dart';
// ignore: unused_import
import '../api.dart';
import 'provider_patient/suggestionsapi.dart'; // Ensure this imports the fetchDeficienciesAndSuggestions function

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  Map<String, dynamic> deficiencies = {};
  Map<String, List<Map<String, dynamic>>> foodSuggestions = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final response = await fetchDeficienciesAndSuggestions(context);

    if (response["success"]) {
      setState(() {
        deficiencies = response["deficiencies"] ?? {};
        foodSuggestions = response["food_suggestions"] ?? {};
        isLoading = false;
      });
    } else {
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
      body: Container(
        color: Colors.white, // Set background color of the page to white
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pink decorated box with "Nutrition Deficiencies"
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Nutrition Deficiencies',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...deficiencies.entries.map((entry) {
                        String nutrient = entry.key;
                        String deficiencyValue =
                            "${entry.value} ${_getUnitForNutrient(nutrient)}";
                        List<Map<String, dynamic>> suggestions =
                            foodSuggestions[nutrient] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNutrientHeader(nutrient, deficiencyValue),
                            const SizedBox(height: 8),
                            _buildFoodSuggestionList(suggestions),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildNutrientHeader(String nutrient, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        "$nutrient :  $value",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFoodSuggestionList(List<Map<String, dynamic>> suggestions) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50], // Set the cell color to green[50]
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 4,
                  child: Text(
                    "Suggested Food",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Quantity",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Value",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          ...suggestions.map((food) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueAccent, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      food['food'] ?? "",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black), // Text color set to black
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      food['quantity'] ?? "",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black), // Text color set to black
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      food['nutrient_value'].toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black), // Text color set to black
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getUnitForNutrient(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'calorie':
        return 'Kcal/Kg';
      case 'protein':
        return 'g/Kg';
      case 'sodium':
      case 'potassium':
        return 'mg';
      case 'carbohydrate':
        return 'g';
      default:
        return '';
    }
  }
}
