import 'dart:developer';

import 'package:attendanceapp/Pages/Attendance/attendance_local_db.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/drawer3.dart';
import 'package:attendanceapp/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateAttendance extends StatefulWidget {
  final AttendanceModel? attendanceUpdate;
  final int passedId;
  final IsarService service;
  const UpdateAttendance(
      {Key? key,
      required this.service,
      this.attendanceUpdate,
      required this.passedId})
      : super(key: key);

  @override
  State<UpdateAttendance> createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  // final DaysOffController _taskController = Get.put(TaskController());

  DateTime selectedDate = DateTime.now();
  String endTime = "11:59 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  // String _reasons = "";
  //Create String Location
  String location = "";
  var role;
  var longi;
  var lati;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetail();
    _getDataForUpdate();
    _getLocation();
    _startLocationService();

    //getCurrentDateRecordCount();
  }

  @override
  void didUpdateWidget(covariant UpdateAttendance oldWidget) {
    super.didUpdateWidget(oldWidget);

    _getDataForUpdate();
  }

  _getDataForUpdate() async {
    final dataForUpdate =
        await IsarService().getSpecificAttendance(widget.passedId);

    var newDate = dataForUpdate!.date.toString();
    if (newDate.contains("-January-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-January-", "/01/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-February-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-February-", "/02/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-March-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-March-", "/03/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-April-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-April-", "/04/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-May-")) {
      setState(() {
        selectedDate =
            DateFormat('dd/MM/yyyy').parse(newDate.replaceAll("-May-", "/05/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-June-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-June-", "/06/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-July-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-July-", "/07/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-August-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-August-", "/08/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-September-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-September-", "/09/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-October-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-October-", "/10/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-November-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-November-", "/11/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    } else if (newDate.contains("-December-")) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy')
            .parse(newDate.replaceAll("-December-", "/12/"));
        startTime = dataForUpdate.clockIn.toString();
      });
    }

    // setState(() {
    //   selectedDate =
    //       DateFormat('dd/MM/yyyy').parse(dataForUpdate!.date.toString());
    // });
  }

  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      role = userDetail?.role;
    });
  }

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
  // Future<int> getCurrentDateRecordCount() async {
  //   final attendanceLast = await widget.service.getAttendanceForSpecificDate(
  //       DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
  //   //print("attendanceLastLength ===${attendanceLast.length}");

  //   return attendanceLast.length;
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 0;
    double screenWidth = 0;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Attendance",
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
          Container(
            margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
            child: Stack(
              children: <Widget>[
                Image.asset("./assets/image/ccfn_logo.png"),
              ],
            ),
          )
        ],
      ),
      drawer: role == "User"
          ? drawer(this.context, IsarService())
          : role == "Admin"
              ? drawer2(this.context, IsarService())
              : drawer3(this.context, IsarService()),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Attendance",
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 15,
                    fontWeight: FontWeight.bold),
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat("dd/MM/yyyy").format(selectedDate),
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
              // MyInputField(
              //   title: "Reasons For Day off",
              //   hint: _reasons,
              //   widget: DropdownButton(
              //     icon: Icon(
              //       Icons.keyboard_arrow_down,
              //       color: Colors.grey,
              //     ),
              //     iconSize: 32,
              //     elevation: 4,
              //     style: TextStyle(
              //         color: Get.isDarkMode ? Colors.white : Colors.black,
              //         fontSize: screenWidth / 25,
              //         fontFamily: "NexaBold"),
              //     underline: Container(
              //       height: 0,
              //     ),
              //     items: reasonsForDayOff.map<DropdownMenuItem<String>>(
              //       (String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(
              //             value,
              //             style: TextStyle(
              //                 color:
              //                     Get.isDarkMode ? Colors.white : Colors.black,
              //                 fontSize: screenWidth / 25,
              //                 fontFamily: "NexaBold"),
              //           ),
              //         );
              //       },
              //     ).toList(),
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         _reasons = newValue!;
              //       });
              //     },
              //   ),
              // ),

              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Clock-In Time",
                    hint: startTime,
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
                    title: "Clock-Out Time",
                    hint: endTime,
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
                            color: Get.isDarkMode ? Colors.white : Colors.black,
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
                    onTap: () => _updateData(),
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
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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
      ),
    );
  }

  _updateData() {
    //if (_reasons != "") {
    //Add to database by firstt sending it to the task controller that would then hand it to the task model and then to the database
    _updateAttendanceToDB().then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AttendanceLocalDB(
                    service: IsarService(),
                  )));
    });
    // } else if (_reasons == "") {
    //   Get.snackbar("Required", "Reasons For Day Off is required !",
    //       colorText: Get.isDarkMode ? Colors.black : Colors.white,
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
    //       icon: Icon(
    //         Icons.warning_amber_rounded,
    //         color: Get.isDarkMode ? Colors.black : Colors.white,
    //       ));
    // }
  }

  _updateAttendanceToDB() async {
    _startLocationService().then((value) {
      widget.service.updateClockOut(
          widget.passedId,
          AttendanceModel(),
          endTime,
          lati,
          location,
          longi,
          _diffClockInOut(startTime, endTime),
          _diffHoursWorked(startTime, endTime));
    });
  }

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

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2090),
    );

    if (_pickerDate != null) {
      setState(() {
        selectedDate = _pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time Canceled");
    } else if (isStartTime == true) {
      setState(() {
        startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          //startTime --> 12:00 AM
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split(" ")[0]),
        ));
  }

   
  //A function to get location using geocoding
  Future<void> _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(UserModel.lat, UserModel.long);

    setState(() {
      location =
          "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    });
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
}

_startLocationService() {
}
