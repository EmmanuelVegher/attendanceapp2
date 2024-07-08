import 'package:attendanceapp/Pages/register_page.dart';
import 'package:attendanceapp/Pages/routing.dart';
import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheck extends StatefulWidget {
  final IsarService service;
  const AuthCheck({super.key, required this.service});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    //_getCurrentUser();
    _authCheckUser();
  }

  // void _getCurrentUser() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     if (sharedPreferences.getString("emailAddress") != null) {
  //       setState(() {
  //         // Save details from shared preferences into the User Class so as to be used anywhere in the app
  //         UserModel.emailAddress = sharedPreferences.getString("emailAddress")!;
  //         UserModel.password = sharedPreferences.getString("password")!;
  //         UserModel.role = sharedPreferences.getString("role")!;
  //         UserModel.firstName = sharedPreferences.getString("firstName")!;
  //         UserModel.lastName = sharedPreferences.getString("lastName")!;
  //         UserModel.staffCategory =
  //             sharedPreferences.getString("staffCategory")!;
  //         UserModel.designation = sharedPreferences.getString("designation")!;
  //         UserModel.location = sharedPreferences.getString("location")!;
  //         UserModel.state = sharedPreferences.getString("state")!;
  //         UserModel.department = sharedPreferences.getString("department")!;
  //         UserModel.mobile = sharedPreferences.getString("mobile")!;
  //         UserModel.project = sharedPreferences.getString("project")!;
  //         userAvailable = true;
  //       });
  //     } else {
  //       setState(() {
  //         userAvailable = false;
  //       });
  //     }
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    return userAvailable
        ?
        // HomePage(
        //     service: IsarService(),
        //   )
        LoginPage(
            service: IsarService(),
          )
        : LoginPage(
            service: IsarService(),
          );
    // LoginPage(
    //     service: IsarService(),
    //   );
  }

  Future<void> _authCheckUser() async {
    try {
      final availableUser = await widget.service.getBioInfo();
      final availableUserForSuperUser =
          await widget.service.getBioInfoForSuperUser();

      if (availableUser.length == 1) {
        if (availableUserForSuperUser == 0) {
          setState(() {
            userAvailable = true;
          });
        } else {
          setState(() {
            userAvailable = false;
          });
        }
      }

      if (availableUser.length > 1) {
        setState(() {
          userAvailable = true;
        });
      }
    } catch (e) {}
  }
}
