import 'dart:async';
import 'dart:developer';
import 'package:attendanceapp/Pages/splash_screen.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/attendance_service.dart';
import 'package:attendanceapp/services/flutter_background_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/notification_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Pages/auth_check.dart';
import 'services/background_service.dart';

// Define the global navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

int id = 0;
late SharedPreferences pref;
RxBool isDeviceConnected = false.obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  tz.initializeTimeZones();

  // Initialize notification service
  await NotifyHelper().initializeNotification();

  // Check for Network Connection
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    await Firebase.initializeApp();
  } else {
    print('No network connection available.');
  }

  pref = await SharedPreferences.getInstance();
  await AttendanceGSheetsApi.init();
  await Hive.initFlutter();
  await IsarService().openDB();
  configLoading();

  // Asynchronous tasks
  await _updateEmptyClockInLocation().then((_) async {
    await _updateEmptyClockOutLocation();
  });

  configScreenLoader(
    loader: const AlertDialog(
      title: Text('Global Loader..'),
    ),
    bgBlur: 20.0,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());

  // Initialize and start the background service
  await initializeService();
}

// Update empty Clock-In location
Future<void> _updateEmptyClockInLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockInLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockInLatitude!, attend.clockInLongitude!);

      IsarService().updateEmptyClockInLocation(
        attend.id,
        AttendanceModel(),
        "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}",
      );
    }
  } catch (e) {
    log(e.toString());
  }
}

// Update empty Clock-Out location
Future<void> _updateEmptyClockOutLocation() async {
  try {
    List<AttendanceModel> attendanceForEmptyLocation =
    await IsarService().getAttendanceForEmptyClockOutLocation();

    for (var attend in attendanceForEmptyLocation) {
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockOutLatitude!, attend.clockOutLongitude!);

      IsarService().updateEmptyClockOutLocation(
        attend.id,
        AttendanceModel(),
        "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}",
      );
    }
  } catch (e) {
    log(e.toString());
  }
}

// Configure EasyLoading
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

// MyApp widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Add this instance as an observer to WidgetsBinding (only once)
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      navigatorKey: navigatorKey, // Pass the navigatorKey here
      home: SplashScreen(
        service: IsarService(),
      ),
    );
  }
}
