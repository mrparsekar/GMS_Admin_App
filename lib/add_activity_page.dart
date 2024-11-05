import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddActivityPage extends StatefulWidget {
  @override
  _AddActivityPageState createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? editingActivityId; // Variable to hold the ID of the activity being edited

  String? selectedActivity;
  String? selectedInstructor;
  String? selectedTime;
  String? selectedLocation;

  final List<String> activities = ['<Select>', 'Zumba', 'Yoga', 'Pilates', 'Spinning', 'Kickboxing'];
  final List<String> instructors = ['<Select>', 'John Doe', 'Jane Smith', 'Emily Johnson', 'Michael Brown', 'Sarah Davis'];
  final List<String> locations = ['<Select>', 'Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];

  // Predefined timings
  final List<String> timings = [
    '<Select>',
    '6:00 AM to 7:00 AM',
    '7:00 AM to 8:00 AM',
    '8:00 AM to 9:00 AM',
    '9:00 AM to 10:00 AM',
    '10:00 AM to 11:00 AM',
    '5:00 PM to 6:00 PM',
    '6:00 PM to 7:00 PM',
    '7:00 PM to 8:00 PM',
    '8:00 PM to 9:00 PM',
    '9:00 PM to 10:00 PM',
  ];

  // Method to add a new activity
  Future<void> _addActivity() async {
    final activityName = _activityNameController.text.trim();
    final instructor = selectedInstructor ?? '';
    final time = selectedTime ?? '';
    final location = selectedLocation ?? '';

    if (activityName.isNotEmpty && instructor.isNotEmpty && time.isNotEmpty && location.isNotEmpty) {
      if (editingActivityId == null) {
        // Add a new activity
        await firestore.collection('activities').add({
          'activityName': activityName,
          'instructor': instructor,
          'time': time,
          'location': location,
        });
      } else {
        // Edit the existing activity
        await firestore.collection('activities').doc(editingActivityId).update({
          'activityName': activityName,
          'instructor': instructor,
          'time': time,
          'location': location,
        });

        editingActivityId = null; // Reset the editing ID after editing
      }

      _clearFields();
    }
  }

  // Method to clear input fields
  void _clearFields() {
    _activityNameController.clear();
    selectedActivity = null;
    selectedInstructor = null;
    selectedTime = null;
    selectedLocation = null;
    editingActivityId = null; // Reset the editing ID
  }

  // Method to delete an activity
  Future<void> _deleteActivity(String id) async {
    await firestore.collection('activities').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Activities'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for Activity Name
            DropdownButtonFormField<String>(
              value: selectedActivity,
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                  _activityNameController.text = value ?? '';
                });
              },
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Activity Name'),
            ),

            // Dropdown for Instructor Name
            DropdownButtonFormField<String>(
              value: selectedInstructor,
              onChanged: (value) {
                setState(() {
                  selectedInstructor = value;
                  _instructorController.text = value ?? '';
                });
              },
              items: instructors.map((instructor) {
                return DropdownMenuItem<String>(
                  value: instructor,
                  child: Text(instructor),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Instructor Name'),
            ),

            // Dropdown for Time
            DropdownButtonFormField<String>(
              value: selectedTime,
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                  _timeController.text = value ?? '';
                });
              },
              items: timings.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Time'),
            ),

            // Dropdown for Location
            DropdownButtonFormField<String>(
              value: selectedLocation,
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  _locationController.text = value ?? '';
                });
              },
              items: locations.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Location'),
            ),

            SizedBox(height: 20),
            // Add and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addActivity,
                  child: Text(editingActivityId == null ? 'Add' : 'Update'), // Change button text based on mode
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(), // Default style
                ),
              ],
            ),
            SizedBox(height: 20),
            // List of activities
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('activities').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    final activities = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        final activityData = activity.data() as Map<String, dynamic>;
                        final activityName = activityData['activityName'] ?? 'No Name';
                        final instructor = activityData['instructor'] ?? 'No Instructor';
                        final time = activityData['time'] ?? 'No Time';
                        final location = activityData['location'] ?? 'No Location';

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(activityName),
                            subtitle: Text(
                                'Instructor: $instructor\nTime: $time\nLocation: $location'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Populate fields for editing
                                    _activityNameController.text = activityName;
                                    selectedInstructor = instructor;
                                    selectedTime = time;
                                    selectedLocation = location;
                                    editingActivityId = activity.id; // Set the ID of the activity to be edited
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteActivity(activity.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(child: Text('No activities found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
