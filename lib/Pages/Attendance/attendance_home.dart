import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/Pages/Attendance/calendar_screen.dart';
import 'package:attendanceapp/Pages/Attendance/clock_attendance.dart';
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
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'; // Correct import for geolocator
import '../../model/appversion.dart';
import '../../model/departmentmodel.dart';
import '../../model/designationmodel.dart';
import '../../model/last_update_date.dart';
import '../../model/locationmodel.dart';
import '../../model/projectmodel.dart';
import '../../model/reasonfordaysoff.dart';
import '../../model/staffcategory.dart';
import '../../model/statemodel.dart';
import '../../model/supervisor_model.dart';
import '../../model/track_location_model.dart';
import '../../services/notification_services.dart';
import '../../widgets/constants.dart';
import '../../widgets/geo_utils.dart';
import '../profile_page.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'attendance_report.dart';

class AttendanceHomeScreen extends StatefulWidget {
  final IsarService service;
  const AttendanceHomeScreen({Key? key, required this.service})
      : super(key: key);
  static const String idScreen = "home";

  @override
  _AttendanceHomeScreenState createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  // final _calendarKey = GlobalKey<CalendarScreenState>();
  // final _clockAttendanceKey = GlobalKey<ClockAttendanceState>();
  // final _profileKey = GlobalKey<ProfilePageState>();

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
  final OpenFileDialogType _dialogType = OpenFileDialogType.document;
  final SourceType _sourceType = SourceType.photoLibrary;
  final bool _allowEditing = false;
  File? _currentFile;

  final bool _localOnly = false;
  final bool _copyFileToCacheDir = true;
  bool isAppCheckShown = false;
  String? _pickedFilePath;
  var notifyHelper;
  var _timer;

  DirectoryLocation? _pickedDirecotry;
  final Future<bool> _isPickDirectorySupported =
      FlutterFileDialog.isPickDirectorySupported();
  //AESEncryption encryption = new AESEncryption();
  List localFileSave = [];

  //String id = "";

  Color primary = const Color(0xffeef444c);

  int currentIndex = 0;

  List<IconData> navigationIcons = [
    Icons.calendar_month_outlined,
    Icons.check,
    Icons.report,
    Icons.verified_user,
  ];

