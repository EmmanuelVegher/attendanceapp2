import 'dart:developer';

import 'package:attendanceapp/Pages/splash_screen.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
// import 'package:attendanceapp/model/attendance_gsheet_model.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/isar_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;
// Use GetX's reactive state management instead of ValueNotifier
RxBool isDeviceConnected = false.obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pref = await SharedPreferences.getInstance();
  await AttendanceGSheetsApi.init();
  await Hive.initFlutter();
  await IsarService().openDB();
  await GetStorage.init();
  configLoading();

  // Use GetX's asynchronous task management
  await _updateEmptyClockInLocation().then((_) async {
    await _updateEmptyClockOutLocation();
  });

  configScreenLoader(
      loader: const AlertDialog(
        title: Text('Gobal Loader..'),
      ),
      bgBlur: 20.0);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
    title: 'Attendance App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      MonthYearPickerLocalizations.delegate,
    ],
    builder: EasyLoading.init(),
    home: SplashScreen(
      service: IsarService(),
    ),
  ));
}

// This method updates all empty Clock-In Location Using the Latitude and Longitude during clock-out
Future<void> _updateEmptyClockInLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockInLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockInLatitude!, attend.clockInLongitude!);

      IsarService().updateEmptyClockInLocation(attend.id, AttendanceModel(),
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}");
    }
  } catch (e) {
    log(e.toString());
  }
}

//This method updates all empty Clock-Out Location Using the Latitude and Longitude during clock-out
Future<void> _updateEmptyClockOutLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockOutLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockOutLatitude!, attend.clockOutLongitude!);

      IsarService().updateEmptyClockOutLocation(attend.id, AttendanceModel(),
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}");
    }
  } catch (e) {
    log(e.toString());
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}