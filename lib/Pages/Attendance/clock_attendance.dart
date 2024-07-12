import 'dart:async';
import 'dart:developer';
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/Pages/Dashboard/admin_dashboard.dart';
import 'package:attendanceapp/Pages/Dashboard/user_dashboard.dart';
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
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
//import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class ClockAttendance extends StatefulWidget {
  final IsarService service;
  const ClockAttendance(this.service, {Key? key}) : super(key: key);

  @override
  State<ClockAttendance> createState() => _ClockAttendanceState();
}

class _ClockAttendanceState extends State<ClockAttendance> {
  List<ClockAttendance> selectedAttendance = [];
  Attendance attendance = Attendance();
  late SharedPreferences sharedPreferences;
  double screenHeight = 0;
  double screenWidth = 0;

  String clockIn = "--/--";
  String clockOut = "--/--";
  String durationWorked = "";
  //Create String Location
  String location = "";
  String clockInLocation = "";
  String clockOutLocation = "";
  String currentDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
  // ignore: prefer_typing_uninitialized_variables
  var role;
  // ignore: prefer_typing_uninitialized_variables
  var firstName;
  // ignore: prefer_typing_uninitialized_variables
  var lastName;
  // ignore: prefer_typing_uninitialized_variables
  var emailAddress;
  // ignore: prefer_typing_uninitialized_variables
  var firebaseAuthId;
  var isLocationTurnedOn = false;
  var isLocationPermissionGranted;
  bool isAlertSet = false;
  bool isAlertSet2 = false;
  StreamSubscription? subscription;
  //var durationWorked;
  DateTime ntpTime = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "11:59 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _reasons = "";
  var isDeviceConnected = false;

  var longi = 0.0;
  var lati = 0.0;

  List<String> reasonsForDayOff = [
    "Holiday",
    "Annual Leave",
    "Sick Leave",
    "Other Leaves",
    "Absent",
    "Travel",
    "Remote Working"
  ];
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    //getCurrentDateRecordCount();
    _loadNTPTime();

    _getAttendanceSummary();
    //getConnectivity();
    setState(() {
      // _getDateFromUser();
      _startLocationService().then((value) {
        //_startGeofencing();
        _getAttendanceSummary();
        _getUserDetail();
        _getLocation();
      });
      getLocationStatus().then((value) {
        getPermissionStatus();
      });
    });
    //Initialize the method to check is location is turned on after which anoher dialog checks if permission is granted
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await widget.service.getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

