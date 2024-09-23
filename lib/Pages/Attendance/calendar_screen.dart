import 'dart:async';
import 'dart:developer';

import 'package:attendanceapp/api/Attendance_gsheet_api.dart';
import 'package:attendanceapp/model/attendance_gsheet_model.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
// import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:attendanceapp/widgets/progress_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/bio_model.dart';
import '../../model/locationmodel.dart';
import '../../model/track_location_model.dart';
import '../../services/geofencing.dart';
import '../../widgets/constants.dart';
import '../../widgets/geo_utils.dart';
import '../OffDays/update_attendance.dart';
import 'attendance_home.dart';

class CalendarScreen extends StatefulWidget {
  final IsarService service;
  const CalendarScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  //Here, we are creating and valueListenable variable and it gets changed everytime there is a change in connectivity.
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  //ValueNotifier<bool> isDeviceConnected = ValueNotifier(false);
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  //late StreamSubscription<ConnectivityResult> subscription;
  late SharedPreferences sharedPreferences;

  double screenHeight = 0;
  double screenWidth = 0;
  // var firebaseAuthId;
  // var state;
  // var project;
  // var firstName;
  // var lastName;
  // var designation;
  // var department;
  // var location;
  // var staffCategory;
  // var mobile;
  // var emailAddress;
  late Future<User> user;
  var newUser;
  var id;

  Color primary = const Color(0xffeef444c);

  String _month = DateFormat("MMMM yyyy").format(DateTime.now());

