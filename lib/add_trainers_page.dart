import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTrainerPage extends StatefulWidget {
  @override
  _AddTrainerPageState createState() => _AddTrainerPageState();
}

class _AddTrainerPageState extends State<AddTrainerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController experienceController = TextEditingController(); // New experience field

  String? selectedSpeciality;
  String? editingTrainerId;

  final List<String> specialities = [
    'Weight Training',
    'Muscle Building Specialist',
    'Cardio Specialist',
    'Strength Conditioning',
    'Yoga Instructor',
    'Rehabilitation Trainer',
    'Sports Conditioning',
    'General Fitness Trainer',
  ];

  void _clearFields() {
    nameController.clear();
    ageController.clear();
    phoneNumberController.clear();
    experienceController.clear(); // Clear experience field
    setState(() {
      selectedSpeciality = null;
      editingTrainerId = null;
    });
  }

  Future<void> _addOrUpdateTrainer() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (editingTrainerId != null) {
          // Update existing trainer
          await _firestore.collection('trainers').doc(editingTrainerId).update({
            'name': nameController.text,
            'age': int.parse(ageController.text),
            'phone_number': phoneNumberController.text,
            'speciality': selectedSpeciality,
            'experience': experienceController.text, // Include experience
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trainer updated successfully!')),
          );
        } else {
          // Add new trainer
          await _firestore.collection('trainers').add({
            'name': nameController.text,
            'age': int.parse(ageController.text),
            'phone_number': phoneNumberController.text,
            'speciality': selectedSpeciality,
            'experience': experienceController.text, // Include experience
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trainer added successfully!')),
          );
        }
        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save trainer: $e')),
        );
      }
    }
  }

  Future<void> _deleteTrainer(String id) async {
    try {
      await _firestore.collection('trainers').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trainer deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trainer: $e')),
      );
    }
  }

  void _editTrainer(DocumentSnapshot trainer) {
    setState(() {
      editingTrainerId = trainer.id;
      nameController.text = trainer['name'];
      ageController.text = trainer['age'].toString();
      phoneNumberController.text = trainer['phone_number'];
      selectedSpeciality = trainer['speciality'];
      experienceController.text = trainer['experience']; // Set experience for editing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trainer'),
      ),
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the trainer\'s name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the trainer\'s age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the trainer\'s phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: experienceController, // Experience field
                    decoration: InputDecoration(
                      labelText: 'Experience',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the trainer\'s experience';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSpeciality,
                    items: specialities.map((speciality) {
                      return DropdownMenuItem<String>(
                        value: speciality,
                        child: Text(speciality),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSpeciality = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Speciality',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a speciality';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addOrUpdateTrainer,
                    child: Text(editingTrainerId != null ? 'Update Trainer' : 'Add Trainer'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _clearFields, // Clear fields button
                    child: Text('Clear Fields'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // The StreamBuilder remains outside of the SingleChildScrollView
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // Fixed height for the list
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('trainers').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final trainers = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: trainers.length,
                    itemBuilder: (context, index) {
                      final trainer = trainers[index];
                      return ListTile(
                        title: Text(trainer['name']),
                        subtitle: Text(
                            'Age: ${trainer['age']}, Speciality: ${trainer['speciality']}, Experience: ${trainer['experience']}'), // Display experience
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTrainer(trainer),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTrainer(trainer.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
