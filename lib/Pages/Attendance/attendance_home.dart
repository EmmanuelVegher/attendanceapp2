import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:attendanceapp/Pages/Attendance/attendance_clock.dart';
import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/Pages/Attendance/calendar_screen.dart';
import 'package:attendanceapp/Pages/Attendance/clock_attendance.dart';
import 'package:attendanceapp/Pages/Attendance/profile_screen.dart';
import 'package:attendanceapp/Pages/backup_and_restore/AES_encryption.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendance_gsheet_model.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/location_services.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // Correct import for geolocator
import '../profile_page.dart';

class AttendanceHomeScreen extends StatefulWidget {
  final IsarService service;
  const AttendanceHomeScreen({Key? key, required this.service})
      : super(key: key);
  static const String idScreen = "home";

  @override
  _AttendanceHomeScreenState createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  DatabaseAdapter adapter = HiveService();
  double screenHeight = 0;
  double screenWidth = 0;
  bool _isSynching = false;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  var firebaseAuthId;
  var state;
  var project;
  var firstName;
  var lastName;
  var designation;
  var department;
  var location;
  var staffCategory;
  var mobile;
  var emailAddress;
  var role;
  late Future<User> user;
  var newUser;
  var id;
  late SharedPreferences sharedPreferences;
  late StreamSubscription subscription;
  bool _isBusy = false;
  OpenFileDialogType _dialogType = OpenFileDialogType.document;
  SourceType _sourceType = SourceType.photoLibrary;
  bool _allowEditing = false;
  File? _currentFile;
  String? _savedFilePath;
  bool _localOnly = false;
  bool _copyFileToCacheDir = true;
  String? _pickedFilePath;

  DirectoryLocation? _pickedDirecotry;
  Future<bool> _isPickDirectorySupported =
      FlutterFileDialog.isPickDirectorySupported();
  //AESEncryption encryption = new AESEncryption();
  List localFileSave = [];

  //String id = "";

  Color primary = const Color(0xffeef444c);

  int currentIndex = 0;

  List<IconData> navigationIcons = [
    Icons.calendar_month_outlined,
    Icons.check,
    Icons.verified_user,
  ];

