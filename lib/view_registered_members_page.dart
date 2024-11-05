import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRegisteredMembersPage extends StatefulWidget {
  @override
  _ViewRegisteredMembersPageState createState() => _ViewRegisteredMembersPageState();
}

class _ViewRegisteredMembersPageState extends State<ViewRegisteredMembersPage> {
  final CollectionReference _registrationsCollection =
  FirebaseFirestore.instance.collection('registrations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Members for Classes'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _registrationsCollection.orderBy('registeredAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No members have registered for any classes yet.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final List<DocumentSnapshot> registrations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registrationData = registrations[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    registrationData['className'] ?? 'Class Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text("User: ${registrationData['userName'] ?? 'Unknown'}"),
                      Text("Instructor: ${registrationData['instructor'] ?? 'Unknown'}"),
                      Text("Schedule: ${registrationData['schedule'] ?? 'Not Specified'}"),
                      Text(
                        "Registered on: ${registrationData['registeredAt'] != null ? (registrationData['registeredAt'] as Timestamp).toDate().toString() : 'Unknown'}",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
