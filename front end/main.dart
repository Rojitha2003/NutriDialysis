import 'package:flutter/material.dart';
import 'select_login.dart'; // Import select_login.dart (make sure this file exists and contains DoctorPatientLogin)

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color(0xF9FFF9F9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Background colored oval shape with image overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 280,
                  decoration: BoxDecoration(
                    color: const Color(0xD634A0DD),
                    borderRadius: BorderRadius.circular(300),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 6,
                        offset: Offset(0, 6),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 280,
                  height: 260,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/first.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(300),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Title "NutriDialysis"
            const Text(
              'NutriDialysis',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0791BD),
                fontSize: 28,
                fontFamily: 'FascinateInline',
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Supporting your health with every bite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Fanwood Text',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Blue rounded rectangle around "GET STARTED" text with black border
            GestureDetector(
              onTap: () {
                // Navigate to the DoctorPatientLogin page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorPatientLogin()),
                );
              },
              child: Container(
                width: 230,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF34A0DD),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'GET STARTED',
                  style: TextStyle(
                    color: Color(0xFF0E0E0F),
                    fontSize: 23,
                    fontFamily: 'Doppio One',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
