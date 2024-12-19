import 'package:flutter/material.dart';
import 'awareness_videos.dart';
import 'patient_login.dart';
import 'patient_profile.dart'; // Import PatientProfilePage
import 'patient_change_password.dart'; // Import PatientChangePasswordPage
import 'nutrition_calculator.dart';
import 'suggestions.dart';
import 'table.dart'; // Import NutritionCalculator page

class PatientHomePage extends StatelessWidget {
  final String patientId;
  final String patientName;

  const PatientHomePage({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34A0DC),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 36),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            padding: const EdgeInsets.all(12.0),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/image.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Text(
              patientName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 120,
                color: Colors.lightBlue,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 22.0, top: 35.0),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientProfilePage(
                        patientId: patientId,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.black),
                title: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientChangePasswordPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientLoginScreen()),
                  );
                  // Handle Log Out tap
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCard(
                'Nutrition Calculator',
                'assets/calculator.png',
                Colors.blue[100]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NutritionCalculator()),
                  );
                },
              ),
              _buildCard(
                'Watch Awareness\nVideos',
                'assets/video.png',
                Colors.pink[100]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AwarenessVideosPage()),
                  );
                },
              ),
              _buildCard(
                'Nutrition Table',
                'assets/diet.png',
                Colors.green[100]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NutritionTableScreen()),
                  );
                },
              ),
              _buildCard(
                'Nutritional Deficiency',
                'assets/deficiency.png',
                Colors.orange[100]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuggestionsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, Color backgroundColor,
      {VoidCallback? onTap}) {
    double imageSize = imagePath == 'assets/deficiency.png' ? 120 : 90;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
