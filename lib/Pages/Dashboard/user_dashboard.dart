import 'dart:async';

import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/dashboard_widget.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/drawer3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../../model/appversion.dart';
import '../../model/bio_model.dart';
import '../../model/departmentmodel.dart';
import '../../model/designationmodel.dart';
import '../../model/facility_staff_model.dart';
import '../../model/last_update_date.dart';
import '../../model/locationmodel.dart';
import '../../model/projectmodel.dart';
import '../../model/psychological_metrics.dart';
import '../../model/reasonfordaysoff.dart';
import '../../model/staffcategory.dart';
import '../../model/statemodel.dart';
import '../../model/supervisor_model.dart';
import '../../model/user_model.dart';
import '../../services/location_services.dart';
import '../../services/notification_services.dart';
import '../../widgets/constants.dart';
import '../../widgets/my_app.dart';
import '../../widgets/progress_dialog.dart';

class UserDashBoard extends StatefulWidget {
  final IsarService service;
  const UserDashBoard({super.key, required this.service});

  @override
  State<UserDashBoard> createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  double screenHeight = 0;
  double screenWidth = 0;
  late SharedPreferences sharedPreferences;
  var firstName;
  var lastName;
  var firebaseAuthId;
  var role;
  var state;
  var location;
  List<FlSpot> dataSet = [];
  List clockInSet = [];
  List clockOutSet = [];
  List totalClockIns = [];
  double totalHoursWorked = 0;
  String _month = DateFormat("MMMM yyyy").format(DateTime.now());
  AttendanceModel attendanceModel = AttendanceModel();
  var notifyHelper;
  var _timer;
  var versionNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForIsSyncedForBio();
   // fetchVersion(IsarService());
    _getUserDetail();
    tz.initializeTimeZones();
    // _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
    //   _checkTimeAndTriggerNotification();
    // });
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _startLocationService();
    // getCurrentDateRecordCount();
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


  List<FlSpot> getPlotPoints(List entireData) {
    dataSet = [];

    for (var specificMonthAttend in entireData) {
      dataSet.add(
        FlSpot(
          (int.parse(specificMonthAttend.date.split("-")[0])).toDouble(),
          (specificMonthAttend.noOfHours as double).toDouble(),
        ),
      );
    }
    return dataSet;
  }

  getTotalClockIn(List entireData) {
    clockInSet = [];

    for (var clockLength in entireData) {
      if (clockLength.clockIn != "--/--") {
        clockInSet.add(clockLength.clockIn);
      }
    }
    return clockInSet.isEmpty ? 0 : clockInSet.length;
  }

  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await widget.service.getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

  getTotalClockOut(List entireData) {
    clockOutSet = [];

    for (var clockLength in entireData) {
      if (clockLength.clockOut != "--/--") {
        clockOutSet.add(clockLength.clockOut);
      }
    }
    return clockOutSet.isEmpty ? 0 : clockOutSet.length;
  }

  getTotalHoursWorked(List entireData) {
    totalHoursWorked = 0;

    for (var clockLength in entireData) {
      totalHoursWorked += clockLength.noOfHours;
    }
    return totalHoursWorked;
  }

  getTotalHoursandMins(double getTotal) {
    final hour = int.parse(getTotal.toString().split(".")[0]);
    final min = double.parse("0.${getTotal.toString().split(".")[1]}");
    //log('$min calculated min');
    final minute = min * 60;
    String inStringMin = minute.toStringAsFixed(0); // '2.35'
    int roundedMinDouble = int.parse(inStringMin);
    return ('$hour hours $roundedMinDouble minute(s)');
  }

  getTotalDaysOff(String month) async {
    // totalClockIns = [];
    return await widget.service.getCountForoffDay(month);
  }

