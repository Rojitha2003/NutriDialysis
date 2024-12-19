import 'package:flutter/material.dart';
import 'search_item.dart'; // Import SearchItemPage here
import 'fluids.dart'; // Import FluidsPage here

class NutritionCalculator extends StatelessWidget {
  const NutritionCalculator({Key? key}) : super(key: key);

  Widget buildSection(String title, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (title == 'Fluids') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FluidsPage(), // Navigate to FluidsPage for "Fluids"
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchItemPage(
                            foodTime:
                                title), // Navigate to SearchItemPage for others
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add_circle, color: Colors.white),
                label: const Text(
                  'Add item',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Enter food you consumed by clicking on add item",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),
              buildSection('Early Morning', context),
              buildSection('Breakfast', context),
              buildSection('Lunch', context),
              buildSection('Snacks', context),
              buildSection('Dinner', context),
              buildSection('Fluids', context),
            ],
          ),
        ),
      ),
    );
  }
}