  void _loadNTPTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }

  // getConnectivity() {
  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) async {
  //     isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //     log("Internet status ====== $isDeviceConnected");
  //     // if (!isDeviceConnected && isAlertSet == false) {
  //     //   showDialogBox();
  //     //   setState(() {
  //     //     isAlertSet = true;
  //     //   });
  //     // }
  //   });
  // }

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      emailAddress = userDetail?.emailAddress;
      role = userDetail?.role;
    });
  }

  //Here we try to get the last attendance and check if it is the same with the cutrrent date so that the
  // already saved attendance is displayed on the UI
  void _getAttendanceSummary() async {
    try {
      final attendanceLast = await widget.service
          .getLastAttendance(DateFormat('MMMM yyyy').format(DateTime.now()));

      log("attendanceLast ==== ${attendanceLast!.clockIn}");

      //String? lastAttendance = attendanceLast[0].date;
      final attendanceResult = await widget.service.getAttendanceForDate(
          DateFormat('dd-MMMM-yyyy').format(DateTime.now()));

      log("attendanceResult ==== ${attendanceResult[0].clockIn}");
      if (attendanceLast.date == currentDate) {
        setState(() {
          clockIn = attendanceLast.clockIn!;
          clockOut = attendanceLast.clockOut!;
          clockInLocation = attendanceLast.clockInLocation!;
          clockOutLocation = attendanceLast.clockOutLocation!;
          durationWorked = attendanceLast.durationWorked!;
          clockInLocation = attendanceLast.clockInLocation!;
          clockOutLocation = attendanceLast.clockOutLocation!;
        });
      } else {
        setState(() {
          clockIn = attendanceResult[0].clockIn!;
          clockOut = attendanceResult[0].clockOut!;
          clockInLocation = attendanceResult[0].clockInLocation!;
          clockOutLocation = attendanceResult[0].clockOutLocation!;
          durationWorked = attendanceResult[0].durationWorked!;
          clockInLocation = attendanceResult[0].clockInLocation!;
          clockOutLocation = attendanceResult[0].clockOutLocation!;
        });
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

// Start LOcation Service
  Future<void> _startLocationService() async {
    LocationService locationService = LocationService();

    Position? position = await locationService.getCurrentPosition();
    if (position != null) {
      setState(() {
        UserModel.long = position.longitude;
        lati = position.latitude;
        longi = position.longitude;
        UserModel.lat = position.latitude;
      });



      String? administrativeArea;
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        administrativeArea = placemarks[0].administrativeArea;
      }
      print("Administrative Areaaaa ==== ${administrativeArea}");

      if (administrativeArea != null) {
        // Query Isar database for locations with the same administrative area
        List<LocationModel> isarLocations =
        await widget.service.getLocationsByState(administrativeArea);

       // print("Administrative Areaaaa ==== ${administrativeArea}");

        // Convert Isar locations to GeofenceModel
        List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
          name: location.locationName!, // Use 'locationName'
          latitude: location.latitude ?? 0.0,
          longitude: location.longitude ?? 0.0,
          radius: location.radius?.toDouble() ?? 0.0,
        )).toList();

        print("Ofiicessss == ${offices}");

        bool isInsideAnyGeofence = false;
        for (GeofenceModel office in offices) {
          double distance = GeoUtils.haversine(
              position.latitude, position.longitude, office.latitude, office.longitude);
          if (distance <= office.radius) {
            print('Entered office: ${office.name}');
            location = office.name;
            // setState(() {
            //   location = office.name;
            // });
            isInsideAnyGeofence = true;
            break;
          }
        }

        if (!isInsideAnyGeofence) {
         // _getLocation();
          List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

          location =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
          //
          // setState(() {
          //   location =
          //   "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
          // });
          print("Location from map === ${location}");
        }
      } else {
       // _getLocation();
        List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

        setState(() {
          location =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
        });
        print("Unable to get administrative area. Using default location.");
      }

    }
  }

  //A function to get location using geocoding
  Future<void> _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(lati, longi);

    setState(() {
      location =
          "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    });
  }

  Future<String> _getLocation2() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(UserModel.lat, UserModel.long);

    //setState(() {
    return "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    //});
  }

  //Get the already saved User details that were pulled into the shared preferences during the initial one-time login

  // getLocationStatus() async {
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     isLocationTurnedOn = (await LocationService().getLocationStatus())!;
  //     //log("Location status ====== $isLocationTurnedOn");
  //
  //     if (!isLocationTurnedOn && isAlertSet == false) {
  //       showDialogBox();
  //       setState(() {
  //         isAlertSet = true;
  //       });
  //     }
  //   });
  // }

  Future<void> getLocationStatus() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    setState(() {
      isLocationTurnedOn = isLocationEnabled;

      if (!isLocationTurnedOn && !isAlertSet) {
        showDialogBox();
        isAlertSet = true;
      }
    });
  }

  // getPermissionStatus() async {
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     isLocationPermissionGranted =
  //         await LocationService().getPermissionStatus();
  //     //log("Permission status ====== $isLocationPermissionGranted");
  //
  //     if ((isLocationPermissionGranted == PermissionStatus.denied ||
  //             isLocationPermissionGranted == PermissionStatus.deniedForever) &&
  //         isAlertSet2 == false) {
  //       showDialogBox2();
  //       setState(() {
  //         isAlertSet2 = true;
  //       });
  //     }
  //   });
  // }

  Future<void> getPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();

    setState(() {
      isLocationPermissionGranted = (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always);

      if (!isLocationPermissionGranted && !isAlertSet2) {
        showDialogBox2();
        isAlertSet2 = true;
      }
    });
  }


  // void _startGeofencing() async {
  //   // Implement your geofencing logic here
  //   // Get the current location periodically and check if it is inside the geofence
  //
  //   // Example: Get the current location every 10 seconds
  //   // const Duration interval = Duration(seconds: 10);
  //   //Timer.periodic(interval, (Timer timer) async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best,
  //   );
  //
  //
  //   print(position);
  //   if(UserModel.lat == 0.0){
  //     setState(() {
  //       UserModel.lat = position.latitude;
  //       lati = position.latitude;
  //       print("Setlati======$lati");
  //     });
  //   }
  //
  //   if(UserModel.long == 0.0){
  //     setState(() {
  //       UserModel.long = position.longitude;
  //       longi = position.longitude;
  //       print("Setlongi======$longi");
  //     });
  //   }
  //
  //
  //   // Check if the current position is inside the geofence
  //   List<GeofenceModel> offices = getGeofenceOffices();
  //   for (GeofenceModel office in offices) {
  //     // double distance = Geolocator.distanceBetween(
  //     //   office.latitude,
  //     //   office.longitude,
  //     //   position.latitude,
  //     //   position.longitude,
  //     //
  //     // );
  //
  //     double distance = GeoUtils.haversine(UserModel.lat,UserModel.long, office.latitude, office.longitude);
  //     //double distance = GeoUtils.calculateDistance(position.latitude,position.longitude, office.latitude, office.longitude);
  //
  //     if (distance <= office.radius) {
  //       // Device is inside the geofence, perform geofencing actions for this office
  //       print('Entered office: ${office.name}');
  //       setState(() {
  //         location = office.name;
  //         print("location data === ${location}");
  //       });
  //       break;
  //     }
  //     else{
  //       _getLocation();
  //     }
  //   }
  //   //  });
  // }

  // Future<void> _startGeofencing() async {
  //   // Get current position
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best,
  //   );
  //
  //   // Update UserModel with current location if it's 0.0
  //   if (UserModel.lat == 0.0) {
  //     setState(() {
  //       UserModel.lat = position.latitude;
  //       print("Setlati======$lati");
  //     });
  //   }
  //
  //   if (UserModel.long == 0.0) {
  //     setState(() {
  //       UserModel.long = position.longitude;
  //       print("Setlongi======$longi");
  //     });
  //   }
  //
  //   // Get administrative area from coordinates
  //   String? administrativeArea;
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //   if (placemarks.isNotEmpty) {
  //     administrativeArea = placemarks[0].administrativeArea;
  //   }
  //
  //   if (administrativeArea != null) {
  //     // Query Isar database for locations with the same administrative area
  //     List<LocationModel> isarLocations =
  //     await widget.service.getLocationsByState(administrativeArea);
  //
  //     // Convert Isar locations to GeofenceModel
  //     List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
  //       name: location.name,
  //       latitude: 'location.latitude',
  //       longitude: 'location.longitude',
  //       radius: location.radius.toDouble(), // Assuming radius is stored as int in Isar
  //     )).toList();
  //
  //     bool isInsideAnyGeofence = false;
  //     for (GeofenceModel office in offices) {
  //       double distance = GeoUtils.haversine(
  //           UserModel.lat, UserModel.long, office.latitude, office.longitude);
  //       if (distance <= office.radius) {
  //         // Inside geofence
  //         print('Entered office: ${office.name}');
  //         setState(() {
  //           location = office.name;
  //         });
  //         isInsideAnyGeofence = true;
  //         break;
  //       }
  //     }
  //
  //     if (!isInsideAnyGeofence) {
  //       _getLocation(); // Get location using geocoding if outside all geofences
  //       print("Location from map === ${location}");
  //     }
  //   } else {
  //     // Handle case where administrative area is not available
  //     _getLocation(); // Or set a default location
  //     print("Unable to get administrative area. Using default location.");
  //   }
  // }



  List<GeofenceModel> getGeofenceOffices() {
    // Implement this function to return a list of GeofenceModel objects for your offices
    // Example:
    List<GeofenceModel> offices = [
      GeofenceModel(name: 'Pengassan Estate, Phase One, Lokogoma', latitude: 8.9539461, longitude: 7.4683953, radius: 400),
      GeofenceModel(name: 'Catholic Secretariat Of Nigeria,Abuja', latitude: 9.0205784,  longitude: 7.4738459, radius: 100),

      // Add more office coordinates
    ];
    return offices;
  }



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "My Attendance",
      //     style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
      //   ),
      //   elevation: 0.5,
      //   iconTheme: const IconThemeData(color: Colors.red),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //             colors: <Color>[
      //           Colors.white,
      //           Colors.white,
      //         ])),
      //   ),
      //   // actions: [
      //   //   Container(
      //   //     margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
      //   //     child: Stack(
      //   //       children: <Widget>[
      //   //         Image.asset("./assets/image/ccfn_logo.png"),
      //   //       ],
      //   //     ),
      //   //   )
      //   // ],
      // ),

      drawer: role == "User"
          ? drawer(this.context, IsarService())
          : drawer2(this.context, IsarService()),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
                child: HeaderWidget(100, false, Icons.house_rounded),
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${firstName.toString().toUpperCase()} ${lastName.toString().toUpperCase()}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Today's Status: ",
                  style: TextStyle(
                    // color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Latitude: ${lati.toString()}, Longitude: ${longi.toString()}",
                  style: TextStyle(
                    //color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 23,
                  ),
                ),
              ),
              //Card View for ClockIn and ClockOut
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 32),
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    )
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
                              color: Colors.black54),
                        ),
                        Text(
                          clockIn,
                          //_timeRecords[0]["clockIn"].toString(),
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ],
                    )),
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
                              color: Colors.black54),
                        ),
                        Text(
                          clockOut,
                          // _timeRecords[0]["clockOut"].toString(),
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 18,
                          ),
                        )
                      ],
                    )),
                  ],
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
                            fontFamily: "NexaBold"),
                        children: [
                          TextSpan(
                              text: DateFormat(" MMMM yyyy")
                                  .format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth / 20,
                                  fontFamily: "NexaBold"))
                        ]),
                  )),

              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat("hh:mm:ss a").format(DateTime
                            .now() /*.add(Duration(milliseconds: checkTime.checkTime() as int))*/),
                        style: TextStyle(
                            fontFamily: "NexaLight",
                            fontSize: screenWidth / 20,
                            color: Colors.black54),
                      ),
                    );
                  }),

              clockOut == "--/--"
                  ? Column(
                      children: [
                        // A container for the Slider
                        Container(
                          margin: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> key =
                                  GlobalKey();
                              return SlideAction(
                                  //Here if clock in is empty, then it should be "Slide to Clock in"
                                  text: clockIn == "--/--"
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
                                    //If the user latitude or Longitude is not zero, then invoke the _getLocation Method
                                    // afterwhich a timer widget is used to embed the method that queries for the last saved record in isar database using the id
                                    // Once the last record is gotten , it is compared with the current date and if it is not same, it means that the staff hasnt clocked in,so it would create a new record and save in the isar offline Database
                                    // else, it would update the existing record with the clock-out,clockOut Latitude,clockOut Longitude and clockOut Location
                                    if (UserModel.lat != 0) {
                                      _getLocation();
                                      Timer(const Duration(seconds: 1),
                                          () async {
                                        // final attendanceLast = await widget
                                        //     .service
                                        //     .getAttendanceForLast();

                                        try {
                                          final lastAttend = await widget
                                              .service
                                              .getLastAttendance(
                                                  DateFormat("MMMM yyyy")
                                                      .format(DateTime.now())
                                                      .toString());

                                          log("Last Attend ====== ${lastAttend!.date}");
                                          if (lastAttend.date != currentDate) {
                                            if (isDeviceConnected) {
                                              final int offset2 =
                                                  await NTP.getNtpOffset(
                                                      localTime: DateTime.now(),
                                                      lookUpAddress:
                                                          "time.google.com");
                                              DateTime internetTime =
                                                  DateTime.now().add(Duration(
                                                      milliseconds: offset2));

                                              final attendnce =
                                                  AttendanceModel()
                                                    ..clockIn = DateFormat(
                                                            'hh:mm a')
                                                        .format(internetTime)
                                                    ..date = DateFormat(
                                                            'dd-MMMM-yyyy')
                                                        .format(internetTime)
                                                    ..clockInLatitude =
                                                        UserModel.lat
                                                    ..clockInLocation = location
                                                    ..clockInLongitude =
                                                        UserModel.long
                                                    ..clockOut = "--/--"
                                                    ..clockOutLatitude = 0.0
                                                    ..clockOutLocation = null
                                                    ..clockOutLongitude = 0.0
                                                    ..isSynced = false
                                                    ..voided = false
                                                    ..isUpdated = false
                                                    ..durationWorked =
                                                        "0 hours 0 minutes"
                                                    ..noOfHours = 0.0
                                                    ..offDay = false
                                                    ..month = DateFormat(
                                                            'MMMM yyyy')
                                                        .format(internetTime);

                                              widget.service
                                                  .saveAttendance(attendnce);
                                              Fluttertoast.showToast(
                                                  msg: "Clocking-In..",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return AttendanceHomeScreen(
                                                    service: IsarService(),
                                                  );
                                                }),
                                              );
                                            } else {
                                              final attendnce =
                                                  AttendanceModel()
                                                    ..clockIn =
                                                        DateFormat('hh:mm a')
                                                            .format(ntpTime)
                                                    ..date = DateFormat(
                                                            'dd-MMMM-yyyy')
                                                        .format(ntpTime)
                                                    ..clockInLatitude =
                                                        UserModel.lat
                                                    ..clockInLocation = location
                                                    ..clockInLongitude =
                                                        UserModel.long
                                                    ..clockOut = "--/--"
                                                    ..clockOutLatitude = 0.0
                                                    ..clockOutLocation = null
                                                    ..clockOutLongitude = 0.0
                                                    ..isSynced = false
                                                    ..voided = false
                                                    ..isUpdated = false
                                                    ..durationWorked =
                                                        "0 hours 0 minutes"
                                                    ..noOfHours = 0.0
                                                    ..offDay = false
                                                    ..month =
                                                        DateFormat('MMMM yyyy')
                                                            .format(ntpTime);

                                              widget.service
                                                  .saveAttendance(attendnce);
                                              Fluttertoast.showToast(
                                                  msg: "Clocking-In..",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return AttendanceHomeScreen(
                                                    service: IsarService(),
                                                  );
                                                }),
                                              );
                                            }
                                          } else if (lastAttend.date ==
                                              currentDate) {
                                            List<AttendanceModel>
                                                attendanceResult = await widget
                                                    .service
                                                    .getAttendanceForDate(
                                                        DateFormat(
                                                                'dd-MMMM-yyyy')
                                                            .format(ntpTime));

                                            final bioInfoForUser = await widget
                                                .service
                                                .getBioInfoWithFirebaseAuth();

                                            //print(attendanceResult[0].id);

                                            widget.service.updateAttendance(
                                              attendanceResult[0].id,
                                              AttendanceModel(),
                                              DateFormat('hh:mm a')
                                                  .format(ntpTime),
                                              UserModel.lat,
                                              UserModel.long,
                                              location,
                                              false,
                                              true,
                                              _diffClockInOut(
                                                attendanceResult[0]
                                                    .clockIn
                                                    .toString(),
                                                DateFormat('h:mm a')
                                                    .format(ntpTime),
                                              ),
                                              _diffHoursWorked(
                                                attendanceResult[0]
                                                    .clockIn
                                                    .toString(),
                                                DateFormat('h:mm a')
                                                    .format(ntpTime),
                                              ),
                                            );
                                            Fluttertoast.showToast(
                                                msg: "Clocking-Out..",
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: Colors.black54,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return bioInfoForUser!.role ==
                                                        "User"
                                                    ? UserDashBoard(
                                                        service: IsarService(),
                                                      )
                                                    : AdminDashBoard(
                                                        service: IsarService(),
                                                      );
                                              }),
                                            );
                                          } else if (lastAttend.date == null) {
                                            if (isDeviceConnected) {
                                              final int offset2 =
                                                  await NTP.getNtpOffset(
                                                      localTime: DateTime.now(),
                                                      lookUpAddress:
                                                          "time.google.com");
                                              DateTime internetTime =
                                                  DateTime.now().add(Duration(
                                                      milliseconds: offset2));

                                              final attendnce =
                                                  AttendanceModel()
                                                    ..clockIn = DateFormat(
                                                            'hh:mm a')
                                                        .format(internetTime)
                                                    ..date = DateFormat(
                                                            'dd-MMMM-yyyy')
                                                        .format(internetTime)
                                                    ..clockInLatitude =
                                                        UserModel.lat
                                                    ..clockInLocation = location
                                                    ..clockInLongitude =
                                                        UserModel.long
                                                    ..clockOut = "--/--"
                                                    ..clockOutLatitude = 0.0
                                                    ..clockOutLocation = null
                                                    ..clockOutLongitude = 0.0
                                                    ..isSynced = false
                                                    ..voided = false
                                                    ..isUpdated = false
                                                    ..durationWorked =
                                                        "0 hours 0 minutes"
                                                    ..noOfHours = 0.0
                                                    ..offDay = false
                                                    ..month = DateFormat(
                                                            'MMMM yyyy')
                                                        .format(internetTime);

                                              widget.service
                                                  .saveAttendance(attendnce);
                                              Fluttertoast.showToast(
                                                  msg: "Clocking-In..",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return AttendanceHomeScreen(
                                                    service: IsarService(),
                                                  );
                                                }),
                                              );
                                            } else {
                                              final attendnce =
                                                  AttendanceModel()
                                                    ..clockIn =
                                                        DateFormat('hh:mm a')
                                                            .format(ntpTime)
                                                    ..date = DateFormat(
                                                            'dd-MMMM-yyyy')
                                                        .format(ntpTime)
                                                    ..clockInLatitude =
                                                        UserModel.lat
                                                    ..clockInLocation = location
                                                    ..clockInLongitude =
                                                        UserModel.long
                                                    ..clockOut = "--/--"
                                                    ..clockOutLatitude = 0.0
                                                    ..clockOutLocation = null
                                                    ..clockOutLongitude = 0.0
                                                    ..isSynced = false
                                                    ..voided = false
                                                    ..isUpdated = false
                                                    ..durationWorked =
                                                        "0 hours 0 minutes"
                                                    ..noOfHours = 0.0
                                                    ..offDay = false
                                                    ..month =
                                                        DateFormat('MMMM yyyy')
                                                            .format(ntpTime);

                                              widget.service
                                                  .saveAttendance(attendnce);
                                              Fluttertoast.showToast(
                                                  msg: "Clocking-In..",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return AttendanceHomeScreen(
                                                    service: IsarService(),
                                                  );
                                                }),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          log("Attencance clockInandOut Error ====== ${e.toString()}");
                                          //if (lastAttend.date == null) {
                                          if (isDeviceConnected) {
                                            print(
                                                "isDeviceConnected ===${isDeviceConnected}");
                                            final int offset2 =
                                                await NTP.getNtpOffset(
                                                    localTime: DateTime.now(),
                                                    lookUpAddress:
                                                        "time.google.com");
                                            DateTime internetTime =
                                                DateTime.now().add(Duration(
                                                    milliseconds: offset2));

                                            final attendnce = AttendanceModel()
                                              ..clockIn = DateFormat('hh:mm a')
                                                  .format(internetTime)
                                              ..date =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(internetTime)
                                              ..clockInLatitude = UserModel.lat
                                              ..clockInLocation = location
                                              ..clockInLongitude =
                                                  UserModel.long
                                              ..clockOut = "--/--"
                                              ..clockOutLatitude = 0.0
                                              ..clockOutLocation = null
                                              ..clockOutLongitude = 0.0
                                              ..isSynced = false
                                              ..voided = false
                                              ..isUpdated = false
                                              ..durationWorked =
                                                  "0 hours 0 minutes"
                                              ..noOfHours = 0.0
                                              ..offDay = false
                                              ..month = DateFormat('MMMM yyyy')
                                                  .format(internetTime);

                                            widget.service
                                                .saveAttendance(attendnce);
                                            Fluttertoast.showToast(
                                                msg: "Clocking-In..",
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: Colors.black54,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return AttendanceHomeScreen(
                                                  service: IsarService(),
                                                );
                                              }),
                                            );
                                          } else {
                                            final attendnce = AttendanceModel()
                                              ..clockIn = DateFormat('hh:mm a')
                                                  .format(ntpTime)
                                              ..date =
                                                  DateFormat('dd-MMMM-yyyy')
                                                      .format(ntpTime)
                                              ..clockInLatitude = UserModel.lat
                                              ..clockInLocation = location
                                              ..clockInLongitude =
                                                  UserModel.long
                                              ..clockOut = "--/--"
                                              ..clockOutLatitude = 0.0
                                              ..clockOutLocation = null
                                              ..clockOutLongitude = 0.0
                                              ..isSynced = false
                                              ..voided = false
                                              ..isUpdated = false
                                              ..durationWorked =
                                                  "0 hours 0 minutes"
                                              ..noOfHours = 0.0
                                              ..offDay = false
                                              ..month = DateFormat('MMMM yyyy')
                                                  .format(ntpTime);

                                            widget.service
                                                .saveAttendance(attendnce);
                                            Fluttertoast.showToast(
                                                msg: "Clocking-In..",
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: Colors.black54,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return AttendanceHomeScreen(
                                                  service: IsarService(),
                                                );
                                              }),
                                            );
                                          }
                                        }

                                        key.currentState!.reset();
                                      });
                                      //Here, If User's Latitude is Not 0, we can continue
                                      //We can use either User's latitude or user's longitude for this
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Error:Latitude and Longitude is = 0",
                                          toastLength: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.black54,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      log("Latitude ====== Latitude and Longitude is = 0");
                                    }
                                  });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        clockIn == "--/--"
                            ? MyButton(
                                label: "Out Of Office? CLICK HERE",
                                onTap: () {
                                  //This Method brings out the Bottom sheet to fill in the days off
                                  _showBottomSheet(context, AttendanceModel());
                                },
                              )
                            : SizedBox.shrink(),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          //If the Location is not empty,it displays the container widget
                          width: MediaQuery.of(context).size.width * 0.9,
                          //height: MediaQuery.of(context).size.height * 100,
                          margin: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.black,
                                ],
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
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Clock-In Location",
                                            style: TextStyle(
                                                fontFamily: "NexaLight",
                                                fontSize: screenWidth / 25,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            clockInLocation,
                                            style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 35,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      //Clock Out
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Clock-Out Location",
                                            style: TextStyle(
                                                fontFamily: "NexaLight",
                                                fontSize: screenWidth / 25,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            clockOutLocation,
                                            style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 35,
                                                color: Colors.white),
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
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
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Duration Worked: ${durationWorked}",
                            //noOfHours.toString(),
                            style: TextStyle(
                                fontFamily: "NexaLight",
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            //If the Location is not empty,it displays the container widget
                            width: MediaQuery.of(context).size.width * 0.9,
                            //height: MediaQuery.of(context).size.height * 100,
                            margin: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.black,
                                  ],
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Clock-In Location",
                                              style: TextStyle(
                                                  fontFamily: "NexaLight",
                                                  fontSize: screenWidth / 25,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              clockInLocation,
                                              style: TextStyle(
                                                  fontFamily: "NexaBold",
                                                  fontSize: screenWidth / 35,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        //Clock Out
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Clock-Out Location",
                                              style: TextStyle(
                                                  fontFamily: "NexaLight",
                                                  fontSize: screenWidth / 25,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              clockOutLocation,
                                              style: TextStyle(
                                                  fontFamily: "NexaBold",
                                                  fontSize: screenWidth / 35,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
            ],
          ),
        ),
      ),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("Location Turned Off"),
          content:
              const Text("Please turn on your location to ClockIn and Out"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, "Cancel");
                  setState(() {
                    isAlertSet = false;
                  });
                  isLocationTurnedOn =
                      (await LocationService().getLocationStatus())!;
                  //     await InternetConnectionChecker().hasConnection;
                  if (!isLocationTurnedOn) {
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

  showDialogBox2() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("Location Permission Denied"),
          content: const Text("Please grant Location Permission"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, "Cancel");

                // Check and request permission (no need to reset isAlertSet2 here)
                await getPermissionStatus();

                // If permission is still not granted, show the dialog again
                if (!isLocationPermissionGranted) {
                  showDialogBox2();
                }
              },
              child: const Text("OK"),
            )
          ],
        ),
      );

  _diffClockInOut(String clockInTime, String clockOutTime) {
    var format = DateFormat("h:mm a");
    var clockTimeIn = format.parse(clockInTime);
    var clockTimeOut = format.parse(clockOutTime);
    if (clockTimeIn.isAfter(clockTimeOut)) {
      clockTimeOut = clockTimeOut.add(Duration(days: 1));
      Duration diff = clockTimeOut.difference(clockTimeIn);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;

      log('$hours hours $minutes minute');
      return ('$hours hour(s) $minutes minute(s)');
    }

    Duration diff = clockTimeOut.difference(clockTimeIn);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    log('$hours hours $minutes minutes');
    return ('$hours hours $minutes minute(s)');
  }

  _diffHoursWorked(String clockInTime, String clockOutTime) {
    var format = DateFormat("h:mm a");
    var clockTimeIn = format.parse(clockInTime);
    var clockTimeOut = format.parse(clockOutTime);
    if (clockTimeIn.isAfter(clockTimeOut)) {
      clockTimeOut = clockTimeOut.add(Duration(days: 1));
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
    //log('$clockTimeIn clockTimeIn $clockTimeOut clockTimeOut');

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

  _showBottomSheet(BuildContext context, AttendanceModel attendanceModel) {
    return showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            DateTime _seletDate = _selectedDate;
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
                      "Out Of Office? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 15,
                      ),
                    ),
                    MyInputField(
                      title: "Date",
                      hint: DateFormat("dd/MM/yyyy").format(_seletDate),
                      widget: IconButton(
                        onPressed: () {
                          _getDateFromUser();
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
                      widget: DropdownButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: screenWidth / 25,
                            fontFamily: "NexaBold"),
                        underline: Container(
                          height: 0,
                        ),
                        items: reasonsForDayOff.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: screenWidth / 25,
                                    fontFamily: "NexaBold"),
                              ),
                            );
                          },
                        ).toList(),
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
                              _getTimeFromUser(isStartTime: true);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: MyInputField(
                          title: "End Time",
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
                            },
                            icon: Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 18),
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
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: screenWidth / 21,
                                  fontFamily: "NexaBold"),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
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
                                    padding: const EdgeInsets.all(8.0),
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
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _validateData(),
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
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  _validateData() {
    if (_reasons != "") {
      //Add to database by firstt sending it to the task controller that would then hand it to the task model and then to the database
      _addDaysOffToDb().then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return AttendanceHomeScreen(
              service: IsarService(),
            );
          }),
        );
      });
    } else if (_reasons == "") {
      Get.snackbar("Required", "Reasons For Day Off is required !",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
          ));
    }
  }

  _addDaysOffToDb() async {
    _getLocation();

    final attendnce = AttendanceModel()
      ..clockIn = _startTime
      ..date = DateFormat('dd-MMMM-yyyy').format(_selectedDate)
      ..clockInLatitude = UserModel.lat
      ..clockInLocation = location
      ..clockInLongitude = UserModel.long
      ..clockOut = _endTime
      ..clockOutLatitude = UserModel.lat
      ..clockOutLocation = location
      ..clockOutLongitude = UserModel.long
      ..isSynced = false
      ..voided = false
      ..isUpdated = true
      ..offDay = true
      ..durationWorked = _reasons
      ..noOfHours = _diffHoursWorked(_startTime, _endTime)
      ..month = DateFormat('MMMM yyyy').format(_selectedDate);

    widget.service.saveAttendance(attendnce);
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime =
        //DateFormat("hh:mm a").format(pickedTime).toString();
        pickedTime.format(context);

    print(pickedTime);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        //_startTime --> 12:00 AM
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
  }
}
