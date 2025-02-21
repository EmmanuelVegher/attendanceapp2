import 'dart:async';
import 'dart:developer';

import 'package:attendanceapp/Pages/login_page.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:flutter/material.dart';

import 'package:attendanceapp/Pages/Dashboard/user_dashboard.dart';

class AuthCheck extends StatelessWidget {
  final IsarService service;

  const AuthCheck({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _delayedAuthCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors during the check
          return const Center(child: Text("Error checking authentication."));
        } else {
          // Navigate based on user availability after delay
          bool userAvailable = snapshot.data ?? false;
          print("userAvailable === $userAvailable");
          return userAvailable ? UserDashBoard(service: service,) : LoginPage(service: service);
        }
      },
    );
  }

  Future<bool> _delayedAuthCheck() async {
    // Add a 5-second delay before checking authentication status
    await Future.delayed(const Duration(seconds: 3));
    return _authCheckUser();
  }

  Future<bool> _authCheckUser1() async {
    final availableUser = await service.getBioInfo();
    final availableUserForSuperUser = await service.getBioInfoForSuperUser();

    print("availableUser === $availableUser");
    print("availableUserForSuperUser === $availableUserForSuperUser");

    // Check if the app has been used within 30 days
    DateTime currentDate = DateTime.now();
    DateTime? lastUsedDate = (await service.getLastUsedDate())?.lastUsedDate;
    bool? getAppVersion = (await service.getAppVersionInfo2())?.latestVersion;
    DateTime? getAppVersionCheckDate = (await service.getAppVersionInfo2())?.checkDate;
    DateTime? getAppVersionDate = (await service.getAppVersionInfo2())?.appVersionDate;

    print("lastUsedDate === $lastUsedDate");

    try {
      // Check if an app version update is required
      if (getAppVersion == false && getAppVersionCheckDate != null && getAppVersionDate != null &&
          getAppVersionCheckDate.difference(getAppVersionDate).inDays > 15) {
        return true;
      }

      // Check if the app has been used within the last 30 days
      if (lastUsedDate != null && currentDate.difference(lastUsedDate).inDays > 30) {
        print("Last usage was over 30 days ago.");
        return false;
      } else if (lastUsedDate != null && currentDate.difference(lastUsedDate).inDays < 30) {
        print("Last usage was within 30 days.");
        return false;
      } else {
        return false;
      }
    } catch (e) {
      log("Auth Error: $e");
      return false;
    }
  }

  Future<bool> _authCheckUser() async {
    final availableUser = await service.getBioInfoForUser();

    try {
      // Check if an app version update is required
      if(availableUser.isNotEmpty){
        return true;
      }else{
        return false;
      }

    } catch (e) {
      log("Auth Error: $e");
      return false;
    }
  }
}
