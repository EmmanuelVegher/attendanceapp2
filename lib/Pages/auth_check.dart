import 'dart:developer';

import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/app_usage_model.dart';
import 'Attendance/attendance_home.dart';
import 'Dashboard/user_dashboard.dart';
import 'home.dart';

class AuthCheck extends StatelessWidget {
  final IsarService service;

  const AuthCheck({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authCheckUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors during the check
          return const Center(child: Text("Error checking authentication."));
        } else {
          // Navigate to LoginPage based on user availability
          bool userAvailable = snapshot.data ?? false;
          print("userAvailable===${userAvailable}");
          return userAvailable ? LoginPage(service: service) : HomePage();

        }
      },
    );
  }

  Future<bool> _authCheckUser() async {
    final availableUser = await service.getBioInfo();
    final availableUserForSuperUser = await service.getBioInfoForSuperUser();

    print("availableUser===${availableUser}");
    print("availableUserForSuperUser===${availableUserForSuperUser}");

    // Check if the app has been used within 30 days
    DateTime currentDate = DateTime.now();
    DateTime? lastUsedDate = (await service.getLastUsedDate())?.lastUsedDate;
    bool? getAppVersion = (await service.getAppVersionInfo2())?.latestVersion;
    DateTime? getAppVersionCheckDate = (await service.getAppVersionInfo2())?.checkDate;
    DateTime? getAppVersionDate = (await service.getAppVersionInfo2())?.appVersionDate;
  // final getAppVersion = await IsarService().getAppVersionInfo();

    print("lastUsedDate===${lastUsedDate}");

    // print("getAppVersionDate===${getAppVersionDate}");
    // print("getAppVersionCheckDate===${getAppVersionCheckDate}");
    // print("getAppVersionDate!.difference(getAppVersionCheckDate).inDays > 15===${getAppVersionCheckDate!.difference(getAppVersionDate!).inDays > 15}");

    // Example parsing using intl's DateFormat class:
    //String appVersionString = getAppVersion[0].appVersion; // Assuming this is a String
    //DateTime appVersionDate = DateFormat('dd-MMM-yyyy').parse(getAppVersion[0].appVersion!);

    //print("getAppVersion[0].latestVersion ====${getAppVersion[0].latestVersion }");
    try{

      if (getAppVersion == false && getAppVersionCheckDate != null && getAppVersionDate != null &&
          getAppVersionCheckDate.difference(getAppVersionDate).inDays > 15) {
        return true;
      }


      // if(lastUsedDate == null){
      //   print("lastUsedDate || lastUpdateDate == null");
      //   return true;
      // }
      //
      //
      // else
        if(lastUsedDate != null && currentDate.difference(lastUsedDate).inDays > 30){
        print("lastUsedDate != null && currentDate.difference(lastUsedDate).inDays > 30");
        return true;
      }
      else if(lastUsedDate != null && currentDate.difference(lastUsedDate).inDays < 30)  {
        print("lastUsedDate != null && currentDate.difference(lastUsedDate).inDays < 30");
        return false;
      }else{
        return false;
      }
    }catch(e){
      log("Auth Error: $e");
      return false;
    }



  }

}