  //Get Details from isar database

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      firebaseAuthId = userDetail?.firebaseAuthId;
      firstName = userDetail?.firstName;
      lastName = userDetail?.lastName;
      role = userDetail?.role;
      state = userDetail?.state;
      location = userDetail?.location;
    });
  }


  @override
  void dispose() {
    //_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "User DashBoard",
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
                ],
              ),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle button press here based on the value
                if (value == 'option1') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyFlutterApp()),
                  );
                } else if (value == 'option2') {
                  _checkForUpdates();
                }
                // ... add cases for other options
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'option1',
                    child: Row(
                      children: [
                        Icon(Icons.access_alarm, color: Colors.red,),
                        SizedBox(width: 8),
                        Text('Background Service'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'option2',
                    child: Row(
                      children: [
                        Icon(Icons.update, color: Colors.red,),
                        SizedBox(width: 8),
                        Text('Check For Updates'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'option3',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red,),
                        SizedBox(width: 8),
                        //Text('$versionNumber Updated'),
                        Text('Version 1.6(Pre-Release)'),
                      ],
                    ),
                  ),
                  // ... add more PopupMenuItems for other buttons
                ];
              },
            ),
          ],
        ),
        drawer: role == "User"
            ? drawer(this.context, IsarService())
            : role == "Admin"
            ? drawer2(this.context, IsarService())
            : drawer3(this.context, IsarService()),
        body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: StreamBuilder<List>(
                stream: widget.service.getHourWorkedForMonth(_month),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Unexpected Error!"),
                    );
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No Attendance Yet for the Month"),
                      );
                    }
                    getPlotPoints(snapshot.data!);
                    getTotalClockIn(snapshot.data!);
                    return ListView(
                      children: [
                        SizedBox(
                          height:
                          //MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.025),
                          MediaQuery.of(context).size.height * 0.025,
                        ),
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                _month,
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontFamily: "NexaBold",
                                    fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.025),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () async {
                                 // _checkTimeAndTriggerNotification();
                                  final month = await showMonthYearPicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime(2099),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
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
                                      dataSet = [];
                                      _month =
                                          DateFormat('MMMM yyyy').format(month);
                                    });
                                  }
                                },
                                child: Text(
                                  "Pick a Month",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: "NexaBold",
                                      fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.025),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Next Create card
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                const Text(
                                  "Attendance Summary",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Total Hours Worked = ${getTotalHoursandMins(getTotalHoursWorked(snapshot.data!))}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      cardClockIn(getTotalClockIn(snapshot.data!)
                                          .toString()),
                                      cardClockOut(getTotalClockOut(snapshot.data!)
                                          .toString()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        dataSet.isEmpty
                            ? Container(
                          //height: MediaQuery.of(context).size.width*0.95,//300
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20.0),
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Text(
                                "No values to render chart",
                                style: TextStyle(
                                  color: Colors.brown,
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                                ),
                              )),
                        )
                            : Container(
                          height: MediaQuery.of(context).size.width * 0.95,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20.0),
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: LineChart(
                            LineChartData(
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: getPlotPoints(snapshot.data!),
                                    isCurved: false,
                                    barWidth: 2.5,
                                    color: const Color.fromARGB(255, 63, 7, 3),
                                  )
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Out-Of-Office History:",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.025),
                                fontWeight: FontWeight.w900,
                                color: Colors.brown),
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: StreamBuilder<List>(
                            stream: widget.service.getDaysOffForMonth(_month),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("UnExpected Error!"),
                                );
                              }
                              if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text("No Day Off for the Month"),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return snapshot.data![index].month == _month
                                        ? Container(
                                      margin: EdgeInsets.only(
                                          top: index > 0 ? 12 : 0,
                                          left: 6,
                                          right: 6),
                                      height: MediaQuery.of(context).size.height * 0.13,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(2, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(),
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.red,
                                                    Colors.black,
                                                  ],
                                                ),
                                                borderRadius:
                                                BorderRadius.all(
                                                  Radius.circular(24),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    // List Date
                                                    child: Text(
                                                      snapshot
                                                          .data![index].date,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "NexaBold",
                                                        fontSize:
                                                        screenWidth / 35,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Center(
                                                    // Reasons For Day Off

                                                    child: Text(
                                                      snapshot.data![index]
                                                          .durationWorked,
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "NexaBold",
                                                        fontSize:
                                                        screenWidth / 24,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //Clock in
                                          Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Start Time",
                                                    style: TextStyle(
                                                        fontFamily: "NexaLight",
                                                        fontSize:
                                                        screenWidth / 22,
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].clockIn,
                                                    style: TextStyle(
                                                      fontFamily: "NexaBold",
                                                      fontSize: screenWidth / 20,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          //Clock Out
                                          Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "End Time",
                                                    style: TextStyle(
                                                        fontFamily: "NexaLight",
                                                        fontSize:
                                                        screenWidth / 22,
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data![index].clockOut,
                                                    style: TextStyle(
                                                      fontFamily: "NexaBold",
                                                      fontSize: screenWidth / 20,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    )
                                        : Container(
                                      //If the Location is not empty,it displays the container widget
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.9,
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
                                              "No Day Off For Current Month",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: screenWidth / 20,
                                                  fontFamily: "NexaBold",
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                    child: Text("No Day Off Recorded !!"));
                              }
                            },
                          ),
                        )
                      ],
                      // -----------------------------------------
                    );
                  } else {
                    return dashBoardWidget(context, setState);
                    //Center(child: Text("No Attendance!!"));
                  }
                },
              ),
            )),
      ),
    );
  }

  Widget cardClockIn(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Clock-In Total",
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Widget cardClockOut(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Clock-Out Total",
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Future<void> fetchPsychologicalMetricsAndSaveToIsar(Isar isar) async {
    print("PsychologicalMetrics here");
    try {
      // Fetch the document from Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('PsychologicalMetrics')
          .doc('PsychologicalMetrics')
          .get();

      print("PsychologicalMetrics docSnapshot == $docSnapshot");

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print("PsychologicalMetrics data == $data");

        if (data != null) {
          // Extract the arrays from Firestore, ensuring proper transformation
          final teamSpirit = (data['Team_Spirit'] as List<dynamic>? ?? [])
              .map((item) => Map<String, String>.from(item as Map))
              .toList();

          final attitudeToWork = (data['Attitude_to_work'] as List<dynamic>? ?? [])
              .map((item) => Map<String, String>.from(item as Map))
              .toList();

          print("PsychologicalMetrics teamSpirit == $teamSpirit");
          print("PsychologicalMetrics attitudeToWork == $attitudeToWork");

          // Prepare the data for Isar
          final psychologicalMetrics = PsychologicalMetricsModel()
            ..sections = [
              {'team_spirit': teamSpirit},
              {'attitude_to_work': attitudeToWork},
            ];

          // Save to Isar
          await isar.writeTxn(() async {
            await isar.psychologicalMetricsModels.put(psychologicalMetrics);
          });

          print('Data successfully saved to Isar!');
        }
      } else {
        print('Document does not exist!');
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }


  _checkForUpdates() async {
    try {
      Fluttertoast.showToast(
        msg: "Checking For updates..",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Ensure Isar is initialized
      final isar = Isar.getInstance();
      if (isar == null) {
        throw Exception("Isar instance is null!  Make sure it's opened.");
      }

      final firestore = FirebaseFirestore.instance;
      List<LastUpdateDateModel> getlastUpdateDate =
      await widget.service.getLastUpdateDate();

      List<BioModel> getAttendanceForBio =
      await IsarService().getBioInfoWithUserBio();

      QuerySnapshot snap = await firestore
          .collection("Staff")
          .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
          .get();

      final lastUpdateDateDoc = await firestore
          .collection('LastUpdateDate')
          .doc('LastUpdateDate')
          .get();

      final lastUpdateDatebio = await firestore
          .collection('Staff')
          .doc(snap.docs[0].id)
          .get();

      // Fetch all facility staff based on the same state and facility name
      QuerySnapshot allFacilityStaffs = await firestore
          .collection("Staff")
          .where('staffCategory', isEqualTo: 'Facility Staff')
         // .where('state', isEqualTo: state) // same state as current user
          //.where('location', isEqualTo: location) // same facility as current user
          .get();

      print("Number of documents in allFacilityStaffs: ${allFacilityStaffs.docs.length}");
      if (allFacilityStaffs.docs.isEmpty) {
        print("No documents found in allFacilityStaffs.");
      } else {
        print("allFacilityStaffs ==== $allFacilityStaffs");
      }

      await IsarService().cleanFacilityStaffListCollection();
      await IsarService().PsychologicalMetricsCollection().then((_) async {
        await fetchPsychologicalMetricsAndSaveToIsar(isar);
      });

      for (var doc in allFacilityStaffs.docs) {
        final staffData = doc.data() as Map<String, dynamic>?;  // Explicitly cast to Map<String, dynamic>
        if (staffData == null) {
          print("No staff data found.");
          return;  // Exit early if no staff data found
        }


        // Check if required fields are available before using them
        final lastName = staffData['lastName'];
        final firstName = staffData['firstName'];
        final state = staffData['state'];
        final location = staffData['location'];
        final id = staffData['id'];
        final designation = staffData['designation'];

        if (lastName == null || state == null || location == null || id == null || designation == null) {
          print("Missing required staff data.");
          continue; // Skip this iteration if any essential field is missing
        }

        final attendance = FacilityStaffModel()
          ..name = lastName+" "+firstName
          ..state = state
          ..facilityName = location
          ..userId = id
          ..designation = designation;

        await IsarService().saveFacilityStaffList(attendance);
      }



      if (lastUpdateDateDoc.exists) {
        final data = lastUpdateDateDoc.data();
        if (data != null && data.containsKey('LastUpdateDate')) {
          final timestamp = data['LastUpdateDate'] as Timestamp;
          final LastUpdateDate = timestamp.toDate();
          print("appVersionDate ====$LastUpdateDate");

          if (LastUpdateDate.isAfter(getlastUpdateDate[0].lastUpdateDate!) ||
              DateFormat('dd/MM/yyyy').format(LastUpdateDate) ==
                  DateFormat('dd/MM/yyyy').format(DateTime.now())) {
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
                              fetchDataAndInsertIntoIsar();
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
          } else {
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
        } else {
          print("Document does not contain 'LastUpdateDate' field.");
        }
      } else {
        print("Document 'LastUpdateDate' not found.");
      }

      if (lastUpdateDatebio.exists) {
        final data = lastUpdateDatebio.data();
        if (data != null && data.containsKey('lastUpdateDate')) {
          final timestamp = data['lastUpdateDate'] as Timestamp;
          final LastUpdateDate = timestamp.toDate();
          final isRemoteDelete = data['isRemoteDelete'];

          if (LastUpdateDate.isAfter(getlastUpdateDate[0].lastUpdateDate!) ||
              DateFormat('dd/MM/yyyy').format(LastUpdateDate) ==
                  DateFormat('dd/MM/yyyy').format(DateTime.now())) {
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
                              fetchDataAndInsertIntoIsar();
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
          } else {
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

          if (isRemoteDelete == true) {
            Fluttertoast.showToast(
              msg: "Deleting Facility Staff..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
           // await IsarService().deleteFacilityStaff(snap.docs[0].id);
            Fluttertoast.showToast(
              msg: "Deleting Facility Staff Completed..",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black54,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      }
    } catch (e) {
      print('Error during update process: $e');
      Fluttertoast.showToast(
        msg: "Error during update: $e",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }




  checkForIsSyncedForBio() async {

    try {

      List<BioModel> getisSyncedForBio =
      await widget.service.getisSyncedForBio();

      List<AppVersionModel> getAppVersion =
      await widget.service.getAppVersion();

      if (getisSyncedForBio[0].isSynced == null) {
        // Ensure the widget is mounted before trying to show a dialog
        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          // Prevent dismissing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Update Available'),
              content: Text(
                  "The upgrade to version ${getAppVersion[0].appVersion} has been successfully completed. Please click the 'Complete Upgrade' button to finalize all pending updates. Ensure a stable internet connection during this process. After the upgrade is complete, kindly navigate to your Profile page to update your Bio Information, including Staff Category, State, Facility, Department, Designation, Supervisor, and Supervisor's Email."),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    ProgressDialog(message: 'Completing Upgrade...',);

                    await updateBioData().then((_){
                      _checkForUpdates;
                    });


                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Complete Upgrade'),
                ),

                // TextButton(
                //   onPressed: () async {
                //     // Close the first dialog and proceed with update
                //     if (!mounted) return;
                //     //Navigator.of(context).pop(); // Close "Update Available" dialog
                //
                //     // Ensure the widget is still mounted before showing the next dialog
                //     // if (!mounted) return;
                //     // showDialog(
                //     //   context: context,
                //     //   barrierDismissible: false, // Prevent dismissing by tapping outside
                //     //   builder: (context) => WillPopScope( // Prevent dismissing using back button
                //     //     onWillPop: () async => false,
                //     //     child: AlertDialog(
                //     //       content: Column(
                //     //         mainAxisSize: MainAxisSize.min,
                //     //         children: [
                //     //           CircularProgressIndicator(),
                //     //           SizedBox(height: 16),
                //     //           Text('Completing Upgrade...'),
                //     //         ],
                //     //       ),
                //     //     ),
                //     //   ),
                //     // );
                //     ProgressDialog(message: 'Completing Upgrade...',);
                //
                //     // Perform the update check
                //     await updateBioData().then((_){
                //       _checkForUpdates;
                //     });
                //
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Complete Upgrade'),
                // ),


              ],


            );
          },
        );




      }




    } catch (e) {
      print("isSynced For Bio Collection Check Error: ${e.toString()}");
      // Fluttertoast.showToast(
      //   msg: "${e.toString()}",
      //   toastLength: Toast.LENGTH_SHORT,
      //   backgroundColor: Colors.black54,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    }
  }


  Future<void> updateBioData() async{
    List<BioModel> getAttendanceForBio =
    await widget.service.getBioInfoWithUserBio();


    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Staff")
        .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
        .get();

    await IsarService().updateBioDetails(2,BioModel(),true,snap.docs[0]['supervisor'],snap.docs[0]['supervisorEmail']);


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

  Future<void> _insertSuperUser() async {
    final bioInfoForSuperUser = await widget.service.getBioInfoForSuperUser();

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
        ..isRemoteDelete = false
        ..isSynced = false
      ..version = appVersionConstant
      ..supervisor = supervisorConstant
      ..supervisorEmail = supervisorEmailConstant
      ..lastUpdateDate = DateTime.now();





      await widget.service.saveBioData(bioData);
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

  void fetchDepartmentAndDesignationAndInsertIntoIsar(IsarService service) async {
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

  Future<void> fetchVersion(IsarService service) async {
    final getAppVersion = await service.getAppVersionInfo();
    versionNumber =  getAppVersion[0].appVersion;


  }



  void fetchDataAndInsertIntoIsar() async {
    final firestore = FirebaseFirestore.instance;
    final locationCollection = await firestore.collection('Location').get();

    for (final stateDoc in locationCollection.docs) {
      final state = stateDoc.id;
      //print("stateSnap====${state}");
      final stateSave = StateModel()..stateName = state;

      IsarService().saveState(stateSave);

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

        IsarService().saveLocation(locationSave);
      }
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

  // void fetchProjectAndInsertIntoIsar(IsarService service) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final projectCollection = await firestore.collection('Project').get();
  //
  //   for (final projectDoc in projectCollection.docs) {
  //     final project = projectDoc.id;
  //     //print("stateSnap====${state}");
  //     final projectSave = ProjectModel()..project = project;
  //
  //     service.saveProject(projectSave);
  //
  //
  //   }
  // }

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

  void fetchReasonsForDaysOffAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final reasonsForDaysOffCollection = await firestore.collection('ReasonsForDaysOff').get();

    for (final reasonsForDaysOffDoc in reasonsForDaysOffCollection.docs) {
      final reasonsForDaysOff = reasonsForDaysOffDoc.id;
      //print("stateSnap====${state}");
      final reasonsForDaysOffSave = ReasonForDaysOffModel()..reasonForDaysOff = reasonsForDaysOff;

      service.saveReasonForDaysOff(reasonsForDaysOffSave);

    }
  }

  void fetchStaffCategoryAndInsertIntoIsar(IsarService service) async {
    final firestore = FirebaseFirestore.instance;
    final staffCategoryCollection = await firestore.collection('StaffCategory').get();

    for (final staffCategoryDoc in staffCategoryCollection.docs) {
      final staffCategory = staffCategoryDoc.id;
      //print("stateSnap====${state}");
      final staffCategorySave = StaffCategoryModel()..staffCategory = staffCategory;

      service.saveStaffCategory(staffCategorySave);

    }
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
          color: isClose == true ? Colors.red : Colors.blue,
          border: Border.all(
            width: 2,
            color: Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
          //color: Colors.transparent,
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: "NexaBold")),
        ),
      ),
    );
  }

  _showBottomSheet2(BuildContext context) {
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
                const Spacer(),
                _bottomSheetButton(
                  label: "Local Backup",
                  onTap: () async {
                    // final feedback =
                    //     await widget.service.getSpecificFeedback(id);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ModifySheetsPage(feedback:feedback,)));
                    //_updateFeedback(context, id);
                    //_taskController.markTaskCompleted(task.id!);
                    //Navigator.of(context).pop();
                  },
                  clr: Colors.red,
                  context: context,
                ),
                _bottomSheetButton(
                  label: "Restore from Local DB",
                  onTap: () async {
                    // await widget.service.deleteFeedback(id);
                    // Navigator.of(context).pop();
                  },
                  clr: Colors.orange,
                  context: context,
                ),
                const SizedBox(
                  height: 20,
                ),
                _bottomSheetButton(
                  label: "Restore from Server",
                  onTap: () {
                    //Navigator.of(context).pop();
                  },
                  clr: Colors.red,
                  isClose: true,
                  context: context,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

//   Widget distributionTile(int value,String note){
//   return Container(
//     margin: EdgeInsets.all(8.0),
//     padding: EdgeInsets.all(18.0),
//     decoration: BoxDecoration(
//         //color: Get.isDarkMode?Colors.white:Colors.brown,
//       borderRadius: BorderRadius.circular(8.0),
//       gradient: LinearGradient( colors: [
//         Colors.orange,
//         Colors.red,
//       ],
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.arrow_circle_up_outlined,
//                 size: MediaQuery.of(context).size.width*0.07,
//                 color: Colors.red[700],
//             ),
//             SizedBox(width: 4.0,),
//             Text("Distribution",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.047,),),

//           ],
//         ),
//         Text("-$value",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05,fontWeight: FontWeight.w700),

//         ),
//       ],
//     ),
//   );
// }

// Widget receiptTile(int value,String note){
//   return Container(
//     margin: EdgeInsets.all(8.0),
//     padding: EdgeInsets.all(18.0),
//     decoration: BoxDecoration(
//       //color: Get.isDarkMode?Colors.white:Colors.brown,
//       borderRadius: BorderRadius.circular(8.0),
//       gradient: LinearGradient( colors: [
//         Colors.orange,
//         Colors.red,
//       ],
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.arrow_circle_down_outlined,
//               size: MediaQuery.of(context).size.width*0.07,
//               color: Colors.green[700],
//             ),
//             SizedBox(width: 4.0,),
//             Text("Receipt",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.047,),),

//           ],
//         ),
//         Text("+$value",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05,fontWeight: FontWeight.w700),

//         ),
//       ],
//     ),
//   );
// }
}