  @override
  void initState() {
    super.initState();
    //getCurrentDateRecordCount();
    //_pickImage();
    _startLocationService();
    //checkClockInandOutLocation();
    _updateEmptyClockInLocation().then((value) async {
      await _updateEmptyClockInLocation();
      await _updateEmptyClockOutLocation();
    });
    // _updateEmptyClockInAndOutLocation().then((value) {
    //_startTimer(context);
    _getUserDetail();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   isDeviceConnected = await InternetConnectionChecker().hasConnection;
    //   log("Internet status ====== $isDeviceConnected");
    // });
    // });
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await widget.service.getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

//   Future<void> _pickImage() async {
//     try {
//       //ImagePicker imagePicker = ImagePicker();
//       // Create a reference from an HTTPS URL
// // Note that in the URL, characters are URL escaped!
//       final image =
//           FirebaseStorage.instance.refFromURL(UserModel.profilePicLink);
//       //var image = await Image.network(UserModel.profilePicLink);
//       if (image == null) return;
//       print("DownloadImage =====$image");

//       try {
//         const oneMegabyte = 1024 * 1024;
//         final Uint8List? data = await image.getData(oneMegabyte);
//         print("DownloadImageUint8List =====$data");
//         //adapter.storeImage(data!);
//         // Data for "images/island.jpg" is returned, use this as needed.
//       } on FirebaseException catch (e) {
//         // Handle any errors.
//       }

//       //Uint8List imageBytes = await image.readAsBytes();
//       //adapter.storeImage(imageBytes);
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Error:${e.toString()}",
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.black54,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      state = userDetail?.state;
      project = userDetail?.project;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      designation = userDetail?.designation;
      department = userDetail?.department;
      location = userDetail?.location;
      staffCategory = userDetail?.staffCategory;
      mobile = userDetail?.mobile;
      emailAddress = userDetail?.emailAddress;
      id = userDetail?.id;
      role = userDetail?.role;
    });
  }

  // getConnectivity() {
  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) async {
  //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //     log("Internet status ====== $isDeviceConnected");
  //     if (!isDeviceConnected && isAlertSet == false) {
  //       showDialogBox();
  //       setState(() {
  //         isAlertSet = true;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
   // subscription.cancel();
    // _startTimer(context);
    _getUserDetail();
    //getConnectivity();
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kindly choose your restore preference'),
            content: Text(
                "Kindly Note that this overides all data stored locally and restores all data from the chosen restore preference"
                //controller: _textFieldController,
                //decoration: InputDecoration(hintText: "TextField in Dialog"),
                ),
            actions: <Widget>[
              MyButton(
                  label: "Local DB Restore",
                  onTap: () async {
                    await getLocalFile().then((value) {
                      Navigator.of(context).pop();
                    });
                  }),
              MyButton(
                  label: "Restore from server",
                  onTap: () async {
                    //getConnectivity();

                    if (isDeviceConnected) {
                      CircularProgressIndicator();
                      log("isDeviceConnectedIf===$isDeviceConnected");
                      await IsarService()
                          .removeAllAttendance(AttendanceModel());
                      final CollectionReference snap3 = await FirebaseFirestore
                          .instance
                          .collection('Staff')
                          .doc(firebaseAuthId)
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
                          ..clockInLongitude =
                              attendanceHistory.clockInLongitude
                          ..clockOut = attendanceHistory.clockOut
                          ..clockOutLatitude =
                              attendanceHistory.clockOutLatitude
                          ..clockOutLocation =
                              attendanceHistory.clockOutLocation
                          ..clockOutLongitude =
                              attendanceHistory.clockOutLongitude
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
                          msg: "Sychning from server",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black54,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      //Navigator.of(context).pop();
                    } else {
                      log("isDeviceConnectedElse ==$isDeviceConnected");
                     // getConnectivity();
                      Fluttertoast.showToast(
                          msg: "Connection to Internet Lost..",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black54,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  _displayDialog2(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sync Attendance/ Local Backup'),
            content: Text(
                "Kindly Note that only attendance with Clock-out gets synced.So kindly clock-in and Clock-out before synchning "
                //controller: _textFieldController,
                //decoration: InputDecoration(hintText: "TextField in Dialog"),
                ),
            actions: <Widget>[
              MyButton(
                  label: "Sync Attendance",
                  onTap: () async {
                    _isSynching = true;

                    await _uploadImageToFirebaseServer();

                    await _startSynching()
                        .then((value) => {_isSynching = false});

                    Navigator.of(context).pop();
                  }),
              MyButton(
                  label: "Local Backup",
                  onTap: () async {
                    await saveLocalFile().then((value) {
                      Navigator.of(context).pop();
                    });
                    //
                  })
            ],
          );
        });
  }

  Future<void> _startLocationService() async {
    LocationService locationService = LocationService();

    Position? position = await locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        UserModel.long = position.longitude;
        UserModel.lat = position.latitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Attendance",
          style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.red),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.white,
                Colors.white,
              ])),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _displayDialog2(context);
              },
              child: Icon(
                Icons.upload,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _displayDialog(context);
              },
              child: Icon(
                Icons.download,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      drawer: role == "User"
          ? drawer(this.context, IsarService())
          : drawer2(this.context, IsarService()),
      body: IndexedStack(
        index: currentIndex,
        children: [
          new CalendarScreen(
            service: IsarService(),
          ),
          new ClockAttendance(
            IsarService(), service: IsarService(),
          ),
          new ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currentIndex ? primary : Colors.black54,
                              size: i == currentIndex ? 30 : 23,
                            ),
                            i == currentIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    height: 3,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }

  // _showBottomSheet2(
  //   BuildContext context,
  // ) {
  //   return showBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           padding: const EdgeInsets.only(top: 4),
  //           height: MediaQuery.of(context).size.height * 0.32,
  //           width: MediaQuery.of(context).size.width * 1,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: Colors.white,
  //           ),
  //           child: Column(
  //             children: [
  //               Container(
  //                 height: 6,
  //                 width: 120,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.deepOrange,
  //                 ),
  //               ),
  //               Spacer(),
  //               _bottomSheetButton(
  //                 label: "Sync Data",
  //                 onTap: () async {
  //                   // final feedback =
  //                   //     await widget.service.getSpecificFeedback(id);
  //                   // Navigator.push(
  //                   //     context,
  //                   //     MaterialPageRoute(
  //                   //         builder: (context) => ModifySheetsPage(
  //                   //               feedback: feedback,
  //                   //             )));
  //                   //_updateFeedback(context, id);
  //                   //_taskController.markTaskCompleted(task.id!);
  //                   //Navigator.of(context).pop();
  //                 },
  //                 clr: Colors.red,
  //                 context: context,
  //               ),
  //               _bottomSheetButton(
  //                 label: "Local Backup",
  //                 onTap: () async {
  //                   // await widget.service.deleteFeedback(id);
  //                   // Navigator.of(context).pop();
  //                 },
  //                 clr: Colors.orange,
  //                 context: context,
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               _bottomSheetButton(
  //                 label: "Close",
  //                 onTap: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 clr: Colors.red,
  //                 isClose: true,
  //                 context: context,
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // _bottomSheetButton(
  //     {required String label,
  //     required Function()? onTap,
  //     required Color clr,
  //     bool isClose = false,
  //     required BuildContext context}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 4),
  //       height: 55,
  //       width: MediaQuery.of(context).size.width * 0.9,
  //       decoration: BoxDecoration(
  //         color: isClose == true ? Colors.red : Colors.blue,
  //         border: Border.all(
  //           width: 2,
  //           color: Colors.grey[300]!,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         //color: Colors.transparent,
  //       ),
  //       child: Center(
  //         child: Text(label,
  //             style: TextStyle(
  //                 fontSize: 16, color: Colors.white, fontFamily: "NexaBold")),
  //       ),
  //     ),
  //   );
  // }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    DatabaseAdapter adapter = HiveService();
    return adapter.getImages();
  }

  _uploadImageToFirebaseServer() async {
//   final appDocDir = await getApplicationDocumentsDirectory();
// final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
// final file = File(filePath);
    final file2 = await _readImagesFromDatabase();

// // Create the file metadata
// //final metadata = SettableMetadata(contentType: "image/jpeg");

// // Create a reference to the Firebase Storage bucket
//     final storageRef = FirebaseStorage.instance.ref();

// // Create a reference to "mountains.jpg"
//     final attendanceRef = storageRef.child("attendance.jpg");

// // Create a reference to 'images/mountains.jpg'
//     final attendanceImagesRef = storageRef.child("images/attendance.jpg");

// // While the file names are the same, the references point to different files
//     assert(attendanceRef.name == attendanceImagesRef.name);
//     assert(attendanceRef.fullPath != attendanceImagesRef.fullPath);

    try {
      Reference ref = FirebaseStorage.instance.ref().child(
          "${firstName.toLowerCase()}_${lastName.toLowerCase()}_profilepic.jpg");

      //await ref.putFile(File(image!.path));
      // Upload raw data.
      await ref.putData(file2![0]);
      //print("ImageBackup ==== ${file2[0]}");

      ref.getDownloadURL().then((value) async {
        setState(() {
          //Save Profile pic URL in User class
          UserModel.profilePicLink = value;
        });
        //Save Profile Pic link to firebase
        await FirebaseFirestore.instance
            .collection("Staff")
            .doc(firebaseAuthId)
            .update({
          "profilePic": value,
        });
      });
    } on FirebaseException catch (e) {
      // ...
    }

// // Upload file and metadata to the path 'images/mountains.jpg'
// final uploadTask = storageRef
//     .child("images/path/to/mountains.jpg")
//     .putFile(file, metadata);

// // Listen for state changes, errors, and completion of the upload.
// uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
//   switch (taskSnapshot.state) {
//     case TaskState.running:
//       final progress =
//           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
//       print("Upload is $progress% complete.");
//       break;
//     case TaskState.paused:
//       print("Upload is paused.");
//       break;
//     case TaskState.canceled:
//       print("Upload was canceled");
//       break;
//     case TaskState.error:
//       // Handle unsuccessful uploads
//       break;
//     case TaskState.success:
//       // Handle successful uploads on complete
//       // ...
//       break;
//   }
// });
  }

// Data Backup, Synchning and Data Restore

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    String saveDirectory =
        ('$dir/attendancebackup'.replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
            .replaceAll("Directory", "");
    String savePath2 = ('$saveDirectory/attendancebackup.json'
            .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
        .replaceAll("Directory", "");
    // final path = await _localPath;
    return File(savePath2);
  }

  Future<File> get _localFile2 async {
    final dir = await getApplicationDocumentsDirectory();
    String saveDirectory =
        ('$dir/attendancebackup'.replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
            .replaceAll("Directory", "");
    String savePath2 = ('$saveDirectory/bioInfoBackup.json'
            .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
        .replaceAll("Directory", "");
    // final path = await _localPath;
    return File(savePath2);
  }

  writeAttendanceToJson() async {
    final file = await _localFile;

    // Write the file
    return file
        .writeAsStringSync(json.encode(widget.service.exportAllAttendance()));
  }

  void requestReadWritPermission() async {
    var status = Permission.storage.status;

    if (await status.isGranted) {
      print("Permission is granted");
      await saveLocalFile();
      await getLocalFile();
    } else if (await status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        print("Permission was granted");
      }
    }
  }

  Future<void> getLocalFile() async {
    var status = Permission.storage.status;
    if (await status.isGranted) {
      print("Permission is granted");
      final dir = await getApplicationDocumentsDirectory();
      print("Download Directory = $dir");
      // print("Download Directory2 = $dir2");
      String saveDirectory =
          ('$dir/attendancebackup'.replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
              .replaceAll("Directory", "");
      String savePath2 = ('$saveDirectory/attendancebackup.json'
              .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
          .replaceAll("Directory", "");

      String savePathBioInfo = ('$saveDirectory/bioInfoBackup.json'
              .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
          .replaceAll("Directory", "");
      List<AttendanceModel> list;
      List<BioModel> list2;
      String saveDirect = "/storage/emulated/0/Download/attendancebackup";
      String savePath =
          "/storage/emulated/0/Download/attendancebackup/attendancebackup.json";
      final File file = File(savePath2);
      final File file2 = File(savePathBioInfo);

      //clear DB
      widget.service.cleanDB();

      if (await Directory(saveDirectory).exists()) {
        //Restore Attendance
        if (await File(savePath2).exists()) {
          try {
            final file = await _localFile;
            // Read the file
            final contents = await file.readAsString();
            var data = json.decode(contents);
            var rest = data['Attendance'] as List;

            //await widget.service.importAllAttendance(contents['Attendance']);
            print(rest);
            list = rest
                .map<AttendanceModel>((json) => AttendanceModel.fromJson(json))
                .toList();
            print("list ==============${list[0].durationWorked}");

            for (var restoreBackup in list) {
              final attendnce = AttendanceModel()
                ..clockIn = restoreBackup.clockIn
                ..date = restoreBackup.date
                ..clockInLatitude = restoreBackup.clockInLatitude
                ..clockInLocation = restoreBackup.clockInLocation
                ..clockInLongitude = restoreBackup.clockInLongitude
                ..clockOut = restoreBackup.clockOut
                ..clockOutLatitude = restoreBackup.clockOutLatitude
                ..clockOutLocation = restoreBackup.clockOutLocation
                ..clockOutLongitude = restoreBackup.clockOutLongitude
                ..isSynced = restoreBackup.isSynced
                ..voided = restoreBackup.voided
                ..isUpdated = restoreBackup.isUpdated
                ..durationWorked = restoreBackup.durationWorked
                ..noOfHours = restoreBackup.noOfHours
                ..offDay = restoreBackup.offDay
                ..month = restoreBackup.month;

              widget.service.saveAttendance(attendnce);
              Fluttertoast.showToast(
                  msg: "Restore Complete",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            //widget.service.importAllAttendance(list);

            //return int.parse(contents);
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Error: $e",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.black54,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            // If encountering an error, return 0
            // return 0;
          }
        } else {
          Fluttertoast.showToast(
              msg: "Attendance Backup does not exist. Kindly backup",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        if (await File(savePathBioInfo).exists()) {
          try {
            final file2 = await _localFile2;
            // Read the file
            final contents2 = await file2.readAsString();
            var data2 = json.decode(contents2);
            var rest2 = data2['BioInfo'] as List;

            //await widget.service.importAllAttendance(contents['Attendance']);
            print(rest2);
            list2 =
                rest2.map<BioModel>((json) => BioModel.fromJson(json)).toList();
            //print("list ==============${list[0].durationWorked}");

            for (var restoreBackup2 in list2) {
              final bioInfo = BioModel()
                ..department = restoreBackup2.department
                ..designation = restoreBackup2.designation
                ..emailAddress = restoreBackup2.emailAddress
                ..firebaseAuthId = restoreBackup2.firebaseAuthId
                ..firstName = restoreBackup2.firstName
                ..lastName = restoreBackup2.lastName
                ..location = restoreBackup2.location
                ..mobile = restoreBackup2.mobile
                ..password = restoreBackup2.password
                ..project = restoreBackup2.project
                ..role = restoreBackup2.role
                ..staffCategory = restoreBackup2.staffCategory
                ..state = restoreBackup2.state;

              widget.service.saveBioData(bioInfo);
              Fluttertoast.showToast(
                  msg: "Restore Complete",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            //widget.service.importAllAttendance(list);

            //return int.parse(contents);
          } catch (e) {
            Fluttertoast.showToast(
                msg: "Error: $e",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.black54,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            // If encountering an error, return 0
            // return 0;
          }
        } else {
          Fluttertoast.showToast(
              msg: "BioInfo Backup does not exist. Kindly backup",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Directory does not exist. Kindly backup",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else if (await status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        print("Permission was granted");
      }
    }
  }

  Future<void> localFile() async {
    localFileSave = [];
    List<AttendanceModel> getAllAttend =
        await widget.service.getAllAttendance();

    List<Map<String, dynamic>>? listAttendance =
        getAllAttend.map((e) => e.toJson()).toList();
    Map<String, dynamic> params = {'Attendance': listAttendance};
    //print(params);

    // for (var allAttend in getAllAttend) {
    //   List<Map<String, dynamic>>? listAttendance =
    //       allAttend.map((e) => e.toJson()).toList();
    //   Map<String, dynamic> params = {'Attendance': listAttendance};
    //   print(params);
    //   //return params;
    //   localFileSave.add(listAttendance);
    // }

    print("localFileSave =======$params");
  }

  Future<void> saveLocalFile() async {
    var status = Permission.storage.status;

    if (await status.isGranted) {
      log("Permission is granted");
      //moveFile(file2, saveDirect);
      // final dir = await getExternalStorageDirectory();
      final dir = await getApplicationDocumentsDirectory();
      print("Download Directory = $dir");
      // print("Download Directory2 = $dir2");
      String saveDirect =
          ('$dir/attendancebackup'.replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
              .replaceAll("Directory", "");
      String savePath = ('$saveDirect/attendancebackup.json'
              .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
          .replaceAll("Directory", "");
      String savePathBio = ('$saveDirect/bioInfoBackup.json'
              .replaceAll(RegExp('[^A-Za-z0-9/.]'), ''))
          .replaceAll("Directory", "");

      print("saveDirect ============== $saveDirect");
      print("savePath ========== $savePath");

      String saveDirectory = "/storage/emulated/0/Download/attendancebackup";
      String savePath2 =
          "/storage/emulated/0/Download/attendancebackup/attendancebackup.json";

      print("savePath File = $savePath");
      //final File file2 = File(savePath2);
      final File file = File(savePath);
      final File file2 = File(savePathBio);
      final attendanceModel = await widget.service.exportAllAttendance();
      final bioModel = await widget.service.exportAllBioInfo();

      if (await Directory(saveDirect).exists()) {
        if (await File(savePath).exists()) {
          log("Attendance File exists");
          // print(attendanceFor1990);
          await file.delete(recursive: true);

          // final File copiedFile = File(savePath2);
          // copiedFile.

          //file.writeAsStringSync("");

          file.writeAsStringSync(json.encode(attendanceModel));
          //_pickFile();
          // final File copiedFile = File(savePath);
          // copiedFile.copySync(savePath2);
          //moveFile(copiedFile, saveDirectory);
          Fluttertoast.showToast(
              msg: "Replacing Existing Backup..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //});
        } else {
          print("File don't exists");
          Fluttertoast.showToast(
              msg: "Creating New Backup..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          new File(savePath).create(recursive: true).then((File file) async {
            // Stuff to do after file has been created...
            //await attendanceModel.then((value) {
            file.writeAsStringSync(json.encode(attendanceModel));
            //});
            // print("AttendanceModel File = $attendanceModel");
          });
        }
        //BioInfo Save

        if (await File(savePathBio).exists()) {
          //print("File exists");
          log("Bio File exists");
          await file2.delete(recursive: true);

          // final File copiedFile = File(savePath2);
          // copiedFile.

          //file.writeAsStringSync("");

          file2.writeAsStringSync(json.encode(bioModel));
          //_pickFile();
          // final File copiedFile = File(savePath);
          // copiedFile.copySync(savePath2);
          //moveFile(copiedFile, saveDirectory);
          Fluttertoast.showToast(
              msg: "Replacing Existing Backup..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //});
        } else {
          log("Bio File does exists");
          Fluttertoast.showToast(
              msg: "Creating New Backup..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          new File(savePathBio)
              .create(recursive: true)
              .then((File file2) async {
            // Stuff to do after file has been created...
            //await attendanceModel.then((value) {
            file2.writeAsStringSync(json.encode(bioModel));
            //});
            // print("AttendanceModel File = $attendanceModel");
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "Creating Backup Folder.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        print("Directory Doesnt exist");
        new Directory(saveDirect)
            .create(recursive: true)
            .then((Directory directory) {
          print(directory.path);
        }).then((value) => {
                  new File(savePath).create(recursive: true).then((File file) {
                    Fluttertoast.showToast(
                        msg: "Creating New Backup..",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.black54,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // Stuff to do after file has been created...
                    file.writeAsStringSync(json.encode(attendanceModel));
                    print("AttendanceModel File = $attendanceModel");
                  }).then((value) => {
                        new File(savePathBio)
                            .create(recursive: true)
                            .then((File file2) {
                          Fluttertoast.showToast(
                              msg: "Creating BioInfo Backup..",
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.black54,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          // Stuff to do after file has been created...
                          file2.writeAsStringSync(json.encode(bioModel));
                          //print("AttendanceModel File = $attendanceModel");
                        })
                      })
                });
      }
    } else if (await status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        print("Permission was granted");
      }
    }
  }

  Future<void> _pickFile() async {
    String? result;
    try {
      setState(() {
        _isBusy = true;
        _currentFile = null;
      });
      final params = OpenFileDialogParams(
        dialogType: _dialogType,
        sourceType: _sourceType,
        allowEditing: _allowEditing,
        localOnly: _localOnly,
        copyFileToCacheDir: _copyFileToCacheDir,
      );
      result = await FlutterFileDialog.pickFile(params: params);
      log(result.toString());
    } on PlatformException catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _pickedFilePath = result;
        if (result != null) {
          _currentFile = File(result);
        } else {
          _currentFile = null;
        }
        _isBusy = false;
      });
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  // ------------------
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("No Connection"),
          content: const Text("Please Check your internet connectivity"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, "Cancel");
                  setState(() {
                    isAlertSet = false;
                  });
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialogBox();
                    setState(() {
                      isAlertSet = true;
                    });
                  }
                },
                child: const Text("OK"))
          ],
        ),
      );
//This method updates all empty Clock-In Location Using the Latitude and Longitude during clock-out
  Future<void> _updateEmptyClockInLocation() async {
    //First, query the list of all records with empty Clock-In Location
    List<AttendanceModel> attendanceForEmptyLocation =
        await widget.service.getAttendanceForEmptyClockInLocation();
    try {
      for (var attend in attendanceForEmptyLocation) {
        // Create a variable
        var location1 = "";
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockInLatitude!, attend.clockInLongitude!);

        setState(() {
          location1 =
              "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
        });
        //log("ClockInPlacemarker = $location");

        //Update all missing Clock In location
        await widget.service.updateEmptyClockInLocation(
            attend.id, AttendanceModel(), location1);
        //print(attend.clockInLatitude);
      }
    } catch (e) {
      log(e.toString());
    }

    //Iterate through each queried loop
  }

  // Future<void> checkClockInandOutLocation() async {
  //   List<AttendanceModel> attendanceForEmptyLocation =
  //       await widget.service.getAttendanceForEmptyClockInLocation();

  //   List<AttendanceModel> attendanceForEmptyLocation2 =
  //       await widget.service.getAttendanceForEmptyClockOutLocation();

  //   print("attendanceForEmptyLocation === $attendanceForEmptyLocation");
  //   print("attendanceForEmptyLocation2 === $attendanceForEmptyLocation2");
  // }

//This method updates all empty Clock-Out Location Using the Latitude and Longitude during clock-out
  Future<void> _updateEmptyClockOutLocation() async {
    //First, query the list of all records with empty Clock-In Location
    List<AttendanceModel> attendanceForEmptyLocation =
        await widget.service.getAttendanceForEmptyClockOutLocation();

    try {
      for (var attend in attendanceForEmptyLocation) {
        // Create a variable
        var location2 = "";
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockOutLatitude!, attend.clockOutLongitude!);

        setState(() {
          location2 =
              "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
        });

        //log("ClockOutPlacemarker = $location");

        //Update all missing Clock In location
        await widget.service.updateEmptyClockOutLocation(
            attend.id, AttendanceModel(), location2);
        //print(attend.clockInLatitude);
      }
    } catch (e) {
      log(e.toString());
    }

    //Iterate through each queried loop
  }

  //This method checks and updates and empty Clock-in and Clock-Out Location before syncning the data
  Future<void> _updateEmptyClockInAndOutLocation() async {
    await _updateEmptyClockInLocation().then((value) {
      _updateEmptyClockOutLocation();
    });
  }

//This Method updates the Googlesheet that is connected to the Dashboard
  Future _updateGoogleSheet(
    String state1,
    String project1,
    String firstName1,
    String lastName1,
    String designation1,
    String department1,
    String location1,
    String staffCategory1,
    String mobile1,
    String date1,
    String emailAddress1,
    String clockIn1,
    String clockInLatitude1,
    String clockInLongitude1,
    String clockInLocation1,
    String clockOut1,
    String clockOutLatitude1,
    String clockOutLongitude1,
    String clockOutLocation1,
    String durationWorked1,
    String noOfHours1,
  ) async {
    final user = await User(
        state: state1,
        project: project1,
        firstName: firstName1,
        lastName: lastName1,
        designation: designation1,
        department: department1,
        location: location1,
        staffCategory: staffCategory1,
        mobile: mobile1,
        date: date1,
        emailAddress: emailAddress1,
        clockIn: clockIn1,
        clockInLatitude: clockInLatitude1,
        clockInLongitude: clockInLongitude1,
        clockInLocation: clockInLocation1,
        clockOut: clockOut1,
        clockOutLatitude: clockOutLatitude1,
        clockOutLongitude: clockOutLongitude1,
        clockOutLocation: clockOutLocation1,
        durationWorked: durationWorked1,
        noOfHours: noOfHours1);
    final id = await AttendanceGSheetsApi.getRowCount() + 1;
    final newUser = user.copy(id: id);
    await AttendanceGSheetsApi.insert([newUser.toJson()]);
    log("newUser ID ===== $newUser");
  }

// This Method updates all attendance that has a clock-out made. This is necessary for data validation and to ensure that folks sign-out appropraitely
  syncCompleteData() async {
    try {
      // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before chahing the sync status on Mobile App to "Synced"
      //Query the firebase and get the records having updated records
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: firebaseAuthId)
          .get();

      List<AttendanceModel> getAttendanceForPartialUnSynced =
          await widget.service.getAttendanceForPartialUnSynced();

      await _updateEmptyClockInAndOutLocation().then((value) async => {
            //Iterate through each queried loop
            for (var unSyncedAttend in getAttendanceForPartialUnSynced)
              {
                await _updateGoogleSheet(
                        state,
                        project,
                        firstName,
                        lastName,
                        designation,
                        department,
                        location,
                        staffCategory,
                        mobile,
                        unSyncedAttend.date.toString(),
                        emailAddress,
                        unSyncedAttend.clockIn.toString(),
                        unSyncedAttend.clockInLatitude.toString(),
                        unSyncedAttend.clockInLongitude.toString(),
                        unSyncedAttend.clockInLocation.toString(),
                        unSyncedAttend.clockOut.toString(),
                        unSyncedAttend.clockOutLatitude.toString(),
                        unSyncedAttend.clockOutLongitude.toString(),
                        unSyncedAttend.clockOutLocation.toString(),
                        unSyncedAttend.durationWorked.toString(),
                        unSyncedAttend.noOfHours.toString())
                    .then((value) async {
                  await FirebaseFirestore.instance
                      .collection("Staff")
                      .doc(snap.docs[0].id)
                      .collection("Record")
                      .doc(unSyncedAttend.date)
                      .set({
                    "Offline_DB_id": unSyncedAttend.id,
                    'clockIn': unSyncedAttend.clockIn,
                    'clockOut': unSyncedAttend.clockOut,
                    'clockInLocation': unSyncedAttend.clockInLocation,
                    'clockOutLocation': unSyncedAttend.clockOutLocation,
                    'date': unSyncedAttend.date,
                    'isSynced': true,
                    'clockInLatitude': unSyncedAttend.clockInLatitude,
                    'clockInLongitude': unSyncedAttend.clockInLongitude,
                    'clockOutLatitude': unSyncedAttend.clockOutLatitude,
                    'clockOutLongitude': unSyncedAttend.clockOutLongitude,
                    'voided': unSyncedAttend.voided,
                    'isUpdated': unSyncedAttend.isUpdated,
                    'noOfHours': unSyncedAttend.noOfHours,
                    'month': unSyncedAttend.month,
                    'durationWorked': unSyncedAttend.durationWorked,
                    'offDay': unSyncedAttend.offDay,
                  }).then((value) => widget.service.updateSyncStatus(
                          unSyncedAttend.id, AttendanceModel(), true));
                })
              }
          });
    } catch (e) {
      // The catch block executes incase firebase database encounters an error thereby only saving the data in the google sheet for the analytics before chahing the sync status on Mobile App to "Synced"
      log("Sync Error Skipping firebase DB = ${e.toString()}");
      List<AttendanceModel> getAttendanceForPartialUnSynced =
          await widget.service.getAttendanceForPartialUnSynced();

      //await _updateEmptyClockInAndOutLocation().then((value) async => {
      //Iterate through each queried loop
      for (var unSyncedAttend in getAttendanceForPartialUnSynced) {
        await _updateGoogleSheet(
                state,
                project,
                firstName,
                lastName,
                designation,
                department,
                location,
                staffCategory,
                mobile,
                unSyncedAttend.date.toString(),
                emailAddress,
                unSyncedAttend.clockIn.toString(),
                unSyncedAttend.clockInLatitude.toString(),
                unSyncedAttend.clockInLongitude.toString(),
                unSyncedAttend.clockInLocation.toString(),
                unSyncedAttend.clockOut.toString(),
                unSyncedAttend.clockOutLatitude.toString(),
                unSyncedAttend.clockOutLongitude.toString(),
                unSyncedAttend.clockOutLocation.toString(),
                unSyncedAttend.durationWorked.toString(),
                unSyncedAttend.noOfHours.toString())
            .then((value) async {
          widget.service
              .updateSyncStatus(unSyncedAttend.id, AttendanceModel(), true);
        });
      }
      // });
    }
  }

  // void _startTimer(BuildContext context) {
  //   Timer.periodic(const Duration(seconds: 60), (timer) {
  //     log("timer started===========");
  //     log("timer=====${timer.tick}");
  //     if (isDeviceConnected) {
  //       _updateEmptyClockInAndOutLocation().then((value) {
  //         syncCompleteData();
  //       }).then((value) {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text("Data synced...")));
  //       });
  //       //updateFullSyncedData();
  //     }
  //   });
  // }

  Future<void> _startSynching() async {
    if (isDeviceConnected) {
      Fluttertoast.showToast(
          msg: "Data Synching....",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      await _updateEmptyClockInAndOutLocation().then((value) async {
        await syncCompleteData();
      });
      // .then((value) {
      //   Fluttertoast.showToast(
      //       msg: "Data Synching....",
      //       toastLength: Toast.LENGTH_LONG,
      //       backgroundColor: Colors.black54,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // });
      //updateFullSyncedData();
    } else {
      Fluttertoast.showToast(
          msg: "Connection to Internet lost..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      showDialogBox();
    }
  }
}
