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

  DateTime _selectedDate = DateTime.now();
  String _endTime = "11:59 PM";
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
    // _startLocationService().then((value){
    //   //_startGeofencing();
    //   _geofencingIsolate1();
    // });

    _startGeofencing();

    //getCurrentDateRecordCount();
  }

  // // Start LOcation Service
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
  //

  //
  // void _startGeofencing() async {
  //   List<GeofenceModel> offices = getGeofenceOffices();
  //
  //   // Create a ReceivePort to receive messages from the isolate.
  //   final ReceivePort receivePort = ReceivePort();
  //
  //   // Spawn the isolate and send the ReceivePort to it.
  //   Isolate isolate = await Isolate.spawn(_geofencingIsolate, receivePort.sendPort);
  //
  //   // Receive the offices data from the main isolate.
  //   receivePort.listen((dynamic message) {
  //     if (message is List<GeofenceModel>) {
  //       // The isolate received the offices data.
  //       // Perform geofencing logic here.
  //       // Compare the location with geofence data.
  //       // Send results back to the main isolate if needed.
  //       // For example: message.send(result);
  //     }
  //   });
  //
  //   // Send the offices data to the isolate.
  //   isolate.send(offices);
  // }
  //
  // static void _geofencingIsolate(SendPort mainSendPort) {
  //   // Receive the ReceivePort from the main isolate.
  //   final ReceivePort receivePort = ReceivePort();
  //   mainSendPort.send(receivePort.sendPort);
  //
  //   // Receive the offices data from the main isolate.
  //   receivePort.listen((dynamic message) {
  //     if (message is List<GeofenceModel>) {
  //       // The isolate received the offices data.
  //       // Perform geofencing logic here.
  //       // Compare the location with geofence data.
  //       // Send results back to the main isolate if needed.
  //       mainSendPort.send(message);
  //     }
  //   });
  // }

  _startGeofencing() async {
    // Implement your geofencing logic here
    // Get the current location periodically and check if it is inside the geofence

    // Example: Get the current location every 10 seconds
    // const Duration interval = Duration(seconds: 10);
    //Timer.periodic(interval, (Timer timer) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    print(position);
    if (lati == 0.0) {
      setState(() {
        lati = position.latitude;
        print("Setlati======$lati");
      });
    }

    if (longi == 0.0) {
      setState(() {
        longi = position.longitude;
        print("Setlongi======$longi");
      });
    }

    // Check if the current position is inside the geofence
    List<GeofenceModel> offices = getGeofenceOffices();
    for (GeofenceModel office in offices) {
      // double distance = Geolocator.distanceBetween(
      //   office.latitude,
      //   office.longitude,
      //   position.latitude,
      //   position.longitude,
      //
      // );

      double distance =
          GeoUtils.haversine(lati, longi, office.latitude, office.longitude);
      //double distance = GeoUtils.calculateDistance(position.latitude,position.longitude, office.latitude, office.longitude);

      if (distance <= office.radius) {
        // Device is inside the geofence, perform geofencing actions for this office
        print('Entered office: ${office.name}');

        setState(() {
          location = office.name;
          print("location data === ${location}");
        });
        break;
      } else {
        // _getLocation(lati,longi);
        List<Placemark> placemark = await placemarkFromCoordinates(lati, longi);
        setState(() {
          location =
              "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
          print(location);
        });
      }
    }
    print(location);
  }

  //A function to get location using geocoding
  Future<void> _getLocation(double latitude, double longitude) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    setState(() {
      location =
          "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
      print(location);
    });
  }

  List<GeofenceModel> getGeofenceOffices() {
    // Implement this function to return a list of GeofenceModel objects for your offices
    // Example:
    List<GeofenceModel> offices = [
      GeofenceModel(
          name: 'Pengassan Estate, Phase One, Lokogoma',
          latitude: 8.9574134,
          longitude: 7.4721153,
          radius: 400),
      GeofenceModel(
          name: 'Catholic Secretariat Of Nigeria,Abuja',
          latitude: 9.0197734,
          longitude: 7.4734655,
          radius: 400),
      GeofenceModel(
          name: 'CARITAS Nigeria Office-Enugu',
          latitude: 6.4524674,
          longitude: 7.5218469,
          radius: 150),
      GeofenceModel(
          name: 'Asata Poly Sub District',
          latitude: 6.4427887,
          longitude: 7.5005692,
          radius: 150),
      GeofenceModel(
          name: 'Mother of Christ Specialist Hospital',
          latitude: 6.4345147,
          longitude: 7.4893711,
          radius: 160),
      GeofenceModel(
          name: 'Eastern Nigeria Medical Centre,Enugu',
          latitude: 6.4312265,
          longitude: 7.4896357,
          radius: 160),
      GeofenceModel(
          name: 'Uwani Cottage Hospital,Enugu',
          latitude: 6.4292375,
          longitude: 7.4917646,
          radius: 130),
      GeofenceModel(
          name: 'The Good Shepherd Specialist Hospital Uwani,Enugu',
          latitude: 6.4265629,
          longitude: 7.486832,
          radius: 230),
      GeofenceModel(
          name: 'Royal Hospital,Enugu',
          latitude: 6.4427566,
          longitude: 7.4799519,
          radius: 140),

      GeofenceModel(
          name: "Ntasi Obi Ndi No'Afufu Catholic Hospital,Enugu",
          latitude: 6.4771196,
          longitude: 7.501012,
          radius: 200),
      GeofenceModel(
          name: "Obolloafor Health Centre, Enugu",
          latitude: 6.9146421,
          longitude: 7.5194495,
          radius: 100),
      GeofenceModel(
          name: "Daughters of Divine Love, Enugu",
          latitude: 6.8022734,
          longitude: 7.4634361,
          radius: 130),
      GeofenceModel(
          name: "Faith Foundation Mission Hospital,Enugu",
          latitude: 6.8509808,
          longitude: 7.378974,
          radius: 170),
      GeofenceModel(
          name: "Chima Hospital Ugbaike, Enugu",
          latitude: 6.9626863,
          longitude: 7.5048304,
          radius: 100),
      GeofenceModel(
          name: "Nsukka Health center,Enugu",
          latitude: 6.8550867,
          longitude: 7.3885888,
          radius: 100),
      GeofenceModel(
          name: "Awgu General Hospital,Enugu",
          latitude: 6.082718,
          longitude: 7.4779434,
          radius: 200),
      GeofenceModel(
          name: "Annunciation Specialist Hospital,Enugu",
          latitude: 6.4678748,
          longitude: 7.5899575,
          radius: 160),
      // Add more office coordinates
    ];
    return offices;
  }

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
                "Out Of Office?",
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 15,
                    fontWeight: FontWeight.bold),
              ),
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
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
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

  _startGeofencing1(SendPort sendPort) async {
    var locationName = "";
    // Implement your geofencing logic here
    // Get the current location periodically and check if it is inside the geofence

    // Example: Get the current location every 10 seconds
    // const Duration interval = Duration(seconds: 10);
    //Timer.periodic(interval, (Timer timer) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    print(position);
    if (lati == 0.0) {
      setState(() {
        lati = position.latitude;
        print("Setlati======$lati");
      });
    }

    if (longi == 0.0) {
      setState(() {
        longi = position.longitude;
        print("Setlongi======$longi");
      });
    }

    // Check if the current position is inside the geofence
    List<GeofenceModel> offices = getGeofenceOffices();
    for (GeofenceModel office in offices) {
      // double distance = Geolocator.distanceBetween(
      //   office.latitude,
      //   office.longitude,
      //   position.latitude,
      //   position.longitude,
      //
      // );

      double distance =
          GeoUtils.haversine(lati, longi, office.latitude, office.longitude);
      //double distance = GeoUtils.calculateDistance(position.latitude,position.longitude, office.latitude, office.longitude);

      if (distance <= office.radius) {
        // Device is inside the geofence, perform geofencing actions for this office
        print('Entered office: ${office.name}');
        locationName = office.name;
        // setState(() {
        //   locationName = office.name;
        //   print("location data === ${locationName}");
        // });
        break;
      } else {
        locationName = _getLocation(lati, longi) as String;
      }
    }
    sendPort.send(locationName);
  }

  _geofencingIsolate1() async {
    final receivePort = ReceivePort();
    //Create the Isolate
    await Isolate.spawn(_startGeofencing1, receivePort.sendPort);
    receivePort.listen((locationName) {
      debugPrint('Result 2 : $locationName');
    });
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

    if (lati == 0.0 && longi == 0.0) {
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
        ..clockInLatitude = lati
        ..clockInLocation = location
        ..clockInLongitude = longi
        ..clockOut = _endTime
        ..clockOutLatitude = lati
        ..clockOutLocation = location
        ..clockOutLongitude = longi
        ..isSynced = false
        ..voided = false
        ..isUpdated = true
        ..offDay = true
        ..durationWorked = _reasons
        ..noOfHours = _diffHoursWorked(_startTime, _endTime)
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
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
        ));
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
