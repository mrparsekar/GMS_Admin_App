import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUsersPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          // Loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error handling
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if there are users
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userData = user.data() as Map<String, dynamic>;
                final username = userData['full_name'] ?? 'No Name';
                final email = userData['email'] ?? 'No Email';
                final phoneNumber = userData['phone_number'] ?? 'No Phone Number';
                final age = userData['age'] ?? 'No Age'; // Get age from user data

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: $email',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Phone: $phoneNumber',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Age: $age', // Display age
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, user.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // No users found
          return Center(child: Text('No users found.'));
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                // Call delete function
                _deleteUser(context, userId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context, String userId) {
    // Print user ID for debugging
    print('Attempting to delete user with ID: $userId');

    // Delete user from Firestore
    FirebaseFirestore.instance.collection('users').doc(userId).delete().then((_) {
      print('User with ID $userId deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User deleted successfully!')));
    }).catchError((error) {
      print('Failed to delete user with ID $userId: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $error')));
    });
  }
}
