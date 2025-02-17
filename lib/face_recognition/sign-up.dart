// import 'dart:async';
// import 'dart:io';
// import 'dart:math' as math;
// import 'package:attendanceapp/services/isar_service.dart';
// import 'package:attendanceapp/widgets/FacePainter.dart';
// import 'package:attendanceapp/widgets/auth-action-button.dart';
// import 'package:attendanceapp/widgets/camera_header.dart';
// import 'package:camera/camera.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:flutter/material.dart';
//
// import '../services/camera.service.dart';
// import '../services/facenet.service.dart';
// import '../services/ml_kit_service.dart';
//
// class SignUp extends StatefulWidget {
//   final CameraDescription cameraDescription;
//
//   const SignUp({Key? key, required this.cameraDescription}) : super(key: key);
//
//   @override
//   SignUpState createState() => SignUpState();
// }
//
// class SignUpState extends State<SignUp> {
//   late String imagePath;
//   // Face? faceDetected;
//   late Size imageSize;
//   var firebaseAuthId;
//   var firstName;
//   var lastName;
//   bool _detectingFaces = false;
//   bool pictureTaked = false;
//
//   late Future _initializeControllerFuture;
//   bool cameraInitializated = false;
//
//   // switchs when the user press the camera
//   bool _saving = false;
//   bool _bottomSheetVisible = false;
//   Face? _faceDetected;
//
//   Face? get faceDetected => _faceDetected;
//
//   set faceDetected(Face? faceDetected) {
//     _faceDetected = faceDetected;
//   }
//
//   // service injection
//   MLKitService _mlKitService = MLKitService();
//   CameraService _cameraService = CameraService();
//   FaceNetService _faceNetService = FaceNetService();
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserDetail();
//
//     // starts the camera & start framing faces
//     setState(() {
//       _start();
//     });
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraService.dispose();
//     super.dispose();
//   }
//
//   void _getUserDetail() async {
//     final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
//     setState(() {
//       firebaseAuthId = userDetail?.firebaseAuthId;
//       firstName = userDetail?.firstName;
//       lastName = userDetail?.lastName;
//     });
//   }
//
//   // starts the camera & start framing faces
//   _start() async {
//     _initializeControllerFuture =
//         _cameraService.startService(widget.cameraDescription);
//     await _initializeControllerFuture;
//
//     setState(() {
//       cameraInitializated = true;
//     });
//
//     _frameFaces();
//   }
//
//   // handles the button pressed event
//   Future<bool> onShot() async {
//     if (faceDetected == null) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('No face detected!'),
//           );
//         },
//       );
//
//       return false;
//     } else {
//       _saving = true;
//       await Future.delayed(Duration(milliseconds: 500));
//       await _cameraService.cameraController.stopImageStream();
//       await Future.delayed(Duration(milliseconds: 200));
//       XFile file = await _cameraService.takePicture();
//       imagePath = file.path;
//
//       // Save Image in FireStore
//
//       Reference ref = FirebaseStorage.instance.ref().child(
//           "${firstName.toLowerCase()}_${lastName.toLowerCase()}_profilepic.jpg");
//
//       await ref.putFile(File(file.path));
//
//       ref.getDownloadURL().then((value) async {
//         // setState(() {
//         //   //Save Profile pic URL in User class
//         //   User.profilePicLink = value;
//         // });
//         //Save Profile Pic link to firebase
//         await FirebaseFirestore.instance
//             .collection("Staff")
//             .doc(firebaseAuthId)
//             .update({
//           "profilePic": value,
//         });
//       });
//
//       setState(() {
//         _bottomSheetVisible = true;
//         pictureTaked = true;
//       });
//
//       return true;
//     }
//   }
//
//   // draws rectangles when detects faces
//   _frameFaces() {
//     imageSize = _cameraService.getImageSize();
//
//     _cameraService.cameraController.startImageStream((image) async {
//       if (_cameraService.cameraController != null) {
//         // if its currently busy, avoids overprocessing
//         if (_detectingFaces) return;
//
//         _detectingFaces = true;
//         try {
//           List<Face> faces = await _mlKitService.getFacesFromImage(image);
//
//           if (faces.length > 0) {
//             setState(() {
//               faceDetected = faces[0];
//             });
//
//             if (_saving) {
//               _faceNetService.setCurrentPrediction(image, faceDetected!);
//               setState(() {
//                 _saving = false;
//               });
//             }
//           } else {
//             setState(() {
//               faceDetected = null as Face;
//             });
//           }
//
//           _detectingFaces = false;
//         } catch (e) {
//           print(e);
//           _detectingFaces = false;
//         }
//       }
//     });
//   }
//
//   _onBackPressed() {
//     Navigator.of(context).pop();
//   }
//
//   _reload() {
//     setState(() {
//       _bottomSheetVisible = false;
//       cameraInitializated = false;
//       pictureTaked = false;
//     });
//     this._start();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double mirror = math.pi;
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: Stack(
//           children: [
//             FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (pictureTaked) {
//                     return Container(
//                       width: width,
//                       height: height,
//                       child: Transform(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.cover,
//                             child: Image.file(File(imagePath)),
//                           ),
//                           transform: Matrix4.rotationY(mirror)),
//                     );
//                   } else {
//                     return Transform.scale(
//                       scale: 1.0,
//                       child: AspectRatio(
//                         aspectRatio: MediaQuery.of(context).size.aspectRatio,
//                         child: OverflowBox(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.fitHeight,
//                             child: Container(
//                               width: width,
//                               height: width *
//                                   _cameraService
//                                       .cameraController.value.aspectRatio,
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: <Widget>[
//                                   CameraPreview(
//                                       _cameraService.cameraController),
//                                   CustomPaint(
//                                     painter: FacePainter(
//                                         face: faceDetected as Face,
//                                         imageSize: imageSize),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             CameraHeader(
//               "PROFILE IMAGE",
//               onBackPressed: _onBackPressed,
//             )
//           ],
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: !_bottomSheetVisible
//             ? AuthActionButton(
//                 _initializeControllerFuture,
//                 onPressed: onShot,
//                 isLogin: false,
//                 reload: _reload,
//               )
//             : Container());
//   }
// }
