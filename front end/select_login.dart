import 'package:flutter/material.dart';
import 'doctor_login.dart'; // Import the doctor login page
import 'patient_login.dart'; // Import the patient login page
import 'main.dart'; // Import the main.dart file

class DoctorPatientLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 932,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Color(0xFFFBF9F9)),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: -15,
            child: Container(
              width: 430,
              height: 115,
              decoration: BoxDecoration(color: Color(0xD634A0DC)),
              child: Stack(
                children: [
                  // Arrow mark for navigation
                  Positioned(
                    left: 15,
                    top: 67, // Adjusted position slightly downward
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the main.dart page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FigmaToCodeApp(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Doctor Circular Image with Outer and Inner Circle
          Positioned(
            left: 83,
            top: 128,
            child: Container(
              width: 191,
              height: 191,
              decoration: ShapeDecoration(
                color: Color(0x5BDD4BAB),
                shape: CircleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 2), // Black border for outer circle
                ),
              ),
              child: Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/doctor.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // DOCTOR button with navigation
          Positioned(
            left: 70,
            top: 341,
            child: GestureDetector(
              onTap: () {
                // Navigate to the DoctorLoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorLoginScreen()),
                );
              },
              child: Container(
                width: 219,
                height: 67,
                decoration: BoxDecoration(
                  color: Color(0xFF34A0DD),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  'DOCTOR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none, // Ensure no underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Patient Circular Image with Outer and Inner Circle
          Positioned(
            left: 83,
            top: 443,
            child: Container(
              width: 191,
              height: 191,
              decoration: ShapeDecoration(
                color: Color(0x5BDD4BAB),
                shape: CircleBorder(
                  side: BorderSide(
                      color: Colors.black,
                      width: 2), // Black border for outer circle
                ),
              ),
              child: Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/patient.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // PATIENT button with navigation
          Positioned(
            left: 70,
            top: 657,
            child: GestureDetector(
              onTap: () {
                // Navigate to the PatientLoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientLoginScreen()),
                );
              },
              child: Container(
                width: 219,
                height: 67,
                decoration: BoxDecoration(
                  color: Color(0xFF34A0DD),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  'PATIENT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    decoration: TextDecoration.none, // Ensure no underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // NutriDialysis Header with Icon
          Positioned(
            left: 47,
            top: 0,
            child: Container(
              width: 296,
              height: 147,
              child: Stack(
                children: [
                  Positioned(
                    left: 43,
                    top: 45,
                    child: Text(
                      'NutriDialysis',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'Galada',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none, // Ensure no underline
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: -17,
                    top: -15,
                    child: Container(
                      width: 130,
                      height: 147,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/sample.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