  // Method to refresh the CalendarScreen
  void refresh() {
    setState(() {
      // You can add any specific logic here to update data if needed
      // For example, you could refetch attendance data from Isar:
      // widget.service.searchAllAttendance().then((attendance) {
      //   // Update your state variables with the new attendance data
      // });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCurrentDateRecordCount();
    // _updateEmptyClockInAndOutLocation().then((value) {
    //   _startTimer(context);
    //   _getUserDetails();
    //   getConnectivity();
    // });

    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   isDeviceConnected.value = await InternetConnectionChecker().hasConnection;
    //   log("Internet status ====== $isDeviceConnected");
    // });
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await widget.service.getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

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
    //_startTimer(context);
    // _getUserDetails();
    // getConnectivity();
  }

  // void _getUserDetails() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     if (sharedPreferences.getString("emailAddress") != null) {
  //       setState(() {
  //         firebaseAuthId = sharedPreferences.getString("firebaseAuthId")!;
  //         state = sharedPreferences.getString("state")!;
  //         project = sharedPreferences.getString("project")!;
  //         firstName = sharedPreferences.getString("firstName")!;
  //         lastName = sharedPreferences.getString("lastName")!;
  //         designation = sharedPreferences.getString("designation")!;
  //         department = sharedPreferences.getString("department")!;
  //         location = sharedPreferences.getString("location")!;
  //         staffCategory = sharedPreferences.getString("staffCategory")!;
  //         mobile = sharedPreferences.getString("mobile")!;
  //         emailAddress = sharedPreferences.getString("emailAddress")!;
  //       });
  //     } else {
  //       CircularProgressIndicator();
  //     }
  //   } catch (e) {}
  // }

  // Future<void> _getAllAttendance() async {

  // }



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Attendance History",
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
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
      //       child: Stack(
      //         children: <Widget>[
      //           Image.asset("./assets/image/ccfn_logo.png"),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      drawer: drawer(
        this.context,
        IsarService(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              //padding: const EdgeInsets.only(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*
                  Expanded(
                    child: Text(
                      "My Attendance",
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),


                  Expanded(
                    child:Image(
                      image: AssetImage("images/ccfn_logo.png"),
                      width: screenWidth/18,
                      height :screenHeight/18,
                    ),
                  ),
                  */
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    _month,
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.red,
                                  secondary: Colors.red,
                                  onSecondary: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headlineMedium: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  labelSmall: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  labelLarge: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          });

                      if (month != null) {
                        setState(() {
                          _month = DateFormat('MMMM yyyy').format(month);
                        });
                      }
                    },
                    child: Text(
                      "Pick a Month",
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: screenHeight / 1.45,
              width: screenWidth / 1,
              child: StreamBuilder<List<AttendanceModel>>(
                stream: widget.service.searchAllAttendance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final attendance = snapshot.data;
                    if (attendance!.isEmpty) {
                      return const Center(child: Text('No Attendance found for the current month'));
                    }
                    return ListView.builder(
                      itemCount: attendance.length,
                      itemBuilder: (context, index) {
                        return attendance[index].month == _month
                            ? GestureDetector(
                            onTap: () {
                              // _showBottomSheet2(
                              //     context, attendance[index].id);

                              _showAttendanceOptionsDialog(context, attendance[index].id);
                            },
                            child:
                        // Flexible( // This will expand only if there's extra space
                        //     child:
                        Container(
                                margin: EdgeInsets.only(
                                    top: index > 0 ? 20 : 0, left: 6, right: 6),
                                //height: 300,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  children:[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // first Expanded Widget
                                        Container(
                                          margin: const EdgeInsets.only(),
                                          padding: const EdgeInsets.all(5),
                                          width: screenWidth * 0.30,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                //Colors.redAccent,
                                                //Colors.black,
                                                Colors.deepOrange,
                                                Colors.deepOrange,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24),
                                            ),
                                          ),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  attendance[index].date.toString(),
                                                  style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 30,
                                                    color: Colors.white,
                                                      fontWeight:FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  attendance[index].offDay == true
                                                      ? "DayOff: ${attendance[index].durationWorked}"
                                                      : "Hour : ${attendance[index].durationWorked}",
                                                  style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 26,
                                                    color: Colors.white,
                                                      fontWeight:FontWeight.bold
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  attendance[index]
                                                      .isSynced
                                                      .toString() ==
                                                      "true"
                                                      ? "Synced"
                                                      : "Not Synced",
                                                  style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 27,
                                                    color: attendance[index]
                                                        .isSynced
                                                        .toString() ==
                                                        "true"
                                                        ? Color.fromARGB(
                                                        255, 6, 202, 12)
                                                        : Color.fromARGB(
                                                        255, 252, 252, 252),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                IconButton(
                                                  icon: Icon(Icons.refresh, color: Colors.white, size: screenWidth / 18),
                                                  onPressed: () {
                                                    // Add your re-sync logic here
                                                    syncCompleteData(attendance[index].id);
                                                  },
                                                ),

                                              ]),
                                        ),

                                        // Second Expanded Widget

                                        SizedBox(
                                          width: screenWidth * 0.27,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Clock In",
                                                style: TextStyle(
                                                    fontFamily: "NexaLight",
                                                    fontSize: screenWidth / 20,
                                                    color: attendance[index]
                                                        .clockIn
                                                        .toString() ==
                                                        "--/--"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              ),
                                              Text(
                                                attendance[index]
                                                    .clockIn
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 18,
                                                    color: attendance[index]
                                                        .clockIn
                                                        .toString() ==
                                                        "--/--"
                                                        ? Colors.red
                                                        : Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Lat:${attendance[index].clockInLatitude.toString()}",
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 30,
                                                    color: attendance[index]
                                                        .clockInLatitude
                                                        .toString() ==
                                                        "0.0"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              ),
                                              Text(
                                                "Long:${attendance[index].clockInLongitude.toString()}",
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 30,
                                                    color: attendance[index]
                                                        .clockInLongitude
                                                        .toString() ==
                                                        "0.0"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              ),
                                              // Text(
                                              //   "Location:${attendance[index].clockInLocation.toString()}",
                                              //   style: TextStyle(
                                              //     fontFamily: "NexaBold",
                                              //     fontSize: screenWidth / 30,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        // Third Expanded Widget
                                        SizedBox(
                                          width: screenWidth * 0.28,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Clock Out",
                                                style: TextStyle(
                                                    fontFamily: "NexaLight",
                                                    fontSize: screenWidth / 20,
                                                    color: attendance[index]
                                                        .clockOut
                                                        .toString() ==
                                                        "--/--"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              ),
                                              Text(
                                                attendance[index]
                                                    .clockOut
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 18,
                                                    color: attendance[index]
                                                        .clockOut
                                                        .toString() ==
                                                        "--/--"
                                                        ? Colors.red
                                                        : Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Lat:${attendance[index].clockOutLatitude.toString()}",
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 30,
                                                    color: attendance[index]
                                                        .clockOutLatitude
                                                        .toString() ==
                                                        "0.0"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              ),
                                              Text(
                                                "Long:${attendance[index].clockOutLongitude.toString()}",
                                                style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 30,
                                                    color: attendance[index]
                                                        .clockOutLongitude
                                                        .toString() ==
                                                        "0.0"
                                                        ? Colors.red
                                                        : Colors.black54),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                     width: screenWidth * 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.deepOrange,
                                            Colors.black,
                                          ],

                                         begin: Alignment.centerRight,
                                          end: Alignment.centerLeft,
                                         // begin: Alignment.bottomCenter,
                                        //  end: Alignment.topCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(24),
                                          bottomRight: Radius.circular(24),
                                        ),


                                      ),
                                      padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 2.0), // Adjust values
                                      child: Column(
                                        children:[

                                          Text(
                                            "Clock-In Location: ${attendance[index].clockInLocation.toString()}",
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 30,
                                              color: Colors.white,
                                              fontWeight:FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height:5),
                                          Text(
                                            "Clock-Out Location: ${attendance[index].clockOutLocation.toString()}",
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 30,
                                              color: Colors.white,
                                                fontWeight:FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height:5),
                                          Text(
                                            "Comments: ${attendance[index].comments.toString()}",
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 30,
                                              color: Colors.white,
                                                fontWeight:FontWeight.bold
                                            ),
                                          ),
                                        ]
                                      )

                                    ),
                                  ]

                                ),

                              )



                       // )

                        )
                            : SizedBox();
                      },
                    );
                  } else {
                    return const Center(child: Text('No Attendance ever recorded yet.Navigate to the Attendance page in the center tab and clock-in'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAttendanceOptionsDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Attendance"),
          content: Text("Do you want to delete this attendance?"),
          actions: [
            TextButton(
              onPressed: () {
                // Close the first dialog
                Navigator.of(context).pop();
                // Show the confirmation dialog
                _showDeleteConfirmationDialog(context, id);
              },
              child: Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  Future<void> _updateEmptyClockInAndOutLocation() async {
    await _updateEmptyClockInLocation().then((value) {
      _updateEmptyClockOutLocation();
    });
  }
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

        print("Officessss == ${offices}");

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

          print("Location from map === ${location1}");
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

        print("Officessss == ${offices}");

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

          print("Location from map === ${location2}");
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

  // This Method updates all attendance that has a clock-out made. This is necessary for data validation and to ensure that folks sign-out appropraitely
  syncCompleteData(int id) async {
    try {
      // The try block first of all saves the data in the google sheet for the visualization and then on the firebase database as an extra backup database  before chahing the sync status on Mobile App to "Synced"
      //Query the firebase and get the records having updated records
      List<BioModel> getAttendanceForBio =
      await widget.service.getBioInfoWithUserBio();

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
          .get();

      //print("firebaseAuthId == ${getAttendanceForBio[0].firebaseAuthId}");

      List<AttendanceModel> getAttendanceForPartialUnSynced =
      await widget.service.getAttendanceForId(id);

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
            }).then((value) {
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
                  unSyncedAttend.id, AttendanceModel(), true).then((_){
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

  _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this attendance? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () async {
                await widget.service.removeAttendance(id);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return AttendanceHomeScreen(service: IsarService());
                    },
                  ),
                );
                Fluttertoast.showToast(
                  msg: "Attendance Deleted",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black54,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }


  _showBottomSheet2(BuildContext context, int id) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: MediaQuery.of(context).size.height * 0.26,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[350],
            ),
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepOrange,
                  ),
                ),
                Spacer(),
                // _bottomSheetButton(
                //   label: "Update Attendance",
                //   onTap: () async {
                //     final attendanceUpdate =
                //     await widget.service.getSpecificAttendance(id);
                //     final attendanceList =
                //     await widget.service.getListSpecificAttendance(id);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => UpdateAttendance(
                //               service: IsarService(),
                //               attendanceUpdate: attendanceUpdate,
                //               //  feedbackList:feedbackList,
                //               passedId: id,
                //             )));
                //     Fluttertoast.showToast(
                //         msg: "Attendance Updated",
                //         toastLength: Toast.LENGTH_LONG,
                //         backgroundColor: Colors.black54,
                //         gravity: ToastGravity.BOTTOM,
                //         timeInSecForIosWeb: 1,
                //         textColor: Colors.white,
                //         fontSize: 16.0);
                //     //_updateFeedback(context, id);
                //     //_taskController.markTaskCompleted(task.id!);
                //     //Navigator.of(context).pop();
                //   },
                //   clr: Colors.red,
                //   context: context,
                // ),
                _bottomSheetButton(
                  label: "Delete Attendance",
                  onTap: () async {
                    await widget.service
                        .removeAttendance(id);
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return AttendanceHomeScreen(
                          service: IsarService(),
                        );
                      }),
                    );
                    Fluttertoast.showToast(
                        msg: "Attendance Deleted",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.black54,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  clr: Colors.orange,
                  context: context,
                ),
                SizedBox(
                  height: 20,
                ),
                _bottomSheetButton(
                  label: "Close",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  clr: Colors.red,
                  isClose: true,
                  context: context,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  _bottomSheetButton(
      {required String label,
        required Function()? onTap,
        required Color clr,
        bool isClose = false,
        required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
         color: label == "Close" ? Colors.red : Colors.blue,
          border: Border.all(
            width: 2,
            color: Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
          //color: Colors.transparent,
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: "NexaBold")),
        ),
      ),
    );
  }
