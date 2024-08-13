import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:attendanceapp/Pages/Dashboard/admin_dashboard.dart';
import 'package:attendanceapp/Pages/Dashboard/user_dashboard.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const ControlledHomePage(); // Use const for stateless widgets
  }
}

class ControlledHomePage extends StatefulWidget {
  const ControlledHomePage({Key? key}) : super(key: key);

  @override
  _ControlledHomePageState createState() => _ControlledHomePageState();
}

class _ControlledHomePageState extends State<ControlledHomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? rooll; // Make rooll nullable
  String? emaill;
  String? id;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Access Isar database using IsarService
      final service = IsarService();
      final userFromIsar = await service.getBioInfoWithFirebaseAuth();

      print("userFromIsar===${userFromIsar?.emailAddress}");

      if (userFromIsar?.firebaseAuthId != null) {
        setState(() {
          //loggedInUser = userFromIsar;
          emaill = userFromIsar?.emailAddress;
          rooll = userFromIsar?.role;
         // id = userFromIsar?.id;
        });
      } else {
        // Handle case where user is not found in Isar
        print('User not found in Isar database');
        // You might want to handle this case differently,
        // perhaps by showing an error or trying to fetch from Firestore.
      }
    } catch (e) {
      // Handle general errors
      print('Error fetching user data: $e');
    }
  }

  Widget _getDashboard() {
    if (rooll == 'User') {
      return UserDashBoard(service: IsarService());
    } else if (rooll == 'Admin') {
      return AdminDashBoard(service: IsarService());
    } else {
      // Handle the case where the role is not yet loaded
      // You can return a loading indicator or an error message.
      return LoginPage(service: IsarService(),);
      //Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getDashboard();
  }
}