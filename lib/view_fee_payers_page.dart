import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting the date

class ViewFeePayersPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Fee Payers')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('payments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No fee payers found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final String userName = data['userName'] ?? 'No Name';
              final double amountDue = data['amountDue'] ?? 0.0;
              final int daysSelected = data['daysSelected'] ?? 0;
              final timestamp = data['timestamp'] as Timestamp?;

              // Format the timestamp to display the date
              final String dateOfPurchase = timestamp != null
                  ? DateFormat.yMMMd().format(timestamp.toDate())
                  : 'No Date';

              return ListTile(
                title: Text(userName),
                subtitle: Text(
                  'Amount Due: ₹$amountDue\n'
                      'Days Selected: $daysSelected\n'
                      'Date of Purchase: $dateOfPurchase',
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
