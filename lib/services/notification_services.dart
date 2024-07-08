// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotifyHelper {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initializeNotification() async {
//     _configureLocalTimezone();
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('appicon');

//     /*final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );*/

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             //iOS: initializationSettingsIOS,
//             macOS: null);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   scheduledNotification(int hour, int minutes, Task task) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         task.id!.toInt(),
//         task.title,
//         task.note,
//         _convertTime(hour, minutes),
//         //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//           'your channel id',
//           'your channel name', /*'your channel description'*/
//         )),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//         payload: "${task.title}|+${task.note}|");
//   }

//   tz.TZDateTime _convertTime(int hour, int minutes) {
//     final tz.TZDateTime now =
//         tz.TZDateTime.now(tz.local); //Return the Current(local) time
//     tz.TZDateTime scheduleDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
//     if (scheduleDate.isBefore(now)) {
//       scheduleDate = scheduleDate.add(const Duration(days: 1));
//     }

//     return scheduleDate;
//   }

//   Future<void> _configureLocalTimezone() async {
//     tz.initializeTimeZones();
//     final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZone));
//   }

//   displayNotification({required String title, required String body}) async {
//     print("doing test");
//     var androidPlatformChannelSpecifics =
//         new AndroidNotificationDetails('your channel id', 'your channel name',
//             /* 'your channel description',*/
//             importance: Importance.max,
//             priority: Priority.high);
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: title,
//     );
//   }

//   void requestIOSPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   Future selectNotification(String? payload) async {
//     if (payload != null) {
//       print('notification payload: $payload');
//     } else {
//       print("Notification Done");
//     }

//     if (payload == "Theme Changed") {
//       print("Nothing to Navigate to");
//     } else {
//       Get.to(
//         () => NotifiedPage(label: payload),
//       );
//     }
//   }

//   /*Future onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     /*showDialog(
//       //context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: Text('Ok'),
//             onPressed: () async {
//               Navigator.of(context, rootNavigator: true).pop();
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SecondScreen(payload),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );*/
//     Get.dialog(Text("Welcome to flutter"));

//   }*/
// }
