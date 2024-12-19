import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/api.dart'; // Ensure AddPatienturl is correctly imported
import 'package:http/http.dart' as http;

// API function
Future<Map<String, dynamic>> addPatient({
  required String patientName,
  required String age,
  required String gender,
  required String height,
  required String weight,
  required String bodyMassIndex,
  required String dateOfInitiation,
  required String dialysisVintage,
  required String mobileNumber,
  required String password,
  required String vegetarian,
  required String nonVegetarian,
  required String bothFood,
}) async {
  try {
    final Map<String, String> body = {
      'patient_name': patientName,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'body_mass_index': bodyMassIndex,
      'date_of_initiation': dateOfInitiation,
      'dialysis_vintage': dialysisVintage,
      'mobile_number': mobileNumber,
      'password': password,
      'vegetarian': vegetarian,
      'non_vegetarian': nonVegetarian,
      'both_food': bothFood,
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(
      Uri.parse(AddPatienturl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        return {
          'status': true,
          'message': responseData['message'],
          'patient_id': responseData['patient_id'],
        };
      } else {
        return {'status': false, 'message': responseData['message']};
      }
    } else {
      return {
        'status': false,
        'message': 'Server error: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {'status': false, 'message': 'An error occurred: $e'};
  }
}

// Main Widget
class AddPatientPage extends StatefulWidget {
  const AddPatientPage({Key? key}) : super(key: key);

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateOfInitiationController =
      TextEditingController();
  final TextEditingController _dialysisVintageController =
      TextEditingController();

  // Checkbox state variables
  bool isVeg = false;
  bool isNonVeg = false;
  bool isBoth = false;

  // Show the date picker dialog
  Future<void> _selectDateOfInitiation(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfInitiationController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Add patient details to the backend using the updated API function
  void _addPatientDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        final result = await addPatient(
          patientName: _nameController.text.trim(),
          age: _ageController.text.trim(),
          gender: _genderController.text.trim(),
          height: _heightController.text.trim(),
          weight: _weightController.text.trim(),
          bodyMassIndex: _bmiController.text.trim(),
          dateOfInitiation: _dateOfInitiationController.text.trim(),
          dialysisVintage: _dialysisVintageController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          password: _passwordController.text.trim(),
          vegetarian: isVeg ? 'yes' : 'no',
          nonVegetarian: isNonVeg ? 'yes' : 'no',
          bothFood: isBoth ? 'yes' : 'no',
        );

        if (result['status'] == true) {
          _showSuccessDialog(result['message'], result['patient_id']);
          _clearForm();
        } else {
          _showErrorDialog(result['message']);
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  // Helper to show success dialog
  void _showSuccessDialog(String message, String patientId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text('$message\nPatient ID: $patientId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Clear form and reset state
  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _ageController.clear();
    _genderController.clear();
    _heightController.clear();
    _weightController.clear();
    _bmiController.clear();
    _dateOfInitiationController.clear();
    _dialysisVintageController.clear();
    _mobileController.clear();
    _passwordController.clear();
    setState(() {
      isVeg = false;
      isNonVeg = false;
      isBoth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Patient',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField('Name', _nameController),
                _buildFormField('Age', _ageController, isNumeric: true),
                _buildFormField('Gender', _genderController),
                _buildFormField('Height', _heightController),
                _buildFormField('Weight', _weightController),
                _buildFormField('BMI', _bmiController),
                _buildDateFormField(
                    'Date of Initiation', _dateOfInitiationController),
                _buildFormField('Dialysis Vintage', _dialysisVintageController),
                _buildFoodTypeField(),
                _buildFormField('Mobile Number', _mobileController,
                    isNumeric: true),
                _buildFormField('Password', _passwordController,
                    isPassword: true),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    onPressed: _addPatientDetails,
                    child: const Text('Add Patient'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller,
      {bool isNumeric = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDateFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Select Date',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDateOfInitiation(context),
            ),
          ),
          onTap: () => _selectDateOfInitiation(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildFoodTypeField() {
    return Row(
      children: [
        Checkbox(
          value: isVeg,
          onChanged: (bool? value) {
            setState(() {
              isVeg = value!;
              isNonVeg = false;
              isBoth = false;
            });
          },
        ),
        const Text(
          'Vegetarian',
          style: TextStyle(color: Colors.black),
        ),
        Checkbox(
          value: isNonVeg,
          onChanged: (bool? value) {
            setState(() {
              isNonVeg = value!;
              isVeg = false;
              isBoth = false;
            });
          },
        ),
        const Text(
          'Non-Vegetarian',
          style: TextStyle(color: Colors.black),
        ),
        Checkbox(
          value: isBoth,
          onChanged: (bool? value) {
            setState(() {
              isBoth = value!;
              isVeg = false;
              isNonVeg = false;
            });
          },
        ),
        const Text(
          'Both',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
