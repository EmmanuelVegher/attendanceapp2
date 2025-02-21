import 'package:attendanceapp/Pages/Dashboard/admin_dashboard.dart';
import 'package:attendanceapp/Pages/Dashboard/user_dashboard.dart';
import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final IsarService service;

  const HomePage({super.key, required this.service});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    return const contro();
  }
}

class contro extends StatefulWidget {
  const contro({super.key});

  @override
  _controState createState() => _controState();
}

class _controState extends State<contro> {
  _controState();
  //User? user = FirebaseAuth.instance.currentUser;
  // UserModel loggedInUser = UserModel();
  // var rooll;
  // var emaill;
  //var id;
  //var password;

  var role1;
  var role2;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    //_getUserDetails();
    _getUserRoles();
  }

  void _getUserRoles() async {
    final userRoles = await IsarService().getBioInfo();
    setState(() {
      role1 = userRoles[0].role;
      role2 = userRoles[1].role;
    });
  }

  // void _getUserDetails() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     if (sharedPreferences.getString("emailAddress") != null) {
  //       setState(() {
  //         // Save staff Email to the User Class
  //         emaill = sharedPreferences.getString("emailAddress")!;
  //         password = sharedPreferences.getString("password")!;
  //         rooll = sharedPreferences.getString("role")!;
  //       });
  //     } else {
  //       CircularProgressIndicator();
  //     }
  //   } catch (e) {}
  // }

  routing() {
    if (role1 == 'User') {
      return UserDashBoard(service: IsarService());
    } else if (role2 == 'User') {
      return UserDashBoard(service: IsarService());
    } else if (role1 == 'Admin') {
      return AdminDashBoard(
        service: IsarService(),
      );
    } else if (role2 == 'Admin') {
      return AdminDashBoard(
        service: IsarService(),
      );
    } else if (role1 == 'Super-Admin') {
      return LoginPage(
        service: IsarService(),
      );
    } else {
      return ProgressDialog(
        message: "Please wait...",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const CircularProgressIndicator();
    return routing();
  }
}
