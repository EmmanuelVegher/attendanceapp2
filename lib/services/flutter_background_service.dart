import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../model/attendancemodel.dart';
import 'isar_service.dart';
import 'location_tracking_service.dart';
import 'notification_services.dart';
import 'package:isar/isar.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('notification_icon'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Attendance App',
      initialNotificationContent: 'App Running...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final now = DateTime.now();

        List<AttendanceModel> clockInTime = await IsarService().getAttendanceForDate(
            DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
        print("clockInTime[0].clockIn === ${clockInTime}");


        if (now.hour ==8 && now.minute == 0) {
          flutterLocalNotificationsPlugin.show(
            888,
            'Attendance App',
            'Good Morning! It\'s 8:00 AM. Don\'t forget to clock in!',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'clock_in',
                ongoing: true,
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                sound: RawResourceAndroidNotificationSound('alarmclock'),
              ),
            ),
          );


        }

        if (now.hour ==8 && now.minute == 30) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }

        if (now.hour ==9 && now.minute == 0) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }

        if (now.hour ==9 && now.minute == 30) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }


        if (now.hour ==10 && now.minute == 0) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }

        if (now.hour ==10 && now.minute == 30) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
          else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }

        if (now.hour ==11 && now.minute == 0) {
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: You have not clocked in yet!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else{
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have Successfully Clocked In. Do not forget to Clock out by the close of work!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }
        }


        if (now.hour == 12 && now.minute == 35) {
          LocationTrackingService.trackLocation();
        }

        //
        // Timer.periodic(const Duration(minutes: 1), (clockInTimer) async {
        //   //final clockInTime = await isar.attendanceModels.filter().dateEqualTo(DateTime.now()).findFirst();
        //
        // });


        if (now.hour == 17 && now.minute == 0){
          print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 5PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 5PM . Do Not Forget to Clock-Out For the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        //Second
        if (now.hour == 17 && now.minute == 30){
        //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 5:30PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 5:30PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        //Third

        if (now.hour == 18 && now.minute == 0){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 6:00PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 6:00PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 18 && now.minute == 30){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 6:30PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 6:30PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 19 && now.minute == 0){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 7:00PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 7:00PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 19 && now.minute == 30){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 7:30PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 7:30PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 20 && now.minute == 0){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 8:00PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 8:00PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 20 && now.minute == 30){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 8:30PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 8:30PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        if (now.hour == 21 && now.minute == 0){
          //  print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");
          if (clockInTime.isEmpty) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'Reminder: It is 9:00PM and you did not clocked in for today!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );
          }else if(clockInTime.isNotEmpty && clockInTime[0].clockOut == "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'It is 9:000PM . You are yet to clock-out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }else if(clockInTime[0].clockOut != "--/--"){

            //print("clockInTime[0].clockOut=====${clockInTime[0].clockOut}");

            flutterLocalNotificationsPlugin.show(
              888,
              'Attendance App',
              'You have successfully clocked out for the day!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'my_foreground',
                  'MY FOREGROUND SERVICE',
                  icon: 'clock_in',
                  ongoing: true,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                ),
              ),
            );

          }

        }

        print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

        final deviceInfo = DeviceInfoPlugin();
        String? device;
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          device = iosInfo.model;
        }

        service.invoke(
          'update',
          {
            "current_date": DateTime.now().toIso8601String(),
            "device": device,
          },
        );
      }
    }
  });

  backgroundTaskIsolate(service);
}

Future<Position?> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

Future<void> _storeGeolocation(Position position) async {
  print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
}

void backgroundTaskIsolate(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifyHelper = NotifyHelper();
  notifyHelper.initializeNotification();

  notifyHelper.scheduleDailyNotifications(
      1, 'Good Morning!', 'Have a productive day!', 8, 0);
  notifyHelper.scheduleDailyNotifications(
      2, 'Good Evening!', 'Time to unwind!', 17, 0);

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    final now = DateTime.now();

    if (now.hour == 12 && now.minute == 35) {
      LocationTrackingService.trackLocation();
    }

    service.invoke('update', {'current time': DateTime.now().toString()});
  });
}
