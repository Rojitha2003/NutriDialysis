import 'package:flutter/material.dart';
import 'dialysis_data.dart';
import 'provider_doctor/disaplay_scheduleapi.dart';
import 'provider_doctor/schedule_frequencyapi.dart';

class ScheduleFrequencyPage extends StatefulWidget {
  final String patientId;

  const ScheduleFrequencyPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  _ScheduleFrequencyPageState createState() => _ScheduleFrequencyPageState();
}

class _ScheduleFrequencyPageState extends State<ScheduleFrequencyPage> {
  final Map<String, bool> _days = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  bool _isEditing = false;
  // ignore: unused_field
  bool _isFirstTime = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> _fetchScheduleData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("Fetching schedule for patient ID: ${widget.patientId}");
      final response = await fetchPatientSchedule(widget.patientId);

      if (response['success'] == true) {
        final schedule = response['schedule'];

        if (schedule is Map<String, dynamic>) {
          debugPrint("Schedule data: $schedule");
          setState(() {
            _days.forEach((day, _) {
              _days[day] = schedule[day.toLowerCase()] == 'yes';
            });
            _isFirstTime = false;
          });
        } else {
          debugPrint("Invalid schedule format: $schedule");
          _showError("Invalid schedule data format.");
        }
      } else {
        debugPrint("Error message: ${response['message']}");
        _showError(
            response['message'] ?? "No schedule found. You can create one.");
        setState(() {
          _isFirstTime = true; // Allow adding schedule if none is found
          _isEditing = true; // Enable editing mode for new schedule
        });
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
      _showError("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleDay(String day) {
    setState(() {
      _days[day] = !_days[day]!;
    });
  }

  Future<void> _submitSchedule() async {
    final Map<String, String> schedule = _days.map((day, selected) {
      return MapEntry(day.toLowerCase(), selected ? 'yes' : 'no');
    });

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("Submitting schedule for patient ID: ${widget.patientId}");
      debugPrint("Schedule data: $schedule");

      final response = await updateScheduleFrequency(
        patientId: widget.patientId,
        schedule: schedule,
      );

      if (response['status'] == true) {
        debugPrint("Schedule updated successfully: ${response['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        setState(() {
          _isEditing = false;
        });

        // Navigate to Dialysis Data Page after saving schedule
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DialysisDataPage(patientId: widget.patientId),
          ),
        );
      } else {
        debugPrint("Error message: ${response['message']}");
        _showError(response['message']);
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
      _showError("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title in the AppBar
        title: const Text("Schedule Frequency"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white, // Set the background color to white
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isEditing ? "Done" : "Edit",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _days.keys.length,
                        itemBuilder: (context, index) {
                          String day = _days.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: _isEditing ? () => _toggleDay(day) : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _days[day]!
                                      ? Colors.orange
                                      : Colors.green[200],
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      day,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Icon(
                                      _days[day]!
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: _days[day]!
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _isEditing ? _submitSchedule : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12), // Smaller padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isEditing ? "Save Schedule" : "Edit Schedule",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16, // Smaller font size
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DialysisDataPage(
                                  patientId: widget.patientId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12), // Smaller padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Dialysis Data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16, // Smaller font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
