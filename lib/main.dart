import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gms/view_fee_payers_page.dart';
import 'package:gms/view_members_page.dart';
import 'add_activity_page.dart';
import 'add_trainers_page.dart';
import 'view_registered_members_page.dart'; // Import the ViewRegisteredMembersPage
import 'firebase_options.dart';
import 'admin_login_page.dart'; // Import your login page here
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_page.dart';
import 'view_users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      initialRoute: '/',
      routes: {
        '/': (context) => AdminLoginPage(),
        '/adminHomePage': (context) => AdminHomePage(),
        '/viewUsersPage': (context) => ViewUsersPage(),
        '/addActivityPage': (context) => AddActivityPage(),
        '/addTrainersPage': (context) => AddTrainerPage(),
        '/viewMembersPage': (context) => ViewMembersPage(),
        '/viewFeePayersPage': (context) => ViewFeePayersPage(),
        '/viewRegisteredMembersPage': (context) => ViewRegisteredMembersPage(), // New route
      },
    );
  }
}
