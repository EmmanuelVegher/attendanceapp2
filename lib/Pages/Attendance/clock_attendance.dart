import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as locationPkg;
import 'package:attendanceapp/Pages/Attendance/attendance_home.dart';
import 'package:attendanceapp/Pages/auth_exceptions.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/model/bio_model.dart';
import 'package:attendanceapp/model/locationmodel.dart';
import 'package:attendanceapp/model/statemodel.dart';
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart'; // Use location package for location updates
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path/path.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../Pages/Dashboard/admin_dashboard.dart';
import '../../Pages/Dashboard/user_dashboard.dart';
import '../../model/attendance.dart';
import '../../model/user_model.dart';
import '../../services/location_services.dart';
import '../../widgets/drawer.dart';
import '../../widgets/drawer2.dart';
import '../../widgets/geo_utils.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/input_field.dart';
import '../../widgets/show_error_dialog.dart';
import '../OffDays/days_off.dart';
import '../OffDays/update_attendance.dart';
import 'button.dart';

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

  ClockAttendance(IsarService isarService, {Key? key, required this.service, required controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController commentsController = TextEditingController();

    final ClockAttendanceController controller =
    Get.put(ClockAttendanceController(service)); // Initialize the controller here

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

              StreamBuilder<List<BioModel>>(
                stream: IsarService().watchBioInfoWithFirebaseAuth(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final bioModelList = snapshot.data!;
                    if (bioModelList.isNotEmpty) {
                      final bioInfo = bioModelList.first;
                      return
                        //Text('${bioInfo.firstName} ${bioInfo.lastName}');
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${bioInfo.firstName.toString().toUpperCase()} ${bioInfo.lastName.toString().toUpperCase()}",
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      );
                    } else {
                      return const Text('No BioModel found');
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
        //       Obx(
        //             () =>
        // Container(
        //           alignment: Alignment.centerLeft,
        //           child: Text(
        //             "${controller.firstName.value.toString().toUpperCase()} ${controller.lastName.value.toString().toUpperCase()}",
        //             style: TextStyle(
        //               color: Colors.black54,
        //               fontFamily: "NexaBold",
        //               fontSize: screenWidth / 18,
        //             ),
        //           ),
        //         ),
        //       ),

              // StreamBuilder<String>(
              //   stream: controller.fullNameStream,
              //  // stream: IsarService().getBioInfoWithFirebaseAuth();
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Container(
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           snapshot.data!.toUpperCase(),
              //           style: TextStyle(
              //             color: Colors.black54,
              //             fontFamily: "NexaBold",
              //             fontSize: screenWidth / 18,
              //           ),
              //         ),
              //       );
              //     } else {
              //       return Container(
              //         alignment: Alignment.centerLeft,
              //         child: const Text(
              //           "No Name", // Default value while waiting for data
              //           style: TextStyle(
              //             color: Colors.black54,
              //             fontFamily: "NexaBold",
              //             fontSize: 20,
              //           ),
              //         ),
              //       );
              //     }
              //   },
              // ),
              // Obx(
              //    ,  () =>

              ,Container(
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
                    Obx(() => controller.lati.value != 0.0?
                        Text(
                      "Current Latitude: ${controller.lati.value.toStringAsFixed(6)}, Current Longitude: ${controller.longi.value.toStringAsFixed(6)}",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 23,
                      ),
                    ):CircularProgressIndicator()
                    ),
                    SizedBox(height: 10),
                    Obx(() => controller.administrativeArea.value != ""?
                        Text(
                      "Current State: ${controller.administrativeArea.value}",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 23,
                      ),
                    ):CircularProgressIndicator()
                    ),
                    SizedBox(height: 10),
                    Obx(() => controller.location.value != ""?
                        Text(
                      "Current Location: ${controller.location.value}",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 23,
                      ),
                    ):CircularProgressIndicator()
                    ),
                    // You can add your location name widget here, using Obx to make it reactive
                  ],
                ),
              ),
              //),
              //Card View for ClockIn and ClockOut
              //   Obx(
              //        () =>

              Container(
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

                          // Obx(() => Text(
                          //   controller.clockIn.value,
                          //   style: TextStyle(
                          //     fontFamily: "NexaBold",
                          //     fontSize: screenWidth / 18,
                          //   ),
                          // )),
                          StreamBuilder<String>(
                            stream: controller.clockInStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                    fontFamily: "NexaBold",
                                    fontSize: screenWidth / 18,
                                  ),
                                );
                              } else {
                                return const Text("--/--"); // Default value while waiting for data
                              }
                            },
                          ),

                          // Wrap clockIn in Obx
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

                          // Obx(() => Text(
                          //   controller.clockOut.value,
                          //   style: TextStyle(
                          //     fontFamily: "NexaBold",
                          //     fontSize: screenWidth / 18,
                          //   ),
                          // )),
                          StreamBuilder<String>(
                            stream: controller.clockOutStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                    fontFamily: "NexaBold",
                                    fontSize: screenWidth / 18,
                                  ),
                                );
                              } else {
                                return const Text("--/--"); // Default value while waiting for data
                              }
                            },
                          ),
                          // Wrap clockOut in Obx
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ),
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
              StreamBuilder<AttendanceModel?>(
                stream: IsarService().watchLastAttendance(DateFormat('MMMM yyyy').format(DateTime.now())),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading indicator while waiting
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Show an error message if there's an error
                  } else if (snapshot.hasData) {
                    final lastAttendance = snapshot.data;
                    print("lastAttendance?.dateeeeee===${lastAttendance?.date}");
                    if (lastAttendance?.date == DateFormat('dd-MMMM-yyyy').format(DateTime.now()) && lastAttendance?.clockIn == "--/--" && lastAttendance?.clockOut == "--/--") {
                      return Container(child:
                        Column(
                        children:[

                      Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Builder(
                  builder: (context) {
                  final GlobalKey<SlideActionState> key = GlobalKey();
                  return SlideAction(
                  text: "Slide to Clock In",
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

                          StreamBuilder<String>(
                                                                stream: controller.clockInStream,
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    return SizedBox.shrink();
                                                                  } else {
                                                                    return MyButton(
                                                                      label: "Out Of Office? CLICK HERE",
                                                                      onTap: () {
                                                                        //controller.showBottomSheet3(context);
                                                                        Get.off(() => DaysOffPage(service: service));
                                                                      },
                                                                    ); // Default value while waiting for data
                                                                  }
                                                                },
                                                              ),

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
                                                        StreamBuilder<AttendanceModel?>(
                                                          stream: IsarService().watchLastAttendance(DateFormat('MMMM').format(DateTime.now())),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.hasData && snapshot.data != null) {
                                                              final attendance = snapshot.data!;
                                                              return Text(
                                                                attendance.toString(), // Assuming you have overridden the 'toString' method in AttendanceModel
                                                                style: TextStyle(
                                                                  fontFamily: "NexaBold",
                                                                  fontSize: screenWidth / 35,
                                                                  color: Colors.white,
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text(""); // Default value while waiting for data
                                                            }
                                                          },
                                                        )
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
                                                            fontSize: screenWidth / 35,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        StreamBuilder<String>(
                                                          stream: controller.clockOutLocationStream,
                                                          builder: (context, snapshot) {
                                                            if (snapshot.hasData) {
                                                              return Text(
                                                                snapshot.data!,
                                                                style: TextStyle(
                                                                  fontFamily: "NexaBold",
                                                                  fontSize: screenWidth / 35,
                                                                  color: Colors.white,
                                                                ),
                                                              );
                                                            } else {
                                                              return const Text("--/--"); // Default value while waiting for data
                                                            }
                                                          },
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
                                ));// Default value while waiting for data

                    }
                    else if (lastAttendance?.date == DateFormat('dd-MMMM-yyyy').format(DateTime.now()) && lastAttendance?.clockIn != "--/--" && lastAttendance?.clockOut == "--/--"){
                      return Column(children:[
                        Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> key = GlobalKey();
                            return SlideAction(
                              text: "Slide to Clock Out",
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
                                                            "${controller.clockInLocation.value}",
                                                            style: TextStyle(
                                                              fontFamily: "NexaLight",
                                                              fontSize: screenWidth / 35,
                                                              color: Colors.white,
                                                            ),
                                                          ),)

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
                                                fontSize: screenWidth / 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            const SizedBox(height: 5),
                                            Obx(
                                                  () => Text(
                                                "${controller.clockOutLocation.value}",
                                                style: TextStyle(
                                                  fontFamily: "NexaLight",
                                                  fontSize: screenWidth / 35,
                                                  color: Colors.white,
                                                ),
                                              ),)
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
                      ]);
                  }
                    else if (lastAttendance?.date == DateFormat('dd-MMMM-yyyy').format(DateTime.now()) && lastAttendance?.clockIn != "--/--" && lastAttendance?.clockOut != "--/--"){
                      return
                        Container(
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
                            const SizedBox(
                              height: 12,
                            ),
                            Obx(
                                  () => Text(
                                    "Comment(s): ${controller.comments.value}",
                                    style: TextStyle(
                                      fontFamily: "NexaLight",
                                      fontSize: screenWidth / 21,
                                      color: Colors.black54,
                                    ),
                                  ),
                            ),

                            const SizedBox(height: 8.0),
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
                                                    fontSize: screenWidth / 27,
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
                                                    fontSize: screenWidth / 27,
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
                      );
                    }
                    else if (lastAttendance?.date != DateFormat('dd-MMMM-yyyy').format(DateTime.now()) ){
                      return Column( children:[
                        Container(
                          margin: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> key = GlobalKey();
                              return SlideAction(
                                text:"Slide to Clock In",
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

                        StreamBuilder<String>(
                          stream: controller.clockInStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox.shrink();
                            } else {
                              return MyButton(
                                label: "Out Of Office? CLICK HERE",
                                onTap: () {
                                  //controller.showBottomSheet3(context);
                                  Get.off(() => DaysOffPage(service: service));
                                },
                              ); // Default value while waiting for data
                            }
                          },
                        ),

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
                                            StreamBuilder<AttendanceModel?>(
                                              stream: IsarService().watchLastAttendance(DateFormat('MMMM').format(DateTime.now())),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData && snapshot.data != null) {
                                                  final attendance = snapshot.data!;
                                                  return Text(
                                                    attendance.clockInLocation!, // Assuming you have overridden the 'toString' method in AttendanceModel
                                                    style: TextStyle(
                                                      fontFamily: "NexaBold",
                                                      fontSize: screenWidth / 35,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                } else {
                                                  return const Text(""); // Default value while waiting for data
                                                }
                                              },
                                            )
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
                                                fontSize: screenWidth / 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            StreamBuilder<String>(
                                              stream: controller.clockOutLocationStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    snapshot.data!,
                                                    style: TextStyle(
                                                      fontFamily: "NexaBold",
                                                      fontSize: screenWidth / 35,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                } else {
                                                  return const Text("--/--"); // Default value while waiting for data
                                                }
                                              },
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
                      ]);
                    }
                    else {
                      return SizedBox.shrink();

                    }

                  } else {
                    return Column( children:[
                      Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> key = GlobalKey();
                            return SlideAction(
                              text:"Slide to Clock In",
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

                      StreamBuilder<String>(
                        stream: controller.clockInStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox.shrink();
                          } else {
                            return MyButton(
                              label: "Out Of Office? CLICK HERE",
                              onTap: () {
                                //controller.showBottomSheet3(context);
                                Get.off(() => DaysOffPage(service: service));
                              },
                            ); // Default value while waiting for data
                          }
                        },
                      ),

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
                                          StreamBuilder<AttendanceModel?>(
                                            stream: IsarService().watchLastAttendance(DateFormat('MMMM').format(DateTime.now())),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData && snapshot.data != null) {
                                                final attendance = snapshot.data!;
                                                return Text(
                                                  attendance.clockInLocation!, // Assuming you have overridden the 'toString' method in AttendanceModel
                                                  style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 35,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else {
                                                return const Text(""); // Default value while waiting for data
                                              }
                                            },
                                          )
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
                                              fontSize: screenWidth / 35,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          StreamBuilder<String>(
                                            stream: controller.clockOutLocationStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  snapshot.data!,
                                                  style: TextStyle(
                                                    fontFamily: "NexaBold",
                                                    fontSize: screenWidth / 35,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else {
                                                return const Text("--/--"); // Default value while waiting for data
                                              }
                                            },
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
                    ]);// Show a message if no data is found
                  }
                },
              ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                controller.clockOut.value  != "--/--"?TextField(
                  controller: commentsController,
                  maxLines: 3, // Allow multiple lines
                  decoration: InputDecoration(
                    hintText: "Comments (If Any)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // More pronounced curve
                      borderSide: BorderSide(color: Colors.grey), // Customize border color
                    ), // Add a border
                  ),): SizedBox.shrink(),
                controller.comments.value == "No Comment"?const SizedBox(height:10):const SizedBox(height:0),
                controller.clockOut.value  != "--/--"?
                GestureDetector(
                  onTap: () => handleAddComments(context,commentsController.text),
                  child: Container(
                    width: screenWidth * 0.40,
                    height: screenHeight * 0.05,
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
                        "Add Comment",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ):const SizedBox(height:0),
              ],
            ),
          ),


            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleAddComments(
      BuildContext context,String? commentsForAttendance) async {


    try {
      final lastAttend = await service.getLastAttendance(
          DateFormat("MMMM yyyy").format(DateTime.now()).toString());

        if (lastAttend?.date == DateFormat('dd-MMMM-yyyy').format(DateTime.now())) {
        // Clock Out
        List<AttendanceModel> attendanceResult = await service
            .getAttendanceForDate(
            DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
        final bioInfoForUser = await service.getBioInfoWithFirebaseAuth();

        await addComments(attendanceResult[0].id, bioInfoForUser,attendanceResult,commentsForAttendance!);
      }
    } catch (e) {
      log("Attendance Comment Error ====== ${e.toString()}");

    }

  }


  Future<void> addComments(
      int attendanceId,
      BioModel? bioInfoForUser,
      List<AttendanceModel> attendanceResult,
      String commentsForAttendance
      ) async {



    if(commentsForAttendance != null) {

      await service.updateAttendanceWithComment(
          attendanceId,
          AttendanceModel(),
          commentsForAttendance
      );
      Fluttertoast.showToast(
        msg: "Adding Comments..",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.off(() =>
      bioInfoForUser!.role == "User"
          ? UserDashBoard(service: service)
          : AdminDashBoard(service: service));
    } else{
      Fluttertoast.showToast(
        msg: "Comments Box Cannot be empty..",
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

// ClockAttendanceController (clock_attendance_controller.dart)
class ClockAttendanceController extends GetxController {
  final IsarService service;

  ClockAttendanceController(this.service) {
    _init();
  }

  // Method to refresh the ClockAttendance data
  Future<void> refreshClockAttendance() async {

    await _getAttendanceSummary();
    await _getUserDetail();
    await _startLocationService();

  }

  var isCircularProgressBarOn = true.obs; // Observable boolean

  var _clockInStreamController = StreamController<String>.broadcast();
  Stream<String> get clockInStream => _clockInStreamController.stream;

  var _clockOutStreamController = StreamController<String>.broadcast();
  Stream<String> get clockOutStream => _clockOutStreamController.stream;

  var _clockInLocationStreamController = StreamController<String>.broadcast();
  Stream<String> get clockInLocationStream => _clockInLocationStreamController.stream;

  var _clockOutLocationStreamController = StreamController<String>.broadcast();
  Stream<String> get clockOutLocationStream => _clockOutLocationStreamController.stream;

  // Create a stream for full name
  var _fullNameStreamController = StreamController<String>.broadcast();
  Stream<String> get fullNameStream => _fullNameStreamController.stream;

  RxString clockIn = "--/--".obs;
  RxString clockOut = "--/--".obs;
  RxString durationWorked = "".obs;
  RxString location = "".obs;
  RxString comments = "No Comment".obs;
  RxString clockInLocation = "".obs;
  RxString clockOutLocation = "".obs;
  RxString role = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString emailAddress = "".obs;
  RxString firebaseAuthId = "".obs;
  RxDouble lati = 0.0.obs;
  RxDouble longi = 0.0.obs;
  RxString administrativeArea = "".obs; // Added for state name
  RxBool isLocationTurnedOn = false.obs;
  Rx<LocationPermission> isLocationPermissionGranted =
      LocationPermission.denied.obs;
  RxBool isAlertSet = false.obs;
  RxBool isAlertSet2 = false.obs;
  RxBool isInsideAnyGeofence = false.obs;
  RxBool isInternetConnected = false.obs;

  String currentDate = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
  DateTime ntpTime = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "11:59 PM";
  String _startTime =
  DateFormat("hh:mm a").format(DateTime.now()).toString();
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
    "Remote Working",
    "Security Crisis"
  ];

 // Timer? _locationTimer;
  locationPkg.Location locationService = locationPkg.Location();
  // LocationService locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    //_locationTimer?.cancel();
   //_startLocationService().cancel();
    _clockInStreamController.close();
    _clockOutStreamController.close();
    _clockInLocationStreamController.close();
    _clockOutLocationStreamController.close();
    _fullNameStreamController.close();
    super.onClose();
  }

  void _init() async {
    //await checkGeofence();
    await _loadNTPTime();
    await _getAttendanceSummary();
    await _getUserDetail();

    await getLocationStatus().then((_) async {
      await getPermissionStatus().then((_) async {
        await _startLocationService();
      });
    });

    await checkInternetConnection();

    // // Start the periodic location updates
    // _locationTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //  // _startLocationService();
    //   // _init();
    // });
  }

  Future<void> _loadNTPTime() async {
    try {
      ntpTime = await NTP.now(lookUpAddress: "pool.ntp.org");
    } catch (e) {
      log("Error getting NTP time: ${e.toString()}");
      // Handle the error - you might want to use the local time as a fallback
      ntpTime = DateTime.now();
    }
  }

  Future<void> _getUserDetail() async {
    final userDetail = await IsarService().getBioInfoWithFirebaseAuth();
    if (!isClosed) {  // Check if the controller is still active
      firebaseAuthId.value = userDetail?.firebaseAuthId ?? "";
      firstName.value = userDetail?.firstName ?? "";
      lastName.value = userDetail?.lastName ?? "";
      emailAddress.value = userDetail?.emailAddress ?? "";
      role.value = userDetail?.role ?? "";
      // Update the full name stream
      _fullNameStreamController.add("${userDetail?.firstName ?? ""} ${userDetail?.lastName ?? ""}");
    }
  }

  Future<void> _getAttendanceSummary() async {
    try {
      final attendanceLast =
      await service.getLastAttendance(
          DateFormat('MMMM yyyy').format(DateTime.now()));
      final attendanceResult = await service.getAttendanceForDate(
          DateFormat('dd-MMMM-yyyy').format(DateTime.now()));

      if (attendanceLast?.date == currentDate) {
        clockIn.value = attendanceLast?.clockIn ?? "--/--";
        clockOut.value = attendanceLast?.clockOut ?? "--/--";
        clockInLocation.value =
            attendanceLast?.clockInLocation ?? "";
        clockOutLocation.value =
            attendanceLast?.clockOutLocation ?? "";
        durationWorked.value = attendanceLast?.durationWorked ?? "";
        comments.value = attendanceLast?.comments ?? "No Comment";
        _clockInStreamController.add(clockIn.value);
        _clockOutStreamController.add(clockOut.value);
        _clockInLocationStreamController.add(clockInLocation.value);
        _clockOutLocationStreamController.add(clockOutLocation.value);
      } else {
        clockIn.value = attendanceResult[0].clockIn ?? "--/--";
        clockOut.value = attendanceResult[0].clockOut ?? "--/--";
        clockInLocation.value =
            attendanceResult[0].clockInLocation ?? "";
        clockOutLocation.value =
            attendanceResult[0].clockOutLocation ?? "";
        durationWorked.value = attendanceResult[0].durationWorked ?? "";
        comments.value = attendanceResult[0].comments ?? "No Comment";
        _clockInStreamController.add(clockIn.value);
        _clockOutStreamController.add(clockOut.value);
        _clockInLocationStreamController.add(clockInLocation.value);
        _clockOutLocationStreamController.add(clockOutLocation.value);
      }
    } catch (e) {
      if (e.toString() ==
          "RangeError (index): Invalid value: Valid value range is empty: 0") {
        log(
            "getAttendance Summary method error ====== Staff Yet to clock in as Last saved date != Current Date");
      } else {
        log(e.toString());
      }
    }
  }

  // Start Location Service (Using location package)
  Future<void> _startLocationService() async {
    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permission = await locationService.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locationService.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    // Use a FutureBuilder to manage the asynchronous location fetching
    _getLocation2().then((_) { // Call _getLocation and wait for it to complete
      // Now that the location is obtained, update the UI using Obx
      lati.refresh(); // Force a refresh of the Obx variable
      longi.refresh();
      administrativeArea.refresh();
      location.refresh();
    });

  }



  Future<void> _getLocation2() async {
print("_getLocation2 hereeeee");
    // Check for internet connection
    isInternetConnected.value = await InternetConnectionChecker().hasConnection;

    if (!isInternetConnected.value) {
      // Use Geolocator and request location updates using GPS
      try {
        print("There is nooooooo internet to get location data");
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.best,
          forceAndroidLocationManager: true, // Important for Android
        );

        Position? position1 = await Geolocator.getLastKnownPosition();

        if (position != null) {

          lati.value = position.latitude;
          longi.value = position.longitude;
          print("locationData.latitude == ${position.latitude}");
          _updateLocation();
        } else if (position1 != null){
          // Store the latitude and longitude (e.g., in shared preferences, database, etc.)
          print('Cached Latitude: ${position.latitude}');
          print('Cached Longitude: ${position.longitude}');
          lati.value = position1.latitude;
          longi.value = position1.longitude;
          _updateLocation();
        }
        else {
          print('No last known location available.');
        }




        // locationService.onLocationChanged.listen((LocationData locationData) {
        //   lati.value = locationData.latitude!;
        //   longi.value = locationData.longitude!;
        //   print("locationData.latitude == ${locationData.latitude}");
        //   _updateLocation();
        //   _getAttendanceSummary();
        // });
      } catch (e) {
        log("Error getting GPS location: ${e.toString()}");
        Fluttertoast.showToast(
          msg:
          "Error getting GPS location.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // Continue using location package for updates
      print("There is internet to get location data");
      locationService.onLocationChanged.listen((LocationData locationData) {
        lati.value = locationData.latitude!;
        longi.value = locationData.longitude!;
       // print("locationData.latitude! == ${locationData.latitude!}");
        //print("locationData.longitude! == ${locationData.longitude!}");
        _updateLocation();
        _getAttendanceSummary();
      });
    }
  }

  Future<void> _updateLocation() async {
    // Update location based on new latitude and longitude
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lati.value,
      longi.value,
    );

   // print("placemarksssssss==$placemarks");

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      location.value =
      "${placemark.street},${placemark.subLocality},${placemark.subAdministrativeArea},${placemark.locality},${placemark.administrativeArea},${placemark.postalCode},${placemark.country}";
      administrativeArea.value = placemark.administrativeArea!; // Update state name

      print("location.valuesssss==${location.value}");
      print("placemark.administrativeArea==${placemark.administrativeArea}");
      print("administrativeArea.value ==${administrativeArea.value}");

    } else {
      location.value = "Location not found";
      administrativeArea.value = "";
    }

    // Geofencing logic
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

      print("Officessss == ${offices}");

      isInsideAnyGeofence.value = false;
      for (GeofenceModel office in offices) {
        double distance = GeoUtils.haversine(
          lati.value, longi.value,office.latitude, office.longitude);

        if (distance <= office.radius) {
          print('Entered office: ${office.name}');

          location.value = office.name;
          isInsideAnyGeofence.value = true;
          isCircularProgressBarOn.value = false; // Update observable value
          break;
        }
      }

      if (!isInsideAnyGeofence.value) {
        List<Placemark> placemark = await placemarkFromCoordinates(
            lati.value, longi.value);

        location.value =
        "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

        print("Location from map === ${location.value}");
        isCircularProgressBarOn.value = false; // Update observable value
      }
    } else {
      List<Placemark> placemark = await placemarkFromCoordinates(
          lati.value, longi.value);

      location.value =
      "${placemark[0].street},${placemark[0].subLocality},${placemark[0].subAdministrativeArea},${placemark[0].locality},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";

      print("Unable to get administrative area. Using default location.");
      isCircularProgressBarOn.value = false; // Update observable value
    }
  }

  //
  // Future<void> checkGeofence() async {
  //   List<LocationModel> isarLocations = await service.getAllLocations();
  //   print("All Isar Locations: ${isarLocations.map((loc) => loc.locationName)}");
  //
  //   try{}catch(e){};
  //
  //   List<GeofenceModel> offices = isarLocations.map((location) => GeofenceModel(
  //     name: location.locationName!,
  //     latitude: location.latitude ?? 0.0,
  //     longitude: location.longitude ?? 0.0,
  //     radius: location.radius?.toDouble() ?? 0.0,
  //   )).toList();
  //
  //   print("Geofences: ${offices.map((geo) => geo.name)}");
  //
  //   isInsideAnyGeofence.value = false;
  //
  //   for (GeofenceModel office in offices) {
  //     double distance = GeoUtils.haversine(
  //       8.953694,7.467342, office.latitude, office.longitude,
  //     );
  //
  //     print("Distance to ${office.name}: $distance meters");
  //
  //     if (distance <= office.radius) {
  //       print('Entered geofence: ${office.name}');
  //       location.value = office.name;
  //       isInsideAnyGeofence.value = true;
  //       isCircularProgressBarOn.value = false;
  //       break; // Exit loop if inside a geofence
  //     }
  //     break;
  //   }
  //
  //   // If not inside any geofence, get location from coordinates
  //   if (!isInsideAnyGeofence.value) {
  //     List<Placemark> placemark = await placemarkFromCoordinates(lati.value, longi.value);
  //     location.value =
  //     "${placemark[0].street ?? ''},"
  //         "${placemark[0].subLocality ?? ''},"
  //         "${placemark[0].subAdministrativeArea ?? ''},"
  //         "${placemark[0].locality ?? ''},"
  //         "${placemark[0].administrativeArea ?? ''},"
  //         "${placemark[0].postalCode ?? ''},"
  //         "${placemark[0].country ?? ''}";
  //
  //     print("Location from coordinates: ${location.value}");
  //   }
  // }


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

  Future<void> checkInternetConnection() async {
    isInternetConnected.value = await InternetConnectionChecker().hasConnection;
    if (!isInternetConnected.value) {
      Fluttertoast.showToast(
        msg:
        "No Internet Connectivity Detected.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> handleClockInOut(
      BuildContext context, GlobalKey<SlideActionState> key) async {

    try {
      final lastAttend = await service.getLastAttendance(
          DateFormat("MMMM yyyy").format(DateTime.now()).toString());

      if (lastAttend?.date != currentDate) {
        // Clock In
        await _clockIn(isInternetConnected.value);
      } else if (lastAttend?.date == currentDate) {
        // Clock Out
        List<AttendanceModel> attendanceResult = await service
            .getAttendanceForDate(
            DateFormat('dd-MMMM-yyyy').format(DateTime.now()));
        final bioInfoForUser = await service.getBioInfoWithFirebaseAuth();
        await _clockOut(
            attendanceResult[0].id, bioInfoForUser, attendanceResult);
      } else if (lastAttend?.date == null) {
        // No previous record, clock in
        await _clockIn(isInternetConnected.value);
      }
    } catch (e) {
      log("Attendance clockInandOut Error ====== ${e.toString()}");
      await _clockIn(isInternetConnected.value);
    }

    key.currentState!.reset();
  }

  Future<void> _clockIn(bool isDeviceConnected) async {
    final time = isDeviceConnected
        ? DateTime.now().add(Duration(
        milliseconds: await NTP.getNtpOffset(
            localTime: DateTime.now(), lookUpAddress: "time.google.com")))
        : DateTime.now();

    if(UserModel.lat != 0.0) {
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
        ..month = DateFormat('MMMM yyyy').format(time)
        ..comments = "No Comment"
      ;

      await service.saveAttendance(attendance);
      // Update the clockIn stream after saving the attendance
      _clockInStreamController.add(DateFormat('hh:mm a').format(time));
      _clockInLocationStreamController.add(location.value);
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
    }else{
      Fluttertoast.showToast(
        msg: "Latitude and Longitude cannot be 0.0..",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _clockOut(
      int attendanceId,
      BioModel? bioInfoForUser,
      List<AttendanceModel> attendanceResult) async {

    final time = isDeviceConnected
        ? DateTime.now().add(Duration(
        milliseconds: await NTP.getNtpOffset(
            localTime: DateTime.now(), lookUpAddress: "time.google.com")))
        : DateTime.now();

    if(UserModel.lat != 0.0) {
      await service.updateAttendance(
        attendanceId,
        AttendanceModel(),
        DateFormat('hh:mm a').format(time),
        UserModel.lat,
        UserModel.long,
        location.value,
        false,
        true,
        _diffClockInOut(
            attendanceResult[0].clockIn.toString(),
            DateFormat('h:mm a').format(time)),
        _diffHoursWorked(
            attendanceResult[0].clockIn.toString(),
            DateFormat('h:mm a').format(time)),
      );
      _clockOutStreamController.add(DateFormat('hh:mm a').format(time));
      _clockOutLocationStreamController.add(location.value);
      Fluttertoast.showToast(
        msg: "Clocking-Out..",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Get.off(() =>
      bioInfoForUser!.role == "User"
          ? UserDashBoard(service: service)
          : AdminDashBoard(service: service));
    } else{
      Fluttertoast.showToast(
        msg: "Latitude and Longitude cannot be 0.0..",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
  if (isLocationPermissionGranted.value ==
  LocationPermission.denied ||
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



  void showBottomSheet3(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final ClockAttendanceController controller =
    Get.put(ClockAttendanceController(IsarService()));
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: screenWidth,
            height: screenHeight * 0.65,
            color: Colors.white,
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
                  // Obx(
                  //       () => Container(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "${controller.firstName.value.toString().toUpperCase()} ${controller.lastName.value.toString().toUpperCase()}",
                  //       style: TextStyle(
                  //         color: Colors.black54,
                  //         fontFamily: "NexaBold",
                  //         fontSize: screenWidth / 18,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                  SizedBox(height: 10),
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
                              _getTimeFromUser(
                                  isStartTime: true, setState: setState);
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
                              _getTimeFromUser(
                                  isStartTime: false, setState: setState);
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
    // _getLocation();
    final attendanceLast = await service.getAttendanceForSpecificDate(
        DateFormat('dd-MMMM-yyyy').format(DateTime.now()));

    if (lati.value == 0.0 && longi.value == 0.0) {
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
        ..clockInLatitude = lati.value
        ..clockInLocation = location.value
        ..clockInLongitude = longi.value
        ..clockOut = _endTime
        ..clockOutLatitude = lati.value
        ..clockOutLocation = location.value
        ..clockOutLongitude = longi.value
        ..isSynced = false
        ..voided = false
        ..isUpdated = true
        ..offDay = true
        ..durationWorked = _reasons
        ..noOfHours = _diffHoursWorked(_startTime, _endTime)
        ..month = DateFormat('MMMM yyyy').format(_selectedDate);

      await service.saveAttendance(attendnce);
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

  void _getTimeFromUser(
      {required bool isStartTime, required StateSetter setState}) async {
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