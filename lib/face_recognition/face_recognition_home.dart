// import 'package:attendanceapp/db/database.dart';
// import 'package:attendanceapp/face_recognition/sign-in.dart';
// import 'package:attendanceapp/face_recognition/sign-up.dart';
// import 'package:attendanceapp/services/facenet.service.dart';
// import 'package:attendanceapp/services/isar_service.dart';
// import 'package:attendanceapp/services/ml_kit_service.dart';
// import 'package:attendanceapp/widgets/header_widget.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// // import '../AllWidgets/header_widget_adhoc.dart';
// // import '../db/database.dart';
// // import '../services/facenet.service.dart';
// // import '../services/ml_kit_service.dart';
//
// class MyHomePage extends StatefulWidget {
//   //MyHomePage({Key key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // Services injection
//   FaceNetService _faceNetService = FaceNetService();
//   MLKitService _mlKitService = MLKitService();
//   DataBaseService _dataBaseService = DataBaseService();
//
//   late CameraDescription cameraDescription;
//   bool loading = false;
//   var firstName;
//   var lastName;
//   // String gitHubURL = "https://github.com/EmmanuelVegher/AttendanceApp";
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserDetail();
//     _startUp();
//   }
//
//   void _getUserDetail() async {
//     final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
//     setState(() {
//       firstName = userDetail?.firstName;
//       lastName = userDetail?.lastName;
//     });
//   }
//
//   // 1 Obtain a list of the available cameras on the device.
//   // 2 loads the face net model
//   _startUp() async {
//     _setLoading(true);
//
//     List<CameraDescription> cameras = await availableCameras();
//
//     // takes the front camera
//     cameraDescription = cameras.firstWhere(
//       (CameraDescription camera) =>
//           camera.lensDirection == CameraLensDirection.front,
//     );
//
//     // start the services
//     await _faceNetService.loadModel();
//     await _dataBaseService.loadDB();
//     _mlKitService.initialize();
//
//     _setLoading(false);
//   }
//
//   // shows or hides the circular progress indicator
//   _setLoading(bool value) {
//     setState(() {
//       loading = value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
//       /*appBar: AppBar(
//         leading: Container(),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(right: 20, top: 20),
//             child: PopupMenuButton<String>(
//               child: Icon(
//                 Icons.more_vert,
//                 color: Colors.black,
//               ),
//               onSelected: (value) {
//                 switch (value) {
//                   case 'Clear DB':
//                     _dataBaseService.cleanDB();
//                     break;
//                 }
//               },
//               itemBuilder: (BuildContext context) {
//                 return {'Clear DB'}.map((String choice) {
//                   return PopupMenuItem<String>(
//                     value: choice,
//                     child: Text(choice),
//                   );
//                 }).toList();
//               },
//             ),
//           ),
//         ],
//       ),*/
//       body: !loading
//           ? SafeArea(
//               child: Stack(children: [
//                 //Design the interface
//                 Container(
//                   height: 100,
//                   child: HeaderWidget(100, false, Icons.house_rounded),
//                 ),
//                 SizedBox(
//                   height: 12.0,
//                 ),
//                 Container(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         //Input image here wrapped inside a container
//                         Container(
//                           //height:90,
//                           width: 90,
//                           child: Image(
//                             image: AssetImage('assets/image/ccfn_logo.png'),
//                           ),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width * 0.8,
//                           child: Column(
//                             children: [
//                               Text(
//                                 "FACE RECOGNITION AUTHENTICATION",
//                                 style: TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Get.isDarkMode
//                                         ? Colors.white
//                                         : Colors.black),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 "Validate your face before proceeding",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     color: Get.isDarkMode
//                                         ? Colors.white
//                                         : Colors.deepOrange),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) => SignIn(
//                                       cameraDescription: cameraDescription,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Get.isDarkMode
//                                       ? Colors.white
//                                       : Colors.red,
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.1),
//                                       blurRadius: 1,
//                                       offset: Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 14, horizontal: 16),
//                                 width: MediaQuery.of(context).size.width * 0.8,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'VERIFY',
//                                       style: TextStyle(
//                                           color: Get.isDarkMode
//                                               ? Colors.black
//                                               : Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Icon(Icons.face,
//                                         color: Get.isDarkMode
//                                             ? Colors.black
//                                             : Colors.white)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             // This is where we need to Add Signup button
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) => SignUp(
//                                       cameraDescription: cameraDescription,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Color(0xFF0F0BDB),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.1),
//                                       blurRadius: 1,
//                                       offset: Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 alignment: Alignment.center,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 14, horizontal: 16),
//                                 width: MediaQuery.of(context).size.width * 0.8,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'SIGN UP',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Icon(Icons.person_add, color: Colors.white)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
