import 'dart:async';
import 'dart:developer';
import 'package:attendanceapp/Pages/auth_check.dart';
import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendance_gsheet_model.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import http package for network requests

class SplashScreen extends StatefulWidget {
  final IsarService service;
  const SplashScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  RxDouble progress = 0.0.obs;
  double screenHeight = 0;
  double screenWidth = 0;
  bool _hasInternet = true; // Initial assumption

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet = connectivityResult != ConnectivityResult.none;
    });
    if (_hasInternet) {
      _init();
    } else {
      // No internet, proceed to insert the super user (it doesn't require internet)
      _insertSuperUser().then((_){
        progress.value = 1.0;
        Timer(const Duration(seconds: 1), () => Get.off(() => AuthCheck(service: widget.service)));
        Fluttertoast.showToast(
          msg:
          "Inserted Super User..",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      });


    }
  }

  Future<void> _init() async {
    _insertSuperUser().then((_) {
      progress.value = 0.5;
      try {
        _syncCompleteData().then((_) {
          progress.value = 1.0;
          Timer(const Duration(seconds: 1), () => Get.off(() => AuthCheck(service: widget.service)));
        });
      } catch (e) {
        // Error handling for Firebase Authentication
        log("Firebase Authentication Error: ${e.toString()}");
        // You can display a user-friendly error message here
        // ...
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:
      _hasInternet
          ? SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: SizedBox(
                height: screenHeight * 0.4,
                child: Image.asset(
                  "assets/image/caritaslogo1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //SizedBox(height: screenHeight * 0.05),
            SpinKitThreeBounce(
              color: Color(0xffeef444c),
              size: screenHeight * 0.05,
            ),
            SizedBox(height: screenHeight * 0.05),

            Obx(() => SizedBox(
              height: screenHeight * 0.055,
              width: screenWidth * 0.1,
              child: CircularProgressIndicator(
                value: progress.value,
                strokeWidth: 3,
                color: Colors.black12,
              ),
            )),
            SizedBox(height: screenHeight * 0.05),
            Text("Attendance v1.0",
                style: TextStyle(
                    color: const Color.fromARGB(255, 97, 9, 9),
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold))
          ],
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Internet Connection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInternet,
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // This Method updates all attendance that has a clock-out made. This is necessary for data validation and to ensure that folks sign-out appropriately
  Future<void> _syncCompleteData() async {
    try {
      // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before changing the sync status on Mobile App to "Synced"
      //Query the firebase and get the records having updated records
      final bioData = await widget.service.getBioInfoWithFirebaseAuth();
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: bioData?.firebaseAuthId)
          .get();

      List<AttendanceModel> getAttendanceForPartialUnSynced =
      await IsarService().getAttendanceForPartialUnSynced();

      await _updateEmptyClockInAndOutLocation().then((value) async => {
        //Iterate through each queried loop
        for (var unSyncedAttend in getAttendanceForPartialUnSynced)
          {
            await _updateGoogleSheet(
                bioData?.state ?? '',
                bioData?.project ?? '',
                bioData?.firstName ?? '',
                bioData?.lastName ?? '',
                bioData?.designation ?? '',
                bioData?.department ?? '',
                bioData?.location ?? '',
                bioData?.staffCategory ?? '',
                bioData?.mobile ?? '',
                unSyncedAttend.date.toString(),
                bioData?.emailAddress ?? '',
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
              }).then((value) => IsarService().updateSyncStatus(
                  unSyncedAttend.id, AttendanceModel(), true));
            })
          }
      });
    } catch (e) {
      // The catch block executes incase firebase database encounters an error thereby only saving the data in the google sheet for the analytics before chahing the sync status on Mobile App to "Synced"
      log("Sync Error Skipping firebase DB = ${e.toString()}");
      List<AttendanceModel> getAttendanceForPartialUnSynced =
      await IsarService().getAttendanceForPartialUnSynced();

      final bioData = await widget.service.getBioInfoWithFirebaseAuth();

      //await _updateEmptyClockInAndOutLocation().then((value) async => {
      //Iterate through each queried loop
      for (var unSyncedAttend in getAttendanceForPartialUnSynced) {
        await _updateGoogleSheet(
            bioData?.state ?? '',
            bioData?.project ?? '',
            bioData?.firstName ?? '',
            bioData?.lastName ?? '',
            bioData?.designation ?? '',
            bioData?.department ?? '',
            bioData?.location ?? '',
            bioData?.staffCategory ?? '',
            bioData?.mobile ?? '',
            unSyncedAttend.date.toString(),
            bioData?.emailAddress ?? '',
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
          IsarService()
              .updateSyncStatus(unSyncedAttend.id, AttendanceModel(), true);
        });
      }
      // });
    }
  }

  Future<void> _insertSuperUser() async {
    final bioInfoForSuperUser = await widget.service.getBioInfoForSuperUser();

    if (bioInfoForSuperUser.length == 0) {
      final bioData = BioModel()
        ..emailAddress = emailAddress
        ..password = password
        ..role = role
        ..department = department
        ..designation = designation
        ..firstName = firstName
        ..lastName = lastName
        ..location = location
        ..mobile = mobile
        ..project = project
        ..staffCategory = staffCategory
        ..state = state
        ..firebaseAuthId = firebaseAuthId;

      await widget.service.saveBioData(bioData);
    }
  }

  //This method updates all empty Clock-In Location Using the Latitude and Longitude during clock-out
  Future<void> _updateEmptyClockInLocation() async {
    try {
      //First, query the list of all records with empty Clock-In Location
      List<AttendanceModel> attendanceForEmptyLocation =
      await IsarService().getAttendanceForEmptyClockInLocation();

      //Iterate through each queried loop
      for (var attend in attendanceForEmptyLocation) {
        // Create a variable
        //var location = "";
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockInLatitude!, attend.clockInLongitude!);

        //print("ClockInPlacemarker = $placemark");

        //Update all missing Clock In location
        IsarService().updateEmptyClockInLocation(attend.id, AttendanceModel(),
            "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}");
        //print(attend.clockInLatitude);
      }
    } catch (e) {
      log(e.toString());
    }
  }

//This method updates all empty Clock-Out Location Using the Latitude and Longitude during clock-out
  Future<void> _updateEmptyClockOutLocation() async {
    try {
      //First, query the list of all records with empty Clock-In Location
      List<AttendanceModel> attendanceForEmptyLocation =
      await IsarService().getAttendanceForEmptyClockOutLocation();

      //Iterate through each queried loop
      for (var attend in attendanceForEmptyLocation) {
        // Create a variable
        // var location = "";
        //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
        List<Placemark> placemark = await placemarkFromCoordinates(
            attend.clockOutLatitude!, attend.clockOutLongitude!);

        // print("ClockOutPlacemarker = $placemark");

        //Update all missing Clock In location
        IsarService().updateEmptyClockOutLocation(attend.id, AttendanceModel(),
            "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}");
        //print(attend.clockInLatitude);
      }
    } catch (e) {
      log(e.toString());
    }
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



}