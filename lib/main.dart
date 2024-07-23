import 'dart:developer';
import 'package:attendanceapp/Pages/splash_screen.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/attendance_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/location_tracking_service.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'Pages/auth_check.dart';
import 'Pages/Dashboard/admin_dashboard.dart';
import 'Pages/Dashboard/user_dashboard.dart';
import 'model/user_model.dart';

// ... (Your other imports and variables)
int id = 0;
late SharedPreferences pref;
RxBool isDeviceConnected = false.obs;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Function for Handling background notification taps (Now top-level)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  tz.initializeTimeZones(); // Initialize timezones early
  await Workmanager().initialize(
    AttendanceService.callbackDispatcher, // Your existing callbackDispatcher
    isInDebugMode: true,
  );

  // Initialize location tracking
  await LocationTrackingService.initializeLocationTracking();

  // Initialize background tasks (include location tracking)
  await AttendanceService.initializeBackgroundTasks();

  // Check for Network Connection
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    // Initialize Firebase only if there is a network connection
    await Firebase.initializeApp();
  } else {
    // Handle no network connection
    print('No network connection available.');
  }

  pref = await SharedPreferences.getInstance();
  await AttendanceGSheetsApi.init();
  await Hive.initFlutter();
  await IsarService().openDB();
  configLoading();

  // Schedule Clock Out Reminders (moved to a separate function)
  await _setupNotifications();

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

  runApp(GetMaterialApp(
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

// Define onDidReceiveLocalNotification function
Future<void> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Handle the notification tap
  // For example, navigate to the AttendancePage
  Get.to(AuthCheck(service: IsarService()));
  _scheduleClockOutReminders(); // Reschedule the notification
}

Future<void> _setupNotifications() async {
  // Request permission to show notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('notification_icon');

  // // Import IOSInitializationSettings from flutter_local_notifications
  // const IOSInitializationSettings initializationSettingsIOS =
  // IOSInitializationSettings(
  //   requestSoundPermission: false,
  //   requestBadgePermission: false,
  //   requestAlertPermission: false,
  //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  // );

  // Import DarwinInitializationSettings from flutter_local_notifications
  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          Get.to(AuthCheck(service: IsarService())); // Navigate to AuthCheck
          _scheduleClockOutReminders(); // Re-schedule the notification
          break;
        case NotificationResponseType.selectedNotificationAction:
        // Handle specific action ID
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Schedule Clock Out Reminders
  await _scheduleClockOutReminders();
}

Future<void> _scheduleClockOutReminders() async {
  tz.initializeTimeZones(); // Initialize timezones (might already be initialized in main() above)

  // Get the Nigeria timezone
  tz.Location nigeriaTimeZone = tz.getLocation('Africa/Lagos');

  // Set the initial time to 5 PM in Nigeria
  DateTime now = DateTime.now();
  DateTime fivePM = DateTime(now.year, now.month, now.day, 17, 0, 0);

  // Check if fivePM is in the past
  if (fivePM.isBefore(now)) {
    // If fivePM is in the past, schedule for tomorrow
    fivePM = DateTime(now.year, now.month, now.day + 1, 17, 0, 0);
  }

  // Convert to TZDateTime for the Nigeria timezone
  tz.TZDateTime scheduledDate = tz.TZDateTime.from(fivePM, nigeriaTimeZone);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // id
    'Clock Out Reminder', // title
    'Don\'t forget to clock out for the day!', // body
    scheduledDate,
    //const Duration(minutes: 30), // repeatInterval
    //notificationDetails:
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'Clock Out Reminder',
        importance: Importance.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentSound: true,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
  );
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