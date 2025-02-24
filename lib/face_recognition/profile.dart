// import 'dart:io';
//
// import 'package:attendanceapp/Pages/Attendance/button.dart';
// import 'package:flutter/material.dart';
//
// import 'dart:math' as math;
// import 'face_recognition_home.dart';
//
// class Profile extends StatelessWidget {
//   const Profile(this.username, {Key? key, required this.imagePath})
//       : super(key: key);
//   final String username;
//   final String imagePath;
//   final String githubURL = "https://github.com/EmmanuelVegher/AttendanceApp";
//
//   //void _launchURL() async => await canLaunch(githubURL)?await launch(githubURL):throw "Could not launch ${githunURL}"
//
//   @override
//   Widget build(BuildContext context) {
//     final double mirror = math.pi;
//     return Scaffold(
//       backgroundColor: Color(0XFFC7FFBE),
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.black,
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: FileImage(File(imagePath)),
//                       ),
//                     ),
//                     margin: EdgeInsets.all(20),
//                     width: 50,
//                     height: 50,
//                     // child: Transform(
//                     //     alignment: Alignment.center,
//                     //     child: FittedBox(
//                     //       fit: BoxFit.cover,
//                     //       child: Image.file(File(imagePath)),
//                     //     ),
//                     //     transform: Matrix4.rotationY(mirror)),
//                   ),
//                   Text(
//                     'Hi ' + username + '!',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.all(20),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFFEFFC1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.warning_amber_outlined,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       '''If you think this project seems interesting and need some help implementing it, dont hesitate and lets get in touch!''',
//                       style: TextStyle(fontSize: 16),
//                       textAlign: TextAlign.left,
//                     ),
//                     Divider(
//                       height: 30,
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(),
//               MyButton(
//                 label: "LOG OUT",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyHomePage()),
//                   );
//                 },
//               ),
//               // AppButton(
//               //   text: "LOG OUT",
//               //   onPressed: () {
//               //     Navigator.push(
//               //       context,
//               //       MaterialPageRoute(builder: (context) => MyHomePage()),
//               //     );
//               //   },
//               //   icon: Icon(
//               //     Icons.logout,
//               //     color: Colors.white,
//               //   ),
//               //   color: Color(0xFFFF6161),
//               // ),
//               SizedBox(
//                 height: 20,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