  @override
  void initState() {
    super.initState();
    //getCurrentDateRecordCount();
    //_pickImage();
   // _checkTimeAndTriggerNotification();
   // checkForAppVersion();

    tz.initializeTimeZones();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkTimeAndTriggerNotification();
    });
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
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

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      log("Internet status ====== $isDeviceConnected");
    });

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


  void _checkTimeAndTriggerNotification() {
    final now = DateTime.now();
    print("Current Time === $now");

  }

  Future<void> _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    // Check if the widget is still mounted
    if (mounted) { // <-- Add this check
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

  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      log("Internet status ====== $isDeviceConnected");
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    // _startTimer(context);
    _getUserDetail();
    _timer.cancel();
    //getConnectivity();
  }



  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Kindly choose your restore preference'),
            content: const Text(
                '''Kindly Note that this overides all data stored locally and restores all data from the chosen restore preference.
                
 Warning!!!

1) Any Record not synced would be cleared off if you decide to "Restore from server".
2) Only Choose the "Local DB Restore" if the Local Database is up-to-date.               
                '''
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
                      const CircularProgressIndicator();
                      log("isDeviceConnectedIf===$isDeviceConnected");
                      await IsarService()
                          .removeAllAttendance(AttendanceModel());
                      final CollectionReference snap3 = FirebaseFirestore
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
                          ..comments = attendanceHistory.comments
                          ..month = attendanceHistory.month;

                        widget.service.saveAttendance(attendnce);
                      }
                      print("FirebaseID ====$firebaseAuthId");
                      const CircularProgressIndicator(value: 0.0);
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
            title: const Text('Sync Attendance/ Local Backup'),
            content: const Text(
                "Kindly Note that only attendance with Clock-out gets synced.So kindly clock-in and Clock-out before synchning "
                //controller: _textFieldController,
                //decoration: InputDecoration(hintText: "TextField in Dialog"),
                ),
            actions: <Widget>[
              MyButton(
                  label: "Sync Attendance",
                  onTap: () async {
                    _isSynching = true;
                    try{
                      await _uploadImageToFirebaseServer();
                    }catch(e){
                      log("_uploadImageToFirebaseServer Error: $e");
                    }



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
        title: const Text(
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
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _displayDialog2(context);
              },
              child: const Icon(
                Icons.upload,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _displayDialog(context);
              },
              child: const Icon(
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
          CalendarScreen(

            service: IsarService(),
          ),
          ClockAttendance(
            IsarService(), service: IsarService(), controller: null,
          ),
         const AttendanceReportPage(),

          const ProfilePage(

          ),
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
                        // Refresh CalendarScreen if it's the newly selected tab
                        if (i == 0){
                          print("currentIndex == 0");
                        }
                        else if (i == 1) {
                         // Get.find<CalendarController>().refreshAttendance();
                          print("currentIndex == 1");
                          Get.find<ClockAttendanceController>().refreshClockAttendance();
                        }else if (i == 2) {
                          print("currentIndex == 2");
                        }else if (i == 3) {
                          print("currentIndex == 2");
                        }

                      });
                      // Close the previous page (if not the first route)
                      // if (Navigator.canPop(context)) {
                      //   Navigator.pop(context);
                      // }
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
          "attendanceapp-a6853.appspot.com/profile_pics/${firstName.toLowerCase()}_${lastName.toLowerCase()}_${firebaseAuthId}_profilepic.jpg");

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
          "photoUrl": value,
        });
      });
    } on FirebaseException catch (e) {
      // ...
      Fluttertoast.showToast(
        msg: "Error: $e!",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

      String saveDirectory = ('$dir/attendancebackup'.replaceAll(RegExp('[^A-Za-z0-9/.]'), '')).replaceAll("Directory", "");
      String savePath2 = ('$saveDirectory/attendancebackup.json'.replaceAll(RegExp('[^A-Za-z0-9/.]'), '')).replaceAll("Directory", "");
      String savePathBioInfo = ('$saveDirectory/bioInfoBackup.json'.replaceAll(RegExp('[^A-Za-z0-9/.]'), '')).replaceAll("Directory", "");

      List<AttendanceModel> attendanceList = [];
      List<BioModel> bioList = [];


      // Ensure backup files exist
      if (await Directory(saveDirectory).exists()) {

        await File(savePath2).exists().then((_) async {
          if (await File(savePath2).exists()) {
          try {
          final file = File(savePath2);
          final contents = await file.readAsString();
          var data = json.decode(contents);
          var attendanceData = data['Attendance'] as List;

          attendanceList = attendanceData.map<AttendanceModel>((json) => AttendanceModel.fromJson(json)).toList();

          print("attendanceList=== $attendanceList");

          if (attendanceList.isNotEmpty) {
          // Only clean cleanAttendanceCollection after successful retrieval
          widget.service.cleanAttendanceCollection();
          await widget.service.saveAllAttendance(attendanceList); // Batch insert attendance
          Fluttertoast.showToast(msg: "Attendance Restore Complete");


          Fluttertoast.showToast(
          msg: "Attendance Restore Complete",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          } else {
          Fluttertoast.showToast(
          msg: "No attendance data to restore",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
          } catch (e) {
          Fluttertoast.showToast(
          msg: "Error reading attendance backup: $e",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
          } else {
          Fluttertoast.showToast(
          msg: "Attendance Backup does not exist. Kindly backup.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
        }).then((_) async {
          // Restore BioInfo
          if (await File(savePathBioInfo).exists()) {
          try {
          final file2 = File(savePathBioInfo);
          final contents2 = await file2.readAsString();
          var data2 = json.decode(contents2);
          var bioData = data2['BioInfo'] as List;

          bioList = bioData.map<BioModel>((json) => BioModel.fromJson(json)).toList();

          if (bioList.isNotEmpty) {
            widget.service.cleanBioCollection();
            // Wrap saveAllBioData in an anonymous function
            await Future.delayed(const Duration(milliseconds: 200)).then((_) async{
              await widget.service.saveAllBioData(bioList);
            });
            Fluttertoast.showToast(msg: "BioInfo Restore Complete");


          Fluttertoast.showToast(
          msg: "BioInfo Restore Complete",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          } else {
          Fluttertoast.showToast(
          msg: "No BioInfo data to restore",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
          } catch (e) {
            print("Error reading BioInfo backup: $e");
          Fluttertoast.showToast(
          msg: "Error reading BioInfo backup: $e",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
          } else {
          Fluttertoast.showToast(
          msg: "BioInfo Backup does not exist. Kindly backup.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          );
          }
        });
        // Restore Attendance



      } else {
        Fluttertoast.showToast(
          msg: "Backup Directory does not exist. Kindly backup.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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


    print("localFileSave =======$params");
  }

  Future<void> saveLocalFile() async {
    // Request permission to access storage
    var status = await Permission.storage.status;

    if (status.isGranted) {
      log("Permission is granted");

      // Get the application's document directory
      final dir = await getApplicationDocumentsDirectory();
      String saveDirect = ('$dir/attendancebackup')
          .replaceAll(RegExp('[^A-Za-z0-9/.]'), '')
          .replaceAll("Directory", "");

      String savePath = ('$saveDirect/attendancebackup.json')
          .replaceAll(RegExp('[^A-Za-z0-9/.]'), '')
          .replaceAll("Directory", "");

      String savePathBio = ('$saveDirect/bioInfoBackup.json')
          .replaceAll(RegExp('[^A-Za-z0-9/.]'), '')
          .replaceAll("Directory", "");

      final attendanceModel = await widget.service.exportAllAttendance();
      final bioModel = await widget.service.exportAllBioInfo();

      // Ensure the backup directory exists, create if not
      final backupDir = Directory(saveDirect);
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
        log("Created backup directory: $saveDirect");
        Fluttertoast.showToast(
            msg: "Creating Backup Folder.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // Handle Attendance Backup
      final attendanceFile = File(savePath);
      if (await attendanceFile.exists()) {
        log("Attendance File exists. Replacing backup...");
        await attendanceFile.delete();
      }
      await attendanceFile.writeAsString(json.encode(attendanceModel));
      Fluttertoast.showToast(
          msg: "Attendance Backup Created Successfully.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      // Handle BioInfo Backup
      final bioFile = File(savePathBio);
      if (await bioFile.exists()) {
        log("Bio File exists. Replacing backup...");
        await bioFile.delete();
      }
      await bioFile.writeAsString(json.encode(bioModel));
      Fluttertoast.showToast(
          msg: "BioInfo Backup Created Successfully.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

    } else if (status.isDenied) {
      // Request permission if denied
      if (await Permission.storage.request().isGranted) {
        log("Permission was granted");
        await saveLocalFile();
      } else {
        log("Permission denied");
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
    } on FileSystemException {
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
        bool isInsideAnyGeofence = false;
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockInLatitude!, attend.clockInLongitude!);
        List<LocationModel> isarLocations =
        await  widget.service.getLocationsByState(placemark[0].administrativeArea);
        // Convert Isar locations to GeofenceModel
        List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
          name: location.locationName!, // Use 'locationName'
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0,
          radius: location.radius?.toDouble() ?? 0.0,
        )).toList();

        print("Officessss == $offices");

        isInsideAnyGeofence = false;
        for (GeofenceModel office in offices) {
          double distance = GeoUtils.haversine(
              attend.clockInLatitude!, attend.clockInLongitude!, office.latitude, office.longitude);
          if (distance <= office.radius) {
            print('Entered office: ${office.name}');

            location1 = office.name;
            isInsideAnyGeofence = true;
            break;
          }
        }

        if (!isInsideAnyGeofence) {
          List<Placemark> placemark = await placemarkFromCoordinates(
              attend.clockInLatitude!, attend.clockInLongitude!);

          location1 =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

          print("Location from map === $location1");
        }


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



  Future<void> _updateEmptyClockOutLocation() async {
    //First, query the list of all records with empty Clock-In Location
    List<AttendanceModel> attendanceForEmptyLocation =
        await widget.service.getAttendanceForEmptyClockOutLocation();

    try {
      for (var attend in attendanceForEmptyLocation) {
        // Create a variable
        var location2 = "";
        bool isInsideAnyGeofence = false;
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockOutLatitude!, attend.clockOutLongitude!);
        List<LocationModel> isarLocations =
        await widget.service.getLocationsByState(placemark[0].administrativeArea);

// Convert Isar locations to GeofenceModel
        List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
          name: location.locationName!, // Use 'locationName'
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0,
          radius: location.radius?.toDouble() ?? 0.0,
        )).toList();

        print("Officessss == $offices");

        isInsideAnyGeofence = false;
        for (GeofenceModel office in offices) {
          double distance = GeoUtils.haversine(
              attend.clockOutLatitude!, attend.clockOutLongitude!, office.latitude, office.longitude);
          if (distance <= office.radius) {
            print('Entered office: ${office.name}');

            location2 = office.name;
            isInsideAnyGeofence = true;
            break;
          }
        }

        if (!isInsideAnyGeofence) {
          List<Placemark> placemark = await placemarkFromCoordinates(
              attend.clockOutLatitude!, attend.clockOutLongitude!);

          location2 =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

          print("Location from map === $location2");
        }

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

  Future<void> _updateEmptyLocationForTwelve() async {

    //First, query the list of all records with empty Clock-In Location
    List<TrackLocationModel> attendanceForEmptyLocationFor12 =
    await widget.service.getAttendanceForEmptyLocationFor12();

    try {
      for (var attend in attendanceForEmptyLocationFor12) {
        // Create a variable
        var location2 = "";
        bool isInsideAnyGeofence = false;
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.latitude!, attend.longitude!);


        List<LocationModel> isarLocations =
        await widget.service.getLocationsByState(placemark[0].administrativeArea);

        // Convert Isar locations to GeofenceModel
        List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
          name: location.locationName!, // Use 'locationName'
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0,
          radius: location.radius?.toDouble() ?? 0.0,
        )).toList();

        print("Officessss == $offices");

        isInsideAnyGeofence = false;
        for (GeofenceModel office in offices) {
          double distance = GeoUtils.haversine(
              attend.latitude!, attend.longitude!, office.latitude, office.longitude);
          if (distance <= office.radius) {
            print('Entered office: ${office.name}');

            location2 = office.name;
            isInsideAnyGeofence = true;
            break;
          }
        }

        if (!isInsideAnyGeofence) {
          List<Placemark> placemark = await placemarkFromCoordinates(
              attend.latitude!, attend.longitude!);

          location2 =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

          print("Location from map === $location2");
        }

        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude


        //log("ClockOutPlacemarker = $location");

        //Update all missing Clock In location
        await widget.service.updateEmptyLocationFor12(
            attend.id, TrackLocationModel(), location2);
        //print(attend.clockInLatitude);
      }
    } catch (e) {
      log(e.toString());
    }

    //Iterate through each queried loop
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
    String comments1,
  ) async {
    final user = User(
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
        noOfHours: noOfHours1,
        comments :comments1
    );
    final id = await AttendanceGSheetsApi.getRowCount() + 1;
    final newUser = user.copy(id: id);
    await AttendanceGSheetsApi.insert([newUser.toJson()]);
    log("newUser ID ===== $newUser");
  }


  Future<void> checkForAppVersion() async {
    final firestore = FirebaseFirestore.instance;
    try {
      List<AppVersionModel> getAppVersion =
      await widget.service.getAppVersion();

      List<LastUpdateDateModel> getlastUpdateDate =
      await widget.service.getLastUpdateDate();

      List<BioModel> getAttendanceForBio =
      await widget.service.getBioInfoWithUserBio();

      DateTime currentDate = DateTime.now();
      log("getAppVersion[0].appVersion== ${getAppVersion[0].appVersion}");
      print("getAppVersion[0].appVersion== ${getAppVersion[0].appVersion}");

        if (getAppVersion[0].checkDate == null ||
            currentDate.difference(getAppVersion[0].checkDate!).inDays > 3) {



          QuerySnapshot snap = await firestore
              .collection("Staff")
              .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
              .get();


          final lastAppVersionDoc = await firestore
              .collection('AppVersion')
              .doc('AppVersion')
              .get();

          final lastUpdateDateDoc = await firestore
              .collection('LastUpdateDate')
              .doc('LastUpdateDate')
              .get();

          final lastUpdateDatebio = await firestore
              .collection('Staff')
              .doc(snap.docs[0].id)
              .get();



          if (lastAppVersionDoc.exists) {
            // Get the data from the document
            final data = lastAppVersionDoc.data();


            if (data != null && data.containsKey('appVersionDate')) {
              // Safely extract the timestamp and convert to DateTime
              final timestamp = data['appVersionDate'] as Timestamp;
              final appVersionDate = timestamp.toDate();
              final versionNumber = data['appVersion'];
              DateTime newappVersionDate = appVersionDate.add(const Duration(days: 16));

              print("appVersionDate ====$appVersionDate");
              print("versionNumber ====$versionNumber");

              if (getAppVersion[0].appVersion != versionNumber
                  // &&
                  // !isAppCheckShown
              ) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  // Prevent dismissing by tapping outside
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Update Available'),
                      content: Text(
                          'You are using an older version of the app (${getAppVersion[0]
                              .appVersion}). Please update to the latest version ($versionNumber), updated on ${DateFormat('MMMM dd, yyyy').format(appVersionDate)}. Kindly Note that you would be logged out on ${DateFormat('MMMM dd, yyyy').format(newappVersionDate)} if you do not upgrade to the latest version ($versionNumber)'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // TODO: Add logic to redirect to app store/update mechanism
                            await IsarService().updateAppVersion(
                                1, AppVersionModel(), DateTime.now(),false);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
                //IsarService().updateAppVersion(1,AppVersionModel(),DateTime.now());
                setState(() {
                  isAppCheckShown == true;
                });
              }
              print("Last appVersionDate saved: $appVersionDate");
            } else {
              print("Document does not contain 'appVersionDate' field.");
            }
          } else {
            print("Document 'appVersionDate' not found.");
          }

          if (lastUpdateDateDoc.exists) {
            // Get the data from the document
            final data = lastUpdateDateDoc.data();


            if (data != null && data.containsKey('LastUpdateDate')) {
              // Safely extract the timestamp and convert to DateTime
              final timestamp = data['LastUpdateDate'] as Timestamp;
              final LastUpdateDate = timestamp.toDate();

              print("appVersionDate ====$LastUpdateDate");

              if (LastUpdateDate.isAfter(
                  getlastUpdateDate[0].lastUpdateDate!) || DateFormat('dd/MM/yyyy').format(LastUpdateDate) == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
                Fluttertoast.showToast(
                  msg: "Updating Local Database!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );



                await IsarService().cleanLocationCollection().then((
                    value) async {
                  await IsarService().cleanStateCollection();
                  await IsarService().cleanDepartmentCollection();
                  await IsarService().cleanDesignationCollection();
                  //await IsarService().cleanAppVersionCollection();
                  await IsarService().cleanReasonsForDayOffCollection();
                  await IsarService().cleanStaffCategoryCollection();
                  await IsarService().cleanLastUpdateDateCollection();
                  await IsarService().cleanProjectCollection();
                  await IsarService().cleanSupervisorCollection();
                }).then((value) async {
                  await _insertSuperUser(
                      IsarService()); // Pass service to _insertSuperUser
                  //await _insertVersion(); // Pass service to _autoFirebaseDBUpdate
                }).then((value) async {
                  await fetchDataAndInsertIntoIsar(
                      IsarService()); // Pass service to fetchDataAndInsertIntoIsar
                  await fetchDepartmentAndDesignationAndInsertIntoIsar(
                      IsarService());
                  await fetchStaffCategoryAndInsertIntoIsar(IsarService());
                  await fetchReasonsForDaysOffAndInsertIntoIsar(IsarService());
                  await fetchLastUpdateDateAndInsertIntoIsar(IsarService());
                  await fetchProjectAndInsertIntoIsar(IsarService());
                  await fetchAppVersionAndInsertIntoIsar(IsarService());
                  fetchSupervisorAndInsertIntoIsar(IsarService());
                });
                Fluttertoast.showToast(
                  msg: "Updating Local Database Completed!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }else{
                Fluttertoast.showToast(
                  msg: "No Recent updates..",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
              // print("Last appVersionDate saved: $appVersionDate");
            } else {
              print("Document does not contain 'LastUpdateDate' field.");
            }
          } else {
            print("Document 'LastUpdateDate' not found.");
          }

          if (lastUpdateDatebio.exists) {
            // Get the data from the document
            final data = lastUpdateDatebio.data();


            if (data != null && data.containsKey('lastUpdateDate')) {
              // Safely extract the timestamp and convert to DateTime
              final timestamp = data['lastUpdateDate'] as Timestamp;
              final isRemoteDelete = data['isRemoteDelete'];
              final LastUpdateDate = timestamp.toDate();


              if (LastUpdateDate.isAfter(getlastUpdateDate[0].lastUpdateDate!) || DateFormat('dd/MM/yyyy').format(LastUpdateDate) == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
                Fluttertoast.showToast(
                  msg: "Updating Local Database!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                await IsarService().cleanLocationCollection().then((_) async {
                  await IsarService().cleanStateCollection().then((_) async {
                    await IsarService().cleanStaffCategoryCollection().then((_) async {
                      await IsarService().cleanReasonsForDayOffCollection().then((_) async {
                        await IsarService().cleanDesignationCollection().then((_) async {
                          await IsarService().cleanDepartmentCollection().then((_) async {
                            await IsarService().cleanLastUpdateDateCollection().then((_) async {
                              await IsarService().cleanProjectCollection().then((_) async {
                                await IsarService().cleanSupervisorCollection().then((_) async {
                                  fetchDataAndInsertIntoIsar(IsarService());
                                  fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService());
                                  fetchSupervisorAndInsertIntoIsar(IsarService());
                                  fetchReasonsForDaysOffAndInsertIntoIsar(IsarService());
                                  fetchStaffCategoryAndInsertIntoIsar(IsarService());
                                  await fetchLastUpdateDateAndInsertIntoIsar(IsarService());
                                  await fetchProjectAndInsertIntoIsar(IsarService());
                                  await fetchAppVersionAndInsertIntoIsar(IsarService());
                                  Fluttertoast.showToast(
                                    msg: "Updates on Database Completed",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.black54,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );

                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
                Fluttertoast.showToast(
                  msg: "Updating Local Database Completed!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
              else{
                Fluttertoast.showToast(
                  msg: "No Recent updates..",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
              // Remote Delete once there is internet);
              if(isRemoteDelete == true){
                Fluttertoast.showToast(
                  msg: "Clearing Database..",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                await IsarService().cleanDB();
              }
            } else {
              print("Document does not contain 'lastUpdateDate' field.");
            }
          } else {
            print("Document 'LastUpdateDate' not found.");
          }


        }




    } catch (e) {
      Fluttertoast.showToast(
        msg: "AppVersion Check Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> checkForAppVersion1() async {
    final firestore = FirebaseFirestore.instance;
    try {
      List<AppVersionModel> getAppVersion =
      await widget.service.getAppVersion();



      List<BioModel> getAttendanceForBio =
      await widget.service.getBioInfoWithUserBio();

      // QuerySnapshot snap = await firestore
      //     .collection("Staff")
      //     .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
      //     .get();



      final lastAppVersionDoc = await firestore
          .collection('AppVersion')
          .doc('AppVersion')
          .get();

      if (lastAppVersionDoc.exists) {
        // Get the data from the document
        final data = lastAppVersionDoc.data();

        if (data != null ) {

          final versionNumber = data['appVersion'];

          print("versionNumber ====$versionNumber");

          if (getAppVersion[0].appVersion != versionNumber) {
            showDialog(
              context: context,
              barrierDismissible: false,
              // Prevent dismissing by tapping outside
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Update Available'),
                  content: Text(
                      'You are using an older version of the app (${getAppVersion[0]
                          .appVersion}). Please update to the latest version ($versionNumber). Kindly Note that you would be logged out after 15 days if you do not upgrade to the latest version ($versionNumber)'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        // TODO: Add logic to redirect to app store/update mechanism
                        await IsarService().updateAppVersion(
                            1, AppVersionModel(), DateTime.now(),false);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
            //IsarService().updateAppVersion(1,AppVersionModel(),DateTime.now());
            // setState(() {
            //   isAppCheckShown == true;
            // });
          }

        } else {
          print("Document does not contain 'appVersionDate' field.");
        }


      }



    } catch (e) {
      Fluttertoast.showToast(
        msg: "AppVersion Check Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> fetchDataAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final locationCollection = await firestore.collection('Location').get();

    for (final stateDoc in locationCollection.docs) {
      final state = stateDoc.id;
      //print("stateSnap====${state}");
      final stateSave = StateModel()..stateName = state;

      service.saveState(stateSave);

      final lgaCollectionRef = await firestore
          .collection('Location')
          .doc(state)
          .collection(state)
          .get();

      for (final lgaDoc in lgaCollectionRef.docs) {
        final lga = lgaDoc.id;
        // print("lgaSnap====${lga}");
        final data = lgaDoc.data();
        //print("data====${data}");

        final locationSave = LocationModel()
          ..state = state
          ..locationName = data['LocationName']
          ..latitude = double.parse(data['Latitude'].toString())
          ..longitude = double.parse(data['Longitude'].toString())
          ..category =  data['category']
          ..radius = double.parse(data['Radius'].toString());

        service.saveLocation(locationSave);
      }
    }
  }

  Future<void> _insertSuperUser(IsarService service) async {
    final bioInfoForSuperUser = await service.getBioInfoForSuperUser();

    if (bioInfoForSuperUser.isEmpty) {
      final bioData = BioModel()
        ..emailAddress = emailAddressConstant
        ..password = passwordConstant
        ..role = roleConstant
        ..department = departmentConstant
        ..designation = designationConstant
        ..firstName = firstNameConstant
        ..lastName = lastNameConstant
        ..location = locationConstant
        ..mobile = mobileConstant
        ..project = projectConstant
        ..staffCategory = staffCategoryConstant
        ..state = stateConstant
        ..firebaseAuthId = firebaseAuthIdConstant
        ..isSynced = isSyncedConstant
        ..supervisor = supervisorConstant
        ..supervisorEmail = supervisorEmailConstant;

      await service.saveBioData(bioData);
    }
  }

  Future<void> _autoFirebaseDBUpdate(IsarService service, String fireBaseIdNew) async {
    final allAttendance = await service.getAllAttendance();
    if (allAttendance.isEmpty) {
      await IsarService().removeAllAttendance(AttendanceModel());
      final CollectionReference snap3 = FirebaseFirestore.instance
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
          ..comments = attendanceHistory.comments
          ..month = attendanceHistory.month

        ;

        service.saveAttendance(attendnce);
      }
      //print("FirebaseID ====$firebaseAuthId");
      Fluttertoast.showToast(
          msg: "Authenticating account..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final designationCollection = await firestore.collection('Designation').get();

    for (final departmentDoc in designationCollection.docs) {
      final department = departmentDoc.id;
      //print("stateSnap====${state}");
      final departmentSave = DepartmentModel()..departmentName = department;

      service.saveDepartment(departmentSave);

      final designationCollectionRef = await firestore
          .collection('Designation')
          .doc(department)
          .collection(department)
          .get();

      for (final designationDoc in designationCollectionRef.docs) {
        final designation = designationDoc.id;
        // print("lgaSnap====${lga}");
        final data = designationDoc.data();
        //print("data====${data}");

        final designationSave = DesignationModel()
          ..departmentName = department
          ..designationName = data['designationName']
          ..category = data['category']

        ;

        service.saveDesignation(designationSave);
      }
    }
  }

  Future<void> fetchProjectAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final projectCollection = await firestore.collection('Project').get();

    for (final projectDoc in projectCollection.docs) {
      final project = projectDoc.id;
      //print("stateSnap====${state}");
      final projectSave = ProjectModel()..project = project;

      service.saveProject(projectSave);


    }
  }

  Future<void> fetchLastUpdateDateAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final lastUpdateDateDoc = await firestore
          .collection('LastUpdateDate')
          .doc("LastUpdateDate")
          .get();

      if (lastUpdateDateDoc.exists) {
        // Get the data from the document
        final data = lastUpdateDateDoc.data();

        if (data != null && data.containsKey('LastUpdateDate')) {
          // Safely extract the timestamp and convert to DateTime
          final timestamp = data['LastUpdateDate'] as Timestamp;
          final lastUpdate = timestamp.toDate();

          print("LastUpdateDate ====$lastUpdate");

          final lastUpdateSave = LastUpdateDateModel()
            ..lastUpdateDate = lastUpdate;

          await service.saveLastUpdateDate(lastUpdateSave);
          // await service.updateAppVersion(1,AppVersionModel(),lastUpdate);
          print("Last update date saved: $lastUpdate");
        } else {
          print("Document does not contain 'lastUpdate' field.");
        }
      } else {
        print("Document 'LastUpdateDate' not found.");
      }
    } catch (e) {
      print("Error fetching last update date: $e");
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }
  Future<void> _insertVersion() async {
    final getAppVersion = await IsarService().getAppVersionInfo();

    if (getAppVersion.isEmpty) {
      final appVersion = AppVersionModel()
        ..appVersion = appVersionConstant;

      await IsarService().saveAppVersionData(appVersion);
    }
  }

  void fetchSupervisorAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final supervisorCollection = await firestore.collection('Supervisors').get();

    for (final stateDoc in supervisorCollection.docs) {
      final state = stateDoc.id;

      final supervisorCollectionRef = await firestore
          .collection('Supervisors')
          .doc(state)
          .collection(state)
          .get();

      for (final supervisorDoc in supervisorCollectionRef.docs) {
        final supervisor = supervisorDoc.id;
        final data = supervisorDoc.data();

        final supervisorSave = SupervisorModel()
          ..department = data['department']
          ..email = data['email']
          ..state = state
          ..supervisor = data['supervisor']

        ;

        service.saveSupervisor(supervisorSave);
      }
    }
  }

  Future<void> fetchAppVersionAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final getAppVersion = await service.getAppVersionInfo();

    try {
      final lastUpdateDateDoc = await firestore
          .collection('AppVersion')
      // .doc(getAppVersion[0].appVersion)
          .doc('AppVersion')
          .get();

      if (lastUpdateDateDoc.exists) {
        // Get the data from the document
        final data = lastUpdateDateDoc.data();


        if (data != null && data.containsKey('appVersionDate')) {
          // Safely extract the timestamp and convert to DateTime
          final timestamp = data['appVersionDate'] as Timestamp;
          final appVersionDate = timestamp.toDate();
          final versionNumber = data['appVersion'];

          print("appVersionDate ====$appVersionDate");
          print("versionNumber ====$versionNumber");

          if(getAppVersion[0].appVersion == versionNumber){
            await service.updateAppVersion1(1,AppVersionModel(),appVersionDate,DateTime.now(),true);
          }else{
            await service.updateAppVersion2(1,AppVersionModel(),DateTime.now(),false);
          }
          print("Last appVersionDate saved: $appVersionDate");
        } else {
          print("Document does not contain 'appVersionDate' field.");
        }
      } else {
        print("Document 'appVersionDate' not found.");
      }
    } catch (e) {
      print("Error fetching last appVersionDate: $e");
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  Future<void> fetchReasonsForDaysOffAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final reasonsForDaysOffCollection = await firestore.collection('ReasonsForDaysOff').get();

    for (final reasonsForDaysOffDoc in reasonsForDaysOffCollection.docs) {
      final reasonsForDaysOff = reasonsForDaysOffDoc.id;
      //print("stateSnap====${state}");
      final reasonsForDaysOffSave = ReasonForDaysOffModel()..reasonForDaysOff = reasonsForDaysOff;

      service.saveReasonForDaysOff(reasonsForDaysOffSave);

    }
  }

  Future<void> fetchStaffCategoryAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final staffCategoryCollection = await firestore.collection('StaffCategory').get();

    for (final staffCategoryDoc in staffCategoryCollection.docs) {
      final staffCategory = staffCategoryDoc.id;
      //print("stateSnap====${state}");
      final staffCategorySave = StaffCategoryModel()..staffCategory = staffCategory;

      service.saveStaffCategory(staffCategorySave);

    }
  }

// This Method updates all attendance that has a clock-out made. This is necessary for data validation and to ensure that folks sign-out appropraitely
  syncCompleteData() async {
    try {
      // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before chahing the sync status on Mobile App to "Synced"
      //Query the firebase and get the records having updated records

      List<BioModel> getAttendanceForBio =
      await widget.service.getBioInfoWithUserBio();




      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
          .get();

      List<BioModel> getBioForPartialUnSynced =
      await IsarService().getBioForId();



      List<AttendanceModel> getAttendanceForPartialUnSynced =
          await widget.service.getAttendanceForPartialUnSynced();

      List<TrackLocationModel> getTracklocationForPartialUnSynced =
      await widget.service.getTracklocationForPartialUnSynced();

      for (var unSyncedTrackLocation in getTracklocationForPartialUnSynced){
        log("Synching Tracked location by 12pm");
        await FirebaseFirestore.instance
            .collection("Staff")
            .doc(snap.docs[0].id)
            .collection("LocationBy12PM")
            .doc(DateFormat('dd-MMMM-yyyy').format(unSyncedTrackLocation.timestamp!))
            .set({
          "latitudeBy12": unSyncedTrackLocation.latitude,
          'longitudeBy12': unSyncedTrackLocation.longitude,
          'Date': unSyncedTrackLocation.timestamp,
          'locationName': unSyncedTrackLocation.locationName,
        }).then((value){
          widget.service.updateSyncStatusForTrackLocationBy12(
              unSyncedTrackLocation.id, TrackLocationModel(), true);
        });
      }

      await checkForAppVersion1().then((_) async {

        await _updateEmptyClockInAndOutLocation().then((value) async => {
          //Iterate through each queried loop
          for (var unSyncedAttend in getAttendanceForPartialUnSynced)
            {

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
                'comments':unSyncedAttend.comments
              }).then((value) async {
                Fluttertoast.showToast(
                  msg: "Syncing to Server...",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                widget.service.updateSyncStatus(
                    unSyncedAttend.id, AttendanceModel(), true); // Update Isar


              })
                  .catchError((error) {
                Fluttertoast.showToast(
                  msg: "Server Write Error: ${error.toString()}",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              })
              // ----------------
              // await _updateGoogleSheet(
              //         state,
              //         project,
              //         firstName,
              //         lastName,
              //         designation,
              //         department,
              //         location,
              //         staffCategory,
              //         mobile,
              //         unSyncedAttend.date.toString(),
              //         emailAddress,
              //         unSyncedAttend.clockIn.toString(),
              //         unSyncedAttend.clockInLatitude.toString(),
              //         unSyncedAttend.clockInLongitude.toString(),
              //         unSyncedAttend.clockInLocation.toString(),
              //         unSyncedAttend.clockOut.toString(),
              //         unSyncedAttend.clockOutLatitude.toString(),
              //         unSyncedAttend.clockOutLongitude.toString(),
              //         unSyncedAttend.clockOutLocation.toString(),
              //         unSyncedAttend.durationWorked.toString(),
              //         unSyncedAttend.noOfHours.toString(),
              //     unSyncedAttend.comments.toString()
              // )
              //      .then((value) async {
              //
              // })

              // ---------------
            }
        });
      });



      //Iterate through each queried loop
      for (var unSyncedBio in getBioForPartialUnSynced)
      {

        await FirebaseFirestore.instance
            .collection("Staff")
            .doc(snap.docs[0].id)
            .set({
          "department": unSyncedBio.department,
          'designation': unSyncedBio.designation,
          'emailAddress': unSyncedBio.emailAddress,
          'firstName': unSyncedBio.firstName,
          'id': snap.docs[0].id,
          'lastName': unSyncedBio.lastName,
          'location': unSyncedBio.location,
          'mobile': unSyncedBio.mobile,
          'project': unSyncedBio.project,
          'staffCategory': unSyncedBio.staffCategory,
          'state': unSyncedBio.state,
          'supervisor': unSyncedBio.supervisor,
          'supervisorEmail': unSyncedBio.supervisorEmail,
          'version':appVersionConstant,
          'isRemoteDelete':false,
          'isRemoteUpdate':false,
          'lastUpdateDate':DateTime.now(),
        }).then((value) {
          Fluttertoast.showToast(
            msg: "Syncing BioData to Server...",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          IsarService().updateSyncStatusForBio(
              unSyncedBio.id, BioModel(), true).then((_){
            Fluttertoast.showToast(
              msg: "Syncing Completed...",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }); // Update Isar



        })
            .catchError((error) {
          Fluttertoast.showToast(
            msg: "Server Write Error: ${error.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });

      }




    } catch (e) {
      // The catch block executes incase firebase database encounters an error thereby only saving the data in the google sheet for the analytics before chahing the sync status on Mobile App to "Synced"
      log("Sync Error Skipping firebase DB = ${e.toString()}");
      // List<AttendanceModel> getAttendanceForPartialUnSynced =
      //     await widget.service.getAttendanceForPartialUnSynced();
      Fluttertoast.showToast(
        msg: "Sync Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );


      //await _updateEmptyClockInAndOutLocation().then((value) async => {
      //Iterate through each queried loop
      // for (var unSyncedAttend in getAttendanceForPartialUnSynced) {
      //   await _updateGoogleSheet(
      //           state,
      //           project,
      //           firstName,
      //           lastName,
      //           designation,
      //           department,
      //           location,
      //           staffCategory,
      //           mobile,
      //           unSyncedAttend.date.toString(),
      //           emailAddress,
      //           unSyncedAttend.clockIn.toString(),
      //           unSyncedAttend.clockInLatitude.toString(),
      //           unSyncedAttend.clockInLongitude.toString(),
      //           unSyncedAttend.clockInLocation.toString(),
      //           unSyncedAttend.clockOut.toString(),
      //           unSyncedAttend.clockOutLatitude.toString(),
      //           unSyncedAttend.clockOutLongitude.toString(),
      //           unSyncedAttend.clockOutLocation.toString(),
      //           unSyncedAttend.durationWorked.toString(),
      //           unSyncedAttend.noOfHours.toString(),
      //           unSyncedAttend.comments.toString(),
      //   )
      //       .then((value) async {
      //     widget.service
      //         .updateSyncStatus(unSyncedAttend.id, AttendanceModel(), true);
      //   });
      // }
      // });
    }
  }



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
      await _updateEmptyClockInAndOutLocation().then((value)async{
       await  _updateEmptyLocationForTwelve();
      }).then((value) async {
        await syncCompleteData();
        await checkForAppVersion1();
      })
      .then((value) {
        Fluttertoast.showToast(
            msg: "Synching Completed",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      });
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
