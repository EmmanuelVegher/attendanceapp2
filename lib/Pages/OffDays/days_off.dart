import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/OffDays/days_off_manager.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/location_services.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/drawer3.dart';
import 'package:attendanceapp/widgets/geo_utils.dart';
import 'package:attendanceapp/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Attendance/clock_attendance.dart';

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

class DaysOffPage extends StatefulWidget {
  final IsarService service;
  const DaysOffPage({Key? key, required this.service}) : super(key: key);



  @override
  State<DaysOffPage> createState() => _DaysOffPageState();
}

class _DaysOffPageState extends State<DaysOffPage> {
  // final DaysOffController _taskController = Get.put(TaskController());
  final TextEditingController _commentsController = TextEditingController();
  final ClockAttendanceController controller =
  Get.put(ClockAttendanceController(IsarService()));

  DateTime _selectedDate = DateTime.now();
  String _endTime = "05:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _reasons = "";
  //Create String Location
  String location = "";
  var role;
  var longi = 0.0;
  var lati = 0.0;
  List<List<List<double>>> parsedCoordinates = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetail();

  }


  void _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    setState(() {
      role = userDetail?.role;
    });
  }

  Future<List<DropdownMenuItem<String>>> _fetchReasonsForDaysOffFromIsar() async {
    // Query Isar database for designations based on the selected department
    List<String?> reasonsForDaysOff = await IsarService().getReasonsForDaysOffFromIsar();

    // Convert the designations list to DropdownMenuItem list
    return reasonsForDaysOff.map((reasonsForDaysOff) => DropdownMenuItem<String>(
      value: reasonsForDaysOff,
      child: Text(reasonsForDaysOff!),
    )).toList();
  }

  // List<String> reasonsForDayOff = [
  //   "Holiday",
  //   "Annual Leave",
  //   "Sick Leave",
  //   "Other Leaves",
  //   "Absent",
  //   "Travel",
  //   "Remote Working",
  //   "Security Crisis",
  //   "Sit at Home",
  //   "Trainings"
  // ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = 0;
    double screenWidth = 0;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Out-Of-Office",
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
      drawer: Obx(
            () => controller.role.value == "User"
            ? drawer(context, IsarService())
            : drawer2(context, IsarService()),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Out Of Office?",
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 15,
                    fontWeight: FontWeight.bold),
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
              MyInputField(
                title: "Date",
                hint: DateFormat("dd/MM/yyyy").format(_selectedDate),
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
              FutureBuilder<List<DropdownMenuItem<String>>>(
                future: _fetchReasonsForDaysOffFromIsar(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                    // Check if facilityStateName is in the list of dropdown values
                    String? selectedReasons = snapshot.data!.any((item) => item.value == _reasons)
                        ? _reasons
                        : null;

                    // If there's no valid state selected, set the first item as the default
                    if (selectedReasons == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          //facilityStateName = snapshot.data!.first.value!;
                          // facilityStateName = "Select your state";
                        });
                      });
                    }

                    return MyInputField(
                      title: "Reasons For Days Off",
                      hint: "",
                      widget: Container(
                        width: MediaQuery.of(context).size.width*0.81,
                        //height: MediaQuery.of(context).size.height * 1,// Set your desired width
                        //color:Colors.red,
                        child: SizedBox(
                            child:SizedBox(
                                child:
                                DropdownButtonFormField<String>(

                                  decoration: InputDecoration(
                                    iconColor:Colors.blue,
                                    labelText: "",
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  value: selectedReasons,
                                  icon: Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
                                  dropdownColor: Colors.white,
                                  elevation: 4,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "NexaBold",
                                  ),
                                  items: snapshot.data!.map((item) => DropdownMenuItem<String>(
                                    value: item.value,
                                    child: Container( // Wrap the Text inside the DropdownMenuItem
                                      // width: MediaQuery.of(context).size.width * 0.66,
                                      //color: Colors.pink,// Adjust this width as needed
                                      child: Text(
                                        (item.child as Text).data!,
                                        softWrap: true,
                                      ),
                                    ),
                                  )).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _reasons = value!;
                                      //staffingCategory = value!;
                                      //disableddropdown = false;
                                    });
                                  },
                                  isExpanded: true,
                                ))),
                      ),
                    );

                  } else {
                    return const CircularProgressIndicator();
                  }
                },
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
                        _getTimeFromUser(isStartTime: false, setState: setState);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 12,
              ),

          TextField(
            controller: _commentsController,
            maxLines: 3, // Allow multiple lines
            decoration: InputDecoration(
              hintText: "Comments (If Any)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0), // More pronounced curve
                borderSide: BorderSide(color: Colors.grey), // Customize border color
              ), // Add a border
            ),),


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


  _validateData() {
    if (_reasons != "") {
      //Add to database by firstt sending it to the task controller that would then hand it to the task model and then to the database
      _addDaysOffToDb().then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AttendanceHomeScreen(
                      service: IsarService(),
                    )));
      });
    } else if (_reasons == "") {
      Get.snackbar("Required", "Reasons For Day Off is required !",
          colorText: Get.isDarkMode ? Colors.black : Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Get.isDarkMode ? Colors.black : Colors.white,
          ));
    }
  }

  _addDaysOffToDb() async {
    // _getLocation();
    final attendanceLast = await widget.service.getAttendanceForSpecificDate(
        DateFormat('dd-MMMM-yyyy').format(DateTime.now()));

    if (controller.lati.value == 0.0 && controller.longi.value == 0.0) {
      Fluttertoast.showToast(
          msg: "Error: Latitude and Longitude Not gotten...Kindly wait",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (attendanceLast.length == 0) {
      final attendnce = AttendanceModel()
        ..clockIn = _startTime
        ..date = DateFormat('dd-MMMM-yyyy').format(_selectedDate)
        ..clockInLatitude = controller.lati.value
        ..clockInLocation = controller.location.value
        ..clockInLongitude = controller.longi.value
        ..clockOut = _endTime
        ..clockOutLatitude = controller.lati.value
        ..clockOutLocation = controller.location.value
        ..clockOutLongitude = controller.longi.value
        ..isSynced = false
        ..voided = false
        ..isUpdated = true
        ..offDay = true
        ..durationWorked = _reasons
        ..noOfHours = _diffHoursWorked(_startTime, _endTime)
        ..comments = _commentsController.text.isEmpty ? 'No Comment' : _commentsController.text  // Check for empty string
        ..month = DateFormat('MMMM yyyy').format(_selectedDate);

      await widget.service.saveAttendance(attendnce);
    } else {
      Fluttertoast.showToast(
          msg: "Error: Attendance with same date already exist",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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



  // _getTimeFromUser({required bool isStartTime, required void Function(VoidCallback fn) setState}) async {
  //   var pickedTime = await _showTimePicker();
  //   if (pickedTime == null) {
  //     print("Time Canceled");
  //   } else {
  //     // Format the time in 12-hour AM/PM format
  //     String _formattedTime = pickedTime.format(context);
  //
  //     if (isStartTime) {
  //       setState(() {
  //         _startTime = _formattedTime;
  //       });
  //     } else {
  //       setState(() {
  //         _endTime = _formattedTime;
  //       });
  //     }
  //   }
  // }

  _getTimeFromUser({required bool isStartTime, required void Function(VoidCallback fn) setState}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      print("Time Canceled");
    } else {
      // Format the time in 12-hour AM/PM format
      String _formattedTime = DateFormat('hh:mm a').format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );

      if (isStartTime) {
        setState(() {
          _startTime = _formattedTime;
        });
      } else {
        setState(() {
          _endTime = _formattedTime;
        });
      }
    }
  }

// Helper function to display the time picker
  Future<TimeOfDay?> _showTimePicker() async {
    return await showTimePicker(
      context: context,
     initialTime: TimeOfDay.now(),
     //  initialTime: TimeOfDay(
     //      //_startTime --> 12:00 AM
     //      hour: int.parse(_startTime.split(":")[0]),
     //      minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
     //    ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false), // Set to false to use 12-hour format
          child: child!,
        );
      },
    );
  }


  _diffHoursWorked(String clockInTime, String clockOutTime) {
    var format = DateFormat("h:mm a");
    //var format = DateFormat("HH:mm");

    // Trim any leading or trailing whitespace from the input strings
    clockInTime = clockInTime.trim();
    clockOutTime = clockOutTime.trim();

    try{
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
    }catch(e){
      print("Error parsing time: $e");

    }


  }
}
