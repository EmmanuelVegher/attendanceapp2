//import 'package:attendanceapp/to-do/notified_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Pages/auth_check.dart';
import '../main.dart';
import 'isar_service.dart';

//import '../model/task.dart';


class NotifyHelper {

  final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
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

  // Define onDidReceiveLocalNotification function
  // Future<void> onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // Handle the notification tap
  //   // For example, navigate to the AttendancePage
  //   Get.to(AuthCheck(service: IsarService()));
  //   _scheduleClockOutReminders(); // Reschedule the notification
  // }

  Future<void> initializeNotification() async {
    _configureLocalTimezone();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');

    // final IOSInitializationSettings initializationSettingsIOS =
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

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
       // iOS: initializationSettingsIOS,
        macOS: null);

    // await flutterLocalNotificationsPlugin.initialize(
    //     initializationSettings,
    //     selectedNotification:selectNotification);


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
    matchDateTimeComponents: DateTimeComponents.time,
    payload: "Clock-Out Reminder|+ Kindly remember to clock-out|"
    );
  }


  // scheduledNotification(int hour,int minutes,Task task) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       task.id!.toInt(),
  //       task.title,
  //       task.note,
  //       _convertTime(hour,minutes),
  //       //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails('your channel id',
  //               'your channel name', /*'your channel description'*/)),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //       payload: "${task.title}|+${task.note}|"
  //   );
  //
  // }

  tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local); //Return the Current(local) time
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);
    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }

  Future<void>_configureLocalTimezone()async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));

  }

  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'high_importance_channel', 'Clock Out Reminder',/* 'your channel description',*/
        importance: Importance.max, priority: Priority.high,
      playSound: true,);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails(
      sound: 'default.wav',
      presentSound: true,
    );
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    
    if(payload=="Theme Changed"){
      print("Nothing to Navigate to");
    } else{
      //Get.to(()=>NotifiedPage(label:payload),);
    }
    
  }

  /*Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    /*showDialog(
      //context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );*/
    Get.dialog(Text("Welcome to flutter"));

  }*/
}