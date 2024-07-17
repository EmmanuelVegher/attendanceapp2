import 'dart:async';
import 'dart:developer';
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/Pages/Dashboard/admin_dashboard.dart';
import 'package:attendanceapp/Pages/Dashboard/user_dashboard.dart';
// import 'package:attendanceapp/controllers/clock_attendance_controller.dart';
import 'package:attendanceapp/model/attendance.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/location_services.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/geo_utils.dart';
import 'package:attendanceapp/widgets/header_widget.dart';
import 'package:attendanceapp/widgets/input_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../model/locationmodel.dart';
import '../../widgets/drawer.dart';

class GeofenceModel {
  final String name;
  final double latitude;
  final double longitude;
  final double radius;

  GeofenceModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });
}

class ClockAttendance extends StatelessWidget {
  final IsarService service;

  ClockAttendance(IsarService isarService, {Key? key, required this.service}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final ClockAttendanceController controller =
    Get.put(ClockAttendanceController(service));


    return Scaffold(
      drawer: Obx(
            () => controller.role.value == "User"
            ? drawer(context, service)
            : drawer2(context, service),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1, // 10% of screen height
                child: const HeaderWidget(100, false, Icons.house_rounded),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "NexaLight",
                          fontSize: screenWidth / 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image(
                        image: const AssetImage("./assets/image/ccfn_logo.png"),
                        width: screenWidth / 18,
                        height: screenHeight / 18,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                    () => Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${controller.firstName.value.toString().toUpperCase()} ${controller.lastName.value.toString().toUpperCase()}",
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
             // Obx(
              //      () =>
                        Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Status:",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                      SizedBox(height: 10), // Spacing between status and coordinates
                      Obx(() => Text(
                        "Current Latitude: ${controller.lati.value.toStringAsFixed(6)}, Current Longitude: ${controller.longi.value.toStringAsFixed(6)}",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 23,
                        ),
                      )),
                      SizedBox(height: 10),
                      Obx(() => Text(
                        "Current State: ${controller.administrativeArea.value}",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 23,
                        ),
                      )),
                      SizedBox(height: 10),
                      Obx(() => Text(
                        "Current Location: ${controller.location.value}",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 23,
                        ),
                      )),
                      // You can add your location name widget here, using Obx to make it reactive
                    ],
                  ),
                ),
              //),
              //Card View for ClockIn and ClockOut
              Obx(
                    () => Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 32),
                  height: screenHeight * 0.15, // 15% of screen height
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Clock In",
                              style: TextStyle(
                                fontFamily: "NexaLight",
                                fontSize: screenWidth / 20,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              controller.clockIn.value,
                              style: TextStyle(
                                fontFamily: "NexaBold",
                                fontSize: screenWidth / 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Clock Out",
                              style: TextStyle(
                                fontFamily: "NexaLight",
                                fontSize: screenWidth / 20,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              controller.clockOut.value,
                              style: TextStyle(
                                fontFamily: "NexaBold",
                                fontSize: screenWidth / 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth / 18,
                      fontFamily: "NexaBold",
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat(" MMMM yyyy").format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth / 20,
                          fontFamily: "NexaBold",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat("hh:mm:ss a").format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaLight",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
              Obx(
                    () => controller.clockOut.value == "--/--"
                    ? Column(
                  children: [
                    // Slider for Clocking In/Out
                    Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Builder(
                        builder: (context) {
                          final GlobalKey<SlideActionState> key = GlobalKey();
                          return SlideAction(
                            text: controller.clockIn.value == "--/--"
                                ? "Slide to Clock In"
                                : "Slide to Clock Out",
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth / 20,
                              fontFamily: "NexaLight",
                            ),
                            outerColor: Colors.white,
                            innerColor: Colors.red,
                            key: key,
                            onSubmit: () async {
                              await controller.handleClockInOut(context, key);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    controller.clockIn.value == "--/--"
                        ? MyButton(
                      label: "Out Of Office? CLICK HERE",
                      onTap: () {
                        controller.showBottomSheet(context);
                      },
                    )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 10.0),
                    // Location Status Container
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.black],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Location Status",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth / 20,
                                fontFamily: "NexaBold",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 0.7,
                              height:
                              MediaQuery.of(context).size.height / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Clock-In Location",
                                          style: TextStyle(
                                            fontFamily: "NexaLight",
                                            fontSize: screenWidth / 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                              () => Text(
                                            controller.clockInLocation.value,
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 35,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Clock-Out Location",
                                          style: TextStyle(
                                            fontFamily: "NexaLight",
                                            fontSize: screenWidth / 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Obx(
                                              () => Text(
                                            controller.clockOutLocation.value,
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 35,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(
                        "You have completed this day!!!",
                        style: TextStyle(
                          fontFamily: "NexaLight",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                            () => Text(
                          "Duration Worked: ${controller.durationWorked.value}",
                          style: TextStyle(
                            fontFamily: "NexaLight",
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Location Status Container (For completed day)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.black],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 8.0),
                          child: Column(
                            children: [
                              Text(
                                "Location Status",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth / 20,
                                  fontFamily: "NexaBold",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                width:
                                MediaQuery.of(context).size.width * 0.7,
                                height:
                                MediaQuery.of(context).size.height / 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Clock-In Location",
                                            style: TextStyle(
                                              fontFamily: "NexaLight",
                                              fontSize: screenWidth / 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(
                                                () => Text(
                                              controller.clockInLocation.value,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Clock-Out Location",
                                            style: TextStyle(
                                              fontFamily: "NexaLight",
                                              fontSize: screenWidth / 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Obx(
                                                () => Text(
                                              controller.clockOutLocation.value,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ClockAttendanceController (clock_attendance_controller.dart)
class ClockAttendanceController extends GetxController {
  final IsarService service;

  ClockAttendanceController(this.service) {
    _init();
  }

  RxString clockIn = "--/--".obs;
  RxString clockOut = "--/--".obs;
  RxString durationWorked = "".obs;
  RxString location = "Outside Office Premises".obs;
  RxString clockInLocation = "Outside Office Premises".obs;
  RxString clockOutLocation = "Outside Office Premises".obs;
  RxString role = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString emailAddress = "".obs;
  RxString firebaseAuthId = "".obs;
  RxDouble lati = 0.0.obs;
  RxDouble longi = 0.0.obs;
  RxString administrativeArea = "".obs; // Added for state name
  RxBool isLocationTurnedOn = false.obs;
  Rx<LocationPermission> isLocationPermissionGranted = LocationPermission.denied.obs;
  RxBool isAlertSet = false.obs;
  RxBool isAlertSet2 = false.obs;
  RxBool isInsideAnyGeofence = false.obs;

  String currentDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
  DateTime ntpTime = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "11:59 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _reasons = "";
  int _selectedColor = 0;
  var isDeviceConnected = false;
  List<String> reasonsForDayOff = [
    "Holiday",
    "Annual Leave",
    "Sick Leave",
    "Other Leaves",
    "Absent",
    "Travel",
    "Remote Working"
  ];

  Timer? _locationTimer;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    _locationTimer?.cancel();
    super.onClose();
  }

  void _init() async {
    await _loadNTPTime();
    await _getAttendanceSummary();
    await _getUserDetail();
    await _startLocationService();
    await getLocationStatus();
    await getPermissionStatus();

    // Start the periodic location updates
    _locationTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _startLocationService();
    });
  }

  Future<void> _loadNTPTime() async {
    ntpTime = await NTP.now();
  }

  Future<void> _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    firebaseAuthId.value = userDetail?.firebaseAuthId ?? "";
    firstName.value = userDetail?.firstName ?? "";
    lastName.value = userDetail?.lastName ?? "";
    emailAddress.value = userDetail?.emailAddress ?? "";
    role.value = userDetail?.role ?? "";
  }

  Future<void> _getAttendanceSummary() async {
    try {
      final attendanceLast =
      await service.getLastAttendance(DateFormat('MMMM yyyy').format(DateTime.now()));
      final attendanceResult =
      await service.getAttendanceForDate(DateFormat('dd-MMMM-yyyy').format(DateTime.now()));

      if (attendanceLast?.date == currentDate) {
        clockIn.value = attendanceLast?.clockIn ?? "--/--";
        clockOut.value = attendanceLast?.clockOut ?? "--/--";
        clockInLocation.value = attendanceLast?.clockInLocation ?? "Outside Office Premises";
        clockOutLocation.value = attendanceLast?.clockOutLocation ?? "Outside Office Premises";
        durationWorked.value = attendanceLast?.durationWorked ?? "";
      } else {
        clockIn.value = attendanceResult[0].clockIn ?? "--/--";
        clockOut.value = attendanceResult[0].clockOut ?? "--/--";
        clockInLocation.value = attendanceResult[0].clockInLocation ?? "Outside Office Premises";
        clockOutLocation.value = attendanceResult[0].clockOutLocation ?? "Outside Office Premises";
        durationWorked.value = attendanceResult[0].durationWorked ?? "";
      }
    } catch (e) {
      if (e.toString() ==
          "RangeError (index): Invalid value: Valid value range is empty: 0") {
        log("getAttendance Summary method error ====== Staff Yet to clock in as Last saved date != Current Date");
      } else {
        log(e.toString());
      }
    }
  }




  // Start Location Service
  Future<void> _startLocationService() async {
    LocationService locationService = LocationService();
    Position? position = await locationService.getCurrentPosition();

    if (position != null) {
      UserModel.long = position.longitude;
      lati.value = position.latitude;
      longi.value = position.longitude;
      UserModel.lat = position.latitude;

      // Get placemark (address details)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        location.value =
        "${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
        administrativeArea.value = placemark.administrativeArea ?? ""; // Update state name
      } else {
        location.value = "Location not found";
        administrativeArea.value = "";
      }


      if (administrativeArea.value != '' && administrativeArea.value != null) {
        // Query Isar database for locations with the same administrative area
        List<LocationModel> isarLocations =
        await service.getLocationsByState(administrativeArea.value);


        // Convert Isar locations to GeofenceModel
        List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
          name: location.locationName!, // Use 'locationName'
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0,
          radius: location.radius?.toDouble() ?? 0.0,
        )).toList();

        print("Ofiicessss == ${offices}");

        isInsideAnyGeofence.value = false;
        for (GeofenceModel office in offices) {
          double distance = GeoUtils.haversine(
              position.latitude, position.longitude, office.latitude, office.longitude);
          if (distance <= office.radius) {
            print('Entered office: ${office.name}');
            location.value = office.name;
            isInsideAnyGeofence.value = true;
            break;
          }
        }

        if (!isInsideAnyGeofence.value) {
          List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

          location.value =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

          print("Location from map === ${location.value}");
        }





      }
      else {

        List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);


        location.value =
        "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

        print("Unable to get administrative area. Using default location.");
      }

    }
  }



  Future<void> getLocationStatus() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationTurnedOn.value = isLocationEnabled;

    if (!isLocationTurnedOn.value && !isAlertSet.value) {
      showDialogBox();
      isAlertSet.value = true;
    }
  }

  Future<void> getPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    isLocationPermissionGranted.value = permission;

    // Check if permission is denied
    if (isLocationPermissionGranted.value == LocationPermission.denied ||
        isLocationPermissionGranted.value == LocationPermission.deniedForever) {
      showDialogBox2();
      isAlertSet2.value = true;
    }
  }

  Future<void> handleClockInOut(BuildContext context, GlobalKey<SlideActionState> key) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      Fluttertoast.showToast(
        msg: "No Internet Connectivity Detected. Please try again later!!",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      key.currentState!.reset();
      return;
    }

    try {
      final lastAttend = await service.getLastAttendance(DateFormat("MMMM yyyy").format(DateTime.now()).toString());

      if (lastAttend?.date != currentDate) {
        // Clock In
        await _clockIn(isDeviceConnected);
      } else if (lastAttend?.date == currentDate) {
        // Clock Out
        List<AttendanceModel> attendanceResult = await service.getAttendanceForDate(DateFormat('dd-MMMM-yyyy').format(ntpTime));
        final bioInfoForUser = await service.getBioInfoWithFirebaseAuth();
        await _clockOut(attendanceResult[0].id, bioInfoForUser, attendanceResult);
      } else if (lastAttend?.date == null) {
        // No previous record, clock in
        await _clockIn(isDeviceConnected);
      }
    } catch (e) {
      log("Attendance clockInandOut Error ====== ${e.toString()}");
      await _clockIn(isDeviceConnected);
    }

    key.currentState!.reset();
  }

  Future<void> _clockIn(bool isDeviceConnected) async {
    final time = isDeviceConnected
        ? DateTime.now().add(Duration(milliseconds: await NTP.getNtpOffset(localTime: DateTime.now(), lookUpAddress: "time.google.com")))
        : ntpTime;

    final attendance = AttendanceModel()
      ..clockIn = DateFormat('hh:mm a').format(time)
      ..date = DateFormat('dd-MMMM-yyyy').format(time)
      ..clockInLatitude = UserModel.lat
      ..clockInLocation = location.value
      ..clockInLongitude = UserModel.long
      ..clockOut = "--/--"
      ..clockOutLatitude = 0.0
      ..clockOutLocation = null
      ..clockOutLongitude = 0.0
      ..isSynced = false
      ..voided = false
      ..isUpdated = false
      ..durationWorked = "0 hours 0 minutes"
      ..noOfHours = 0.0
      ..offDay = false
      ..month = DateFormat('MMMM yyyy').format(time);

    await service.saveAttendance(attendance);
    Fluttertoast.showToast(
      msg: "Clocking-In..",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black54,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Get.off(() => AttendanceHomeScreen(service: IsarService()));
  }

  Future<void> _clockOut(int attendanceId, BioModel? bioInfoForUser, List<AttendanceModel> attendanceResult) async {
    await service.updateAttendance(
      attendanceId,
      AttendanceModel(),
      DateFormat('hh:mm a').format(ntpTime),
      UserModel.lat,
      UserModel.long,
      location.value,
      false,
      true,
      _diffClockInOut(attendanceResult[0].clockIn.toString(), DateFormat('h:mm a').format(ntpTime)),
      _diffHoursWorked(attendanceResult[0].clockIn.toString(), DateFormat('h:mm a').format(ntpTime)),
    );
    Fluttertoast.showToast(
      msg: "Clocking-Out..",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black54,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Get.off(() => bioInfoForUser!.role == "User"
        ? UserDashBoard(service: service)
        : AdminDashBoard(service: service));
  }

  showDialogBox() => showCupertinoDialog<String>(
    context: Get.context!, // Retrieve BuildContext from Get
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("Location Turned Off"),
      content: const Text("Please turn on your location to ClockIn and Out"),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Get.back(); // You can use Get.back() here
            isAlertSet.value = false;
            isLocationTurnedOn.value =
            await LocationService().getLocationStatus();
            if (!isLocationTurnedOn.value) {
              showDialogBox();
            }
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );

  // showDialogBox2(BuildContext context) => showCupertinoDialog<String>( // Add BuildContext parameter
  //   context: context, // Pass the same context
  //   builder: (BuildContext builderContext) => CupertinoAlertDialog( // You can use builderContext here
  //     // ...
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () async {
  //           Get.back();
  //           isAlertSet2.value = false;
  //           isLocationPermissionGranted.value = await LocationService().getPermissionStatus();
  //           if (isLocationPermissionGranted.value == LocationPermission.denied ||
  //               isLocationPermissionGranted.value == LocationPermission.deniedForever) {
  //             showDialogBox2(context); // Pass the context here
  //           }
  //         },
  //         child: const Text("OK"),
  //       ),
  //     ],
  //   ),
  // );

  showDialogBox2() => showCupertinoDialog<String>(
    context: Get.context!, // Retrieve BuildContext from Get
    builder: (BuildContext builderContext) => CupertinoAlertDialog(
      // ... your AlertDialog content
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Get.back(); // You can use Get.back() here
            isAlertSet2.value = false;
            isLocationPermissionGranted.value =
            await LocationService().getPermissionStatus();
            if (isLocationPermissionGranted.value == LocationPermission.denied ||
                isLocationPermissionGranted.value ==
                    LocationPermission.deniedForever) {
              showDialogBox2(); // Use builderContext for the recursive call
            }
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );


  String _diffClockInOut(String clockInTime, String clockOutTime) {
    var format = DateFormat("h:mm a");
    var clockTimeIn = format.parse(clockInTime);
    var clockTimeOut = format.parse(clockOutTime);

    if (clockTimeIn.isAfter(clockTimeOut)) {
      clockTimeOut = clockTimeOut.add(const Duration(days: 1));
    }

    Duration diff = clockTimeOut.difference(clockTimeIn);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    log('$hours hours $minutes minute');
    return ('$hours hour(s) $minutes minute(s)');
  }

  double _diffHoursWorked(String clockInTime, String clockOutTime) {
    var format = DateFormat("h:mm a");
    var clockTimeIn = format.parse(clockInTime);
    var clockTimeOut = format.parse(clockOutTime);
    if (clockTimeIn.isAfter(clockTimeOut)) {
      clockTimeOut = clockTimeOut.add(const Duration(days: 1));
    }

    Duration diff = clockTimeOut.difference(clockTimeIn);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final minCal = minutes / 60;
    String inStringMin = minCal.toStringAsFixed(3); // '2.35'
    double roundedMinDouble = double.parse(inStringMin); //
    final totalTime = hours + roundedMinDouble;

    log('$hours hours $minutes minutes');
    return totalTime;
  }

  void showBottomSheet(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Get.bottomSheet(
        StatefulBuilder(
        builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: 300,
          height: MediaQuery.of(context).size.height * 0.65,
          color: Colors.white54,
          alignment: Alignment.center,
          child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Out Of Office?",
    style: TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontSize: screenWidth / 15,
    ),
    ),
    MyInputField(
    title: "Date",
    hint: DateFormat("dd/MM/yyyy").format(_selectedDate),
    widget: IconButton(
    onPressed: () {
    _getDateFromUser(setState);
    },
    icon: const Icon(
    Icons.calendar_today_outlined,
    color: Colors.grey,
    ),
    ),
    ),
    MyInputField(
    title: "Reasons For Day off",
    hint: _reasons,
    widget: DropdownButton<String>(
    icon: const Icon(
    Icons.keyboard_arrow_down,
    color: Colors.grey,
    ),
    iconSize: 32,
    elevation: 4,
    style: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: screenWidth / 25,
    fontFamily: "NexaBold",
    ),
    underline: Container(height: 0),
    items: reasonsForDayOff.map((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(
    value,
    style: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: screenWidth / 25,
    fontFamily: "NexaBold",
    ),
    ),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _reasons = newValue!;
    });
    },
    ),
    ),
    Row(
    children: [
    Expanded(
    child: MyInputField(
    title: "Start Time",
    hint: _startTime,
    widget: IconButton(
    onPressed: () {
    _getTimeFromUser(isStartTime: true, setState: setState);
    },
    icon: const Icon(
    Icons.access_time_rounded,
    color: Colors.grey,
    ),
    ),
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: MyInputField(
    title: "End Time",
    hint: _endTime,
    widget: IconButton(
    onPressed: () {
    _getTimeFromUser(isStartTime: false, setState: setState);
    },
    icon: const Icon(
    Icons.access_time_rounded,
    color: Colors.grey,
    ),
    ),
    ),
    ),
    ],
    ),
    const SizedBox(height: 18),
    Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Color",
    style: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: screenWidth / 21,
    fontFamily: "NexaBold",
    ),
    ),
    const SizedBox(height: 8.0),
    Wrap(
    crossAxisAlignment: WrapCrossAlignment.start,
    children: List<Widget>.generate(3, (int index) {
    return GestureDetector(
    onTap: () {
    setState(() {
    _selectedColor = index;
    });
    },
    child: Padding(
    padding:const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: index == 0
            ? Colors.red
            : index == 1
            ? Colors.blueAccent
            : Colors.yellow,
        child: _selectedColor == index
            ? const Icon(
          Icons.done,
          color: Colors.white,
          size: 16,
        )
            : Container(),
      ),
    ),
    );
    }),
    ),
    ],
    ),
      GestureDetector(
        onTap: () => _validateData(context),
        child: Container(
          width: 120,
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.black,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const Center(
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
    ),
      const SizedBox(
        height: 40,
      ),
    ],
    ),
          ),
      );
        },
        ),
      isScrollControlled: true,
    );
  }
  void _validateData(BuildContext context) {
    if (_reasons.isNotEmpty) {
      _addDaysOffToDb();
      Get.off(() => AttendanceHomeScreen(service: service));
    } else if (_reasons.isEmpty) {
      Get.snackbar(
        "Required",
        "Reasons For Day Off is required!",
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
        ),
      );
    }
  }
  _addDaysOffToDb() async {
    await _getLocation();
    final attendance = AttendanceModel()
      ..clockIn = _startTime
      ..date = DateFormat('dd-MMMM-yyyy').format(_selectedDate)
      ..clockInLatitude = UserModel.lat
      ..clockInLocation = location.value
      ..clockInLongitude = UserModel.long
      ..clockOut = _endTime
      ..clockOutLatitude = UserModel.lat
      ..clockOutLocation = location.value
      ..clockOutLongitude = UserModel.long
      ..isSynced = false
      ..voided = false
      ..isUpdated = true
      ..offDay = true
      ..durationWorked = _reasons
      ..noOfHours = _diffHoursWorked(_startTime, _endTime)
      ..month = DateFormat('MMMM yyyy').format(_selectedDate);

    await service.saveAttendance(attendance);
  }
  void _getDateFromUser(StateSetter setState) async {
    DateTime? _pickerDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2090),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }
  void _getTimeFromUser({required bool isStartTime, required StateSetter setState}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(Get.context!);
    print(pickedTime);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }
  Future<TimeOfDay> _showTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: Get.context!,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    // If the user cancels the picker, return the current time
    return pickedTime ?? TimeOfDay.now();
  }
  
  Future _getLocation() async {
    List placemark =
    await placemarkFromCoordinates(lati.value, longi.value);
    if (placemark.isNotEmpty) {
      location.value =
      "${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].subAdministrativeArea}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    }
  }
}