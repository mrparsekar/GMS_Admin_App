import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewMembersPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('memberships').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final memberships = snapshot.data!.docs;

            return ListView.builder(
              itemCount: memberships.length,
              itemBuilder: (context, index) {
                final membership = memberships[index];
                // Fetch membership details
                final userName = membership['user_name'] ?? 'No Name';  // User name
                final price = membership['price'] ?? 'N/A';               // Membership price
                final duration = membership['duration'] ?? 'N/A';         // Duration of the membership
                final purchaseDate = (membership['purchase_date'] as Timestamp).toDate();
                final expiryDate = (membership['expiry_date'] as Timestamp).toDate();
                final remainingDays = expiryDate.difference(DateTime.now()).inDays; // Remaining days

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
                        Text(userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Price: $price', style: TextStyle(fontSize: 16)),
                        Text('Duration: $duration', style: TextStyle(fontSize: 16)),
                        Text('Purchase Date: ${purchaseDate.toLocal()}', style: TextStyle(fontSize: 16)),
                        Text('Expiry Date: ${expiryDate.toLocal()}', style: TextStyle(fontSize: 16)),
                        Text('Remaining Days: $remainingDays', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text('No members found.'));
        },
      ),
    );
  }
}
