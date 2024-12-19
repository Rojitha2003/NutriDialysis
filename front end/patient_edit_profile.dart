import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api.dart';
import 'patient_home_page.dart';
import 'provider_patient/patient_edit_profileapi.dart';

class PatientEditProfilePage extends StatefulWidget {
  final String patientId;

  const PatientEditProfilePage({Key? key, required this.patientId})
      : super(key: key);

  @override
  State<PatientEditProfilePage> createState() => _PatientEditProfilePageState();
}

class _PatientEditProfilePageState extends State<PatientEditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _dryWeightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dateOfInitiationController =
      TextEditingController();
  final TextEditingController _dialysisVintageController =
      TextEditingController();

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  bool isVeg = false;
  bool isNonVeg = false;
  bool isBoth = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      final url = Uri.parse(PatientProfileurl);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"patient_id": widget.patientId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response Data: $data'); // Debugging line
        if (data['status'] == 'true') {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _ageController.text = data['age'] ?? '';
            _genderController.text = data['gender'] ?? '';
            _heightController.text = data['height'] ?? '';
            _dryWeightController.text = data['dry_weight'] ?? '';
            _bmiController.text = data['bmi'] ?? '';
            _mobileController.text = data['mobile'] ?? '';
            _dateOfInitiationController.text = data['date_of_initiation'] ?? '';
            _dialysisVintageController.text = data['dialysis_vintage'] ?? '';

            // Set checkbox states based on fetched data
            // Set checkboxes based on the 'food_type' value
            String foodType = data['food_type']?.toString() ?? '';

            // Set checkboxes based on food type
            isVeg = foodType.toLowerCase() == 'vegetarian';
            isNonVeg = foodType.toLowerCase() == 'non-vegetarian';
            isBoth = foodType.toLowerCase() ==
                'both'; // If there's a 'Both' value, handle it similarly

            print(
                'isVeg: $isVeg, isNonVeg: $isNonVeg, isBoth: $isBoth'); // Debugging line
            isLoading = false;
            hasError = false;
          });
        } else {
          setState(() {
            isLoading = false;
            hasError = true;
            errorMessage = data['message'] ?? 'Failed to load patient details.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  Future<void> _updatePatientDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final result = await patientEditProfile(
        patientName: _nameController.text,
        age: _ageController.text,
        gender: _genderController.text,
        height: _heightController.text,
        dryWeight: _dryWeightController.text,
        bmi: _bmiController.text,
        dateOfInitiation: _dateOfInitiationController.text,
        dialysisVintage: _dialysisVintageController.text,
        vegetarian: isVeg ? 'yes' : '',
        nonVegetarian: isNonVeg ? 'yes' : '',
        bothFood: isBoth ? 'yes' : '',
        mobileNumber: _mobileController.text,
        context: context,
      );

      setState(() {
        isLoading = false;
      });

      if (result["success"]) {
        _showSuccessDialog("Profile updated successfully.");
      } else {
        _showErrorDialog(result["message"]);
      }
    }
  }

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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientHomePage(
                      patientId: widget.patientId,
                      patientName: _nameController.text, // Use the updated name
                    ),
                  ),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchPatientDetails,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormField('Name', _nameController),
                    _buildFormField('Age', _ageController),
                    _buildFormField('Gender', _genderController),
                    _buildPatientIdField(), // Updated Patient ID field with alignment and size
                    _buildFormField('Height', _heightController),
                    _buildFormField('Dry Weight', _dryWeightController),
                    _buildFormField('BMI', _bmiController),
                    _buildDateFormField(
                        'Date of Initiation', _dateOfInitiationController),
                    _buildFormField(
                        'Dialysis Vintage', _dialysisVintageController),
                    _buildFoodTypeField(),
                    _buildFormField('Mobile Number', _mobileController),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _updatePatientDetails,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration.collapsed(hintText: ''),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
          ),
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Select or Enter Date',
                  ),
                  readOnly: true, // Prevent manual typing
                  onTap: () => _selectDateOfInitiation(context),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.blue),
                onPressed: () => _selectDateOfInitiation(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildFoodTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type of food consumed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCheckbox('Vegetarian', isVeg, (value) {
              setState(() {
                isVeg = true;
                isNonVeg = false;
                isBoth = false;
              });
            }),
            _buildCheckbox('Non-Vegetarian', isNonVeg, (value) {
              setState(() {
                isVeg = false;
                isNonVeg = true;
                isBoth = false;
              });
            }),
            _buildCheckbox('Both', isBoth, (value) {
              setState(() {
                isVeg = false;
                isNonVeg = false;
                isBoth = true;
              });
            }),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildPatientIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient ID',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Text(
            widget.patientId,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