/*
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
  Future _updateEmptyClockInLocation() async {
    //First, query the list of all records with empty Clock-In Location
    List<AttendanceModel> attendanceForEmptyLocation =
        await widget.service.getAttendanceForEmptyClockInLocation();

    //Iterate through each queried loop
    for (var attend in attendanceForEmptyLocation) {
      // Create a variable
      var location = "";
      //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockInLatitude ?? 0.0, attend.clockInLongitude ?? 0.0);

      setState(() {
        location =
            "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
      });

      //Update all missing Clock In location
      widget.service
          .updateEmptyClockInLocation(attend.id, AttendanceModel(), location);
      //print(attend.clockInLatitude);
    }
  }

//This method updates all empty Clock-Out Location Using the Latitude and Longitude during clock-out
  Future _updateEmptyClockOutLocation() async {
    //First, query the list of all records with empty Clock-In Location
    List<AttendanceModel> attendanceForEmptyLocation =
        await widget.service.getAttendanceForEmptyClockOutLocation();

    //Iterate through each queried loop
    for (var attend in attendanceForEmptyLocation) {
      // Create a variable
      var location = "";
      //Input the queried latitude and Lngitude, but also assign 0.0 to any null Latitude and Longitude
      List<Placemark> placemark = await placemarkFromCoordinates(
          attend.clockOutLatitude ?? 0.0, attend.clockOutLongitude ?? 0.0);

      setState(() {
        location =
            "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
      });

      //Update all missing Clock In location
      widget.service
          .updateEmptyClockOutLocation(attend.id, AttendanceModel(), location);
      //print(attend.clockInLatitude);
    }
  }

  //This method checks and updates and empty Clock-in and Clock-Out Location before syncning the data
  Future<void> _updateEmptyClockInAndOutLocation() async {
    await _updateEmptyClockInLocation().then((value) {
      _updateEmptyClockOutLocation();
    });
  }

/*
  // This Full Updates all Un-synced data. Note that even if the clock-out was made, it would sync it thereby causing multiple reads on the firebase
  updateFullSyncedData() async {
    //Query the firebase and get the records having updated records
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Staff")
        .where("id", isEqualTo: firebaseAuthId)
        .get();

    List<AttendanceModel> getAttendanceForUnSynced =
        await widget.service.getAttendanceForUnSynced();

    await _updateEmptyClockInAndOutLocation().then((value) async => {
          //Iterate through each queried loop
          for (var unSyncedAttend in getAttendanceForUnSynced)
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
              }).then((value) {
                widget.service.updateSyncStatus(
                    unSyncedAttend.id, AttendanceModel(), true);
              })
              //

              //
            }
        });
  }

*/

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

  void _startTimer(BuildContext context) {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      log("timer started===========");
      log("timer=====${timer.tick}");
      if (isDeviceConnected) {
        _updateEmptyClockInAndOutLocation().then((value) {
          syncCompleteData();
        }).then((value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Data synced...")));
        });
        //updateFullSyncedData();
      }
    });
  }
*/
}
