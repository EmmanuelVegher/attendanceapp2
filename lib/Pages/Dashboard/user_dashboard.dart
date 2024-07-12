import 'dart:developer';

import 'package:attendanceapp/Pages/Attendance/button.dart';
import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/widgets/dashboard_widget.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/widgets/drawer2.dart';
import 'package:attendanceapp/widgets/drawer3.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<FlSpot> dataSet = [];
  List clockInSet = [];
  List clockOutSet = [];
  List totalClockIns = [];
  double totalHoursWorked = 0;
  String _month = DateFormat("MMMM yyyy").format(DateTime.now());
  AttendanceModel attendanceModel = AttendanceModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetail();
    // getCurrentDateRecordCount();
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
    return clockInSet.length == 0 ? 0 : clockInSet.length;
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
    return clockOutSet.length == 0 ? 0 : clockOutSet.length;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Staff DashBoard",
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
                return Center(
                  child: Text("Unexpected Error!"),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No Attendance Yet for the Month"),
                  );
                }
                getPlotPoints(snapshot.data!);
                getTotalClockIn(snapshot.data!);
                return ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
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
                                fontSize: screenWidth / 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
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
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Next Create card
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
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
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              "Attendance Summary",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              "Total Hours Worked = ${getTotalHoursandMins(getTotalHoursWorked(snapshot.data!))}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 20.0),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 20.0),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
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
                                      color: Color.fromARGB(255, 63, 7, 3),
                                    )
                                  ]),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Out-Of-Office History:",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
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
                            return Center(
                              child: Text("UnExpected Error!"),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Center(
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
                                        height: 70,
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
                                                decoration: BoxDecoration(
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
                                                              screenWidth / 23,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
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
                            return Center(
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
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clock-In Total",
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
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
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(right: 8.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clock-Out Total",
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            )
          ],
        )
      ],
    );
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
              style: TextStyle(
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
                Spacer(),
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
                SizedBox(
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
                SizedBox(
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
