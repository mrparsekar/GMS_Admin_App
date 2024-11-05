import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_activity_page.dart';
import 'view_registered_members_page.dart';

class AdminHomePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _viewUsers(BuildContext context) {
    Navigator.pushNamed(context, '/viewUsersPage');
  }

  void _addTrainers(BuildContext context) {
    Navigator.pushNamed(context, '/addTrainersPage');
  }

  void _viewMembers(BuildContext context) {
    Navigator.pushNamed(context, '/viewMembersPage');
  }

  void _viewFeePayers(BuildContext context) {
    Navigator.pushNamed(context, '/viewFeePayersPage');
  }

  void _viewRegisteredMembers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewRegisteredMembersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/admin_background.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black87, size: 30),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Welcome, Admin!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildAnimatedCard(context, 'Add Activity', Icons.calendar_today, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddActivityPage()),
                        );
                      }),
                      _buildAnimatedCard(context, 'View Users', Icons.fitness_center, () => _viewUsers(context)),
                      _buildAnimatedCard(context, 'Add Trainer', Icons.person_add, () => _addTrainers(context)),
                      _buildAnimatedCard(context, 'View Members', Icons.person, () => _viewMembers(context)),
                      _buildAnimatedCard(context, 'View Fee Payers', Icons.receipt, () => _viewFeePayers(context)),
                      _buildAnimatedCard(context, 'View Registered Members', Icons.list_alt, () => _viewRegisteredMembers(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, String title, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        color: Colors.blueGrey.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center( // Centering the content inside the card
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts content to center vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center, // Centers the text horizontally
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
