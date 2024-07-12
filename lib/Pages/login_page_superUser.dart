import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:attendanceapp/Pages/Dashboard/super_admin_dashboard.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/Pages/forgot_password.dart';
import 'package:attendanceapp/Pages/register_page.dart';
import 'package:attendanceapp/Pages/routing.dart';
import 'package:attendanceapp/Pages/verify_email.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:attendanceapp/widgets/progress_dialog.dart';
import 'package:attendanceapp/widgets/show_error_dialog.dart';
import 'package:attendanceapp/widgets/theme_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageSuperUser extends StatefulWidget {
  final IsarService service;
  const LoginPageSuperUser({super.key, required this.service});

  @override
  State<LoginPageSuperUser> createState() => _LoginPageSuperUserState();
}

class _LoginPageSuperUserState extends State<LoginPageSuperUser> {
  DatabaseAdapter adapter = HiveService();
  late TextEditingController _emailAddressControl;
  late TextEditingController _passwordControl;
  late SharedPreferences sharedPreferences;
  var isDeviceConnected = false;
  late StreamSubscription subscription;

  double screenHeight = 0;
  double screenWidth = 0;

  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();
  bool _isObscure3 = true;

  Future<void> _pickImageFromFirebase(String profilePicLink) async {
    var profilePic = profilePicLink;
    if (profilePic != null) {
      try {
        // Create a reference from an HTTPS URL
// Note that in the URL, characters are URL escaped!
        final image = FirebaseStorage.instance.refFromURL(profilePic);
        //var image = await Image.network(UserModel.profilePicLink);
        if (image == null) return;
        //print("DownloadImage =====$image");

        try {
          const oneMegabyte = 1024 * 1024;
          final Uint8List? data = await image.getData(oneMegabyte);
          //print("DownloadImageUint8List =====$data");
          adapter.storeImage(data!);
        } on FirebaseException catch (e) {
          // Handle any errors.
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error:${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      return;
    }
  }

  Future<void> _autoFirebaseDBUpdate(String fireBaseIdNew) async {
    final allAttendance = await widget.service.getAllAttendance();
    if (allAttendance.length == 0) {
      // if (isDeviceConnected) {
      CircularProgressIndicator();
      log("isDeviceConnectedIf===$isDeviceConnected");
      await IsarService().removeAllAttendance(AttendanceModel());
      final CollectionReference snap3 = await FirebaseFirestore.instance
          .collection('Staff')
          .doc(fireBaseIdNew)
          .collection("Record");
      print("snap3 ====$snap3");

      List data = [];
      List<AttendanceModel> allAttendance = [];

      await snap3.get().then((QuerySnapshot value) {
        for (var element in value.docs) {
          data.add(element.data());
        }
      });

      for (var document in data) {
        allAttendance.add(AttendanceModel.fromJson(document));
      }

      print("data ====$data");
      print("allAttendance ====$allAttendance");

      for (var attendanceHistory in allAttendance) {
        final attendnce = AttendanceModel()
          ..clockIn = attendanceHistory.clockIn
          ..date = attendanceHistory.date
          ..clockInLatitude = attendanceHistory.clockInLatitude
          ..clockInLocation = attendanceHistory.clockInLocation
          ..clockInLongitude = attendanceHistory.clockInLongitude
          ..clockOut = attendanceHistory.clockOut
          ..clockOutLatitude = attendanceHistory.clockOutLatitude
          ..clockOutLocation = attendanceHistory.clockOutLocation
          ..clockOutLongitude = attendanceHistory.clockOutLongitude
          ..isSynced = attendanceHistory.isSynced
          ..voided = attendanceHistory.voided
          ..isUpdated = attendanceHistory.isUpdated
          ..offDay = attendanceHistory.offDay
          ..durationWorked = attendanceHistory.durationWorked
          ..noOfHours = attendanceHistory.noOfHours
          ..month = attendanceHistory.month;

        widget.service.saveAttendance(attendnce);
      }
      print("FirebaseID ====$firebaseAuthId");
      CircularProgressIndicator(value: 0.0);
      Fluttertoast.showToast(
          msg: "Logging In..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      //Navigator.of(context).pop();
      // } else {
      //   log("isDeviceConnectedElse ==$isDeviceConnected");
      //   //getConnectivity();
      //   Fluttertoast.showToast(
      //       msg: "Logging in..",
      //       toastLength: Toast.LENGTH_LONG,
      //       backgroundColor: Colors.black54,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
    }
  }

  // Future<void> getAttendance() async {
  //   var sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     if (sharedPreferences.getString("employeeId") != null) {
  //       setState(() {
  //         // Save Staff ID to the user class from this main.dart
  //         UserModel.staffId = sharedPreferences.getString("employeeId")!;
  //         var userAvailable = true;
  //         if (userAvailable) {
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => HomePage()));
  //         }
  //       });
  //     }
  //   } catch (e) {}
  // }

  @override
  void initState() {
    _emailAddressControl = TextEditingController();
    _passwordControl = TextEditingController();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   isDeviceConnected = await InternetConnectionChecker().hasConnection;
    //
    //   log("Internet status ====== $isDeviceConnected");
    // });
    super.initState();
  }

  @override
  void dispose() {
    _emailAddressControl.dispose();
    _passwordControl.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //Here we create a common header widget
            ),
            SafeArea(
              child: Container(
                  // This would be the login form
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      const Text(
                        "SUPER-USER LOGIN",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: "NexaBold"),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Sign-In into your account",
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "NexaBold",
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email Address",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    controller: _emailAddressControl,
                                    decoration:
                                        ThemeHelper().textInputDecoration(
                                      "",
                                      "Enter your email",
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      if ((!(val!.isEmpty) &&
                                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                  .hasMatch(val)) ||
                                          (val != null && val.isEmpty)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Password**",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: TextFormField(
                                    controller: _passwordControl,
                                    obscureText: _isObscure3,
                                    decoration:
                                        ThemeHelper().textInputDecoration(
                                      "",
                                      "Enter your Password**",
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isObscure3 = !_isObscure3;
                                          });
                                        },
                                        icon: Icon(
                                          _isObscure3
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      //
                                    ),
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'Enter Password'
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Container(
                            //   margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            //   alignment: Alignment.topRight,
                            //   child: TextButton(
                            //       child: Text(
                            //         "Forgot your password?",
                            //         style: TextStyle(color: Colors.red),
                            //       ),
                            //       onPressed: () {
                            //         Navigator.of(context).pushAndRemoveUntil(
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     ForgotPasswordPage()),
                            //             (Route<dynamic> route) => false);
                            //       }),
                            // ),

                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final email =
                                      _emailAddressControl.text.trim();
                                  final password = _passwordControl.text.trim();

                                  //print(snap.docs[0]["id"]);
                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Staff Email is Empty !!!"),
                                    ));
                                  } else if (password.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Password is Empty !!!"),
                                    ));
                                  } else if (email == "superuser@ccfng.org" &&
                                      password == "Moderated@2023") {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                        return SuperAdminUserDashBoard();
                                      }),
                                    );
                                  }
                                  // else {
                                  //   try {
                                  //     showDialog(
                                  //         context: context,
                                  //         barrierDismissible: false,
                                  //         builder: (BuildContext context) {
                                  //           return ProgressDialog(
                                  //             message: "Please wait...",
                                  //           );
                                  //         });

                                  //     await FirebaseAuth.instance
                                  //         .signInWithEmailAndPassword(
                                  //             email: email, password: password);

                                  //     final user =
                                  //         FirebaseAuth.instance.currentUser;

                                  //     // final emailId = FirebaseAuth
                                  //     //     .instance.currentUser?.email;

                                  //     QuerySnapshot snap =
                                  //         await FirebaseFirestore.instance
                                  //             .collection("Staff")
                                  //             .where('emailAddress',
                                  //                 isEqualTo: email)
                                  //             .get();

                                  //     // print(emailId);
                                  //     //print(snap.docs[0]['emailAddress']);
                                  //     // print(snap.docs[0]['password']);
                                  //     //print(snap.docs[0]['role']);

                                  //     //if (user?.emailVerified ?? false) {
                                  //     //Once the User is Verified, go to the Staff Collection and Updated the new verified status
                                  //     await FirebaseFirestore.instance
                                  //         .collection("Staff")
                                  //         .doc(snap.docs[0].id)
                                  //         .update({
                                  //       'isVerified': user?.emailVerified
                                  //     });

                                  //     //Then Clear the Local Database
                                  //     var box = await Hive.openBox('imageBox');
                                  //     await box.clear().then((value) async {
                                  //       await widget.service
                                  //           .cleanDB()
                                  //           .then((value) async {
                                  //         await _insertSuperUser();
                                  //       }).then((value) async {
                                  //         await _autoFirebaseDBUpdate(
                                  //             snap.docs[0].id);
                                  //       });
                                  //     });

                                  //     final attendance =
                                  //         await widget.service.getBioInfo();

                                  //     final bioData = BioModel()
                                  //       ..emailAddress = email
                                  //       ..password = password
                                  //       ..role = snap.docs[0]['role']
                                  //       ..department =
                                  //           snap.docs[0]['department']
                                  //       ..designation =
                                  //           snap.docs[0]['designation']
                                  //       ..firstName = snap.docs[0]['firstName']
                                  //       ..lastName = snap.docs[0]['lastName']
                                  //       ..location = snap.docs[0]['location']
                                  //       ..mobile = snap.docs[0]['mobile']
                                  //       ..project = snap.docs[0]['project']
                                  //       ..staffCategory =
                                  //           snap.docs[0]['staffCategory']
                                  //       ..state = snap.docs[0]['state']
                                  //       ..firebaseAuthId = snap.docs[0]['id'];

                                  //     await widget.service
                                  //         .saveBioData(bioData)
                                  //         .then((value) =>
                                  //             _pickImageFromFirebase(
                                  //                 snap.docs[0]['photoUrl']));

                                  //     //Store all the Staffs Credentials into the shared preference for data persitence which would be used for all other offline features
                                  //     // sharedPreferences =
                                  //     //     await SharedPreferences
                                  //     //         .getInstance();
                                  //     // await sharedPreferences.setString(
                                  //     //     "emailAddress", email);
                                  //     // await sharedPreferences.setString(
                                  //     //     "password", password);
                                  //     // await sharedPreferences.setString(
                                  //     //     "role", snap.docs[0]['role']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "department",
                                  //     //     snap.docs[0]['department']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "department",
                                  //     //     snap.docs[0]['department']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "designation",
                                  //     //     snap.docs[0]['designation']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "firstName",
                                  //     //     snap.docs[0]['firstName']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "lastName",
                                  //     //     snap.docs[0]['lastName']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "location",
                                  //     //     snap.docs[0]['location']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "mobile", snap.docs[0]['mobile']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "project", snap.docs[0]['project']);
                                  //     // // await sharedPreferences.setString(
                                  //     // //     "photoUrl",
                                  //     // //     snap.docs[0]['photoUrl']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "staffCategory",
                                  //     //     snap.docs[0]['staffCategory']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "state", snap.docs[0]['state']);
                                  //     // await sharedPreferences.setString(
                                  //     //     "firebaseAuthId",
                                  //     //     snap.docs[0]['id']);

                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) => HomePage(
                                  //                   service: IsarService(),
                                  //                 )));

                                  //     /*  try {
                                  //         if (sharedPreferences
                                  //                 .getString("employeeId") !=
                                  //             null) {
                                  //           setState(() {
                                  //             // Save Staff ID to the user class from this main.dart
                                  //             UserModel.staffId =
                                  //                 sharedPreferences
                                  //                     .getString("employeeId")!;
                                  //             var userAvailable = true;
                                  //             if (userAvailable) {
                                  //               Navigator.push(
                                  //                   context,
                                  //                   MaterialPageRoute(
                                  //                       builder: (context) =>
                                  //                           HomePage()));
                                  //             }
                                  //           });
                                  //         }
                                  //       } catch (e) {}*/

                                  //     //After Successful login we will redirect to profile dashboard
                                  //     // Navigator.of(context).pushReplacement(
                                  //     //     MaterialPageRoute(
                                  //     //         builder: (context) {
                                  //     //   return HomePage();
                                  //     // }));
                                  //     // } else {
                                  //     //   Navigator.of(context).pushReplacement(
                                  //     //       MaterialPageRoute(
                                  //     //           builder: (context) {
                                  //     //     return VerifyEmail();
                                  //     //   }));
                                  //     // }
                                  //   } on UserNotFoundAuthException {
                                  //     await showErrorDialog(
                                  //         context, "User not Found");
                                  //   } on WrongPasswordAuthException {
                                  //     await showErrorDialog(
                                  //         context, "Wrong Password");
                                  //   } on GenericAuthException {
                                  //     await showErrorDialog(
                                  //         context, "Authentication Error");
                                  //   } catch (e) {
                                  //     // await showErrorDialog(
                                  //     //     context, e.toString());
                                  //     String error = "";
                                  //     if (e.toString() ==
                                  //         "RangeError (index): Invalid value: Valid value range is empty: 0") {
                                  //       setState(() {
                                  //         error =
                                  //             "Staff Email Address does not exist!!!";
                                  //       });
                                  //     } else {
                                  //       setState(() {
                                  //         error = "Error occurred!!!";
                                  //       });
                                  //     }
                                  //   }
                                  // }
                                },
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Sign In".toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                              //child: Text("Don't have an account? Contact Admin"), //Lets style the form.For that we will create a theme helper class
                              child: Text.rich(TextSpan(children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                    text: "Contact Admin",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    style: TextStyle(
                                        fontFamily: "NexaBold",
                                        color: Colors.red,
                                        fontSize: 15)),
                              ])),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _insertSuperUser() async {
  //   final bioInfoForSuperUser = await IsarService().getBioInfoForSuperUser();

  //   if (bioInfoForSuperUser.length == 0) {
  //     final bioData = BioModel()
  //       ..emailAddress = emailAddress
  //       ..password = password
  //       ..role = role
  //       ..department = department
  //       ..designation = designation
  //       ..firstName = firstName
  //       ..lastName = lastName
  //       ..location = location
  //       ..mobile = mobile
  //       ..project = project
  //       ..staffCategory = staffCategory
  //       ..state = state
  //       ..firebaseAuthId = firebaseAuthId;

  //     await IsarService().saveBioData(bioData);
  //   }
  // }
}
