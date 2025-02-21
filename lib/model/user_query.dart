import 'dart:math';

import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class UserQueryScreen extends StatefulWidget {
  const UserQueryScreen({Key? key}) : super(key: key);

  @override
  State<UserQueryScreen> createState() => _UserQueryScreenState();
}

class _UserQueryScreenState extends State<UserQueryScreen> {
  AttendanceModel attendance = AttendanceModel();
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  String _month = DateFormat("MMMM").format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllRecordsFirebase();
  }

  _getAllRecordsFirebase() async {
    List data = [];
    var seen = <dynamic>{};
    List data2 = [];
    List<AttendanceModel> allAttendance = [];
    var collection = FirebaseFirestore.instance.collection('Staff');

    var num = collection.where("state", isEqualTo: "Abuja").get();

    await num.then((QuerySnapshot value) async {
      for (var element2 in value.docs) {
        seen.add(element2.data());
        //print("element2=====${element2.data()["id"]}");
        for (var element3 in seen) {
          //print("element3=====${element3["id"]}");
          final CollectionReference snap3 = FirebaseFirestore.instance
              .collection('Staff')
              .doc(element3["id"])
              .collection("Record");
          print("snap3 ====$snap3");
        }
      }
    });

    // await num.get().then((QuerySnapshot value) async {
    //   for (var element in value.docs) {
    //     data.add(element.data());
    //   }
    // });

    // final CollectionReference snap3 =
    //     await FirebaseFirestore.instance.collection('Staff');
    // // .doc(firebaseAuthId)
    // // .collection("Record");
    // print("snap3 ====$snap3");

    // List data = [];
    // List data2 = [];
    // List<AttendanceModel> allAttendance = [];

    // await snap3.get().then((QuerySnapshot value) async {
    //   for (var element in value.docs) {
    //     data.add(element.data());
    //   }
    // });

    // for (var document in data) {
    //   data2.add(document.data2());
    // }

    // for (var document in data2) {
    //   allAttendance.add(AttendanceModel.fromJson(document));
    // }

    // print("data ====$data");
    // print("data2 ====$data2");
    // print("allAttendance ====$allAttendance");

    // for (var attendanceHistory in allAttendance) {
    //   final attendnce = AttendanceModel()
    //     ..clockIn = attendanceHistory.clockIn
    //     ..date = attendanceHistory.date
    //     ..clockInLatitude = attendanceHistory.clockInLatitude
    //     ..clockInLocation = attendanceHistory.clockInLocation
    //     ..clockInLongitude =
    //         attendanceHistory.clockInLongitude
    //     ..clockOut = attendanceHistory.clockOut
    //     ..clockOutLatitude =
    //         attendanceHistory.clockOutLatitude
    //     ..clockOutLocation =
    //         attendanceHistory.clockOutLocation
    //     ..clockOutLongitude =
    //         attendanceHistory.clockOutLongitude
    //     ..isSynced = attendanceHistory.isSynced
    //     ..voided = attendanceHistory.voided
    //     ..isUpdated = attendanceHistory.isUpdated
    //     ..offDay = attendanceHistory.offDay
    //     ..durationWorked = attendanceHistory.durationWorked
    //     ..noOfHours = attendanceHistory.noOfHours
    //     ..month = attendanceHistory.month;

    // widget.service.saveAttendance(attendnce);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            //padding: const EdgeInsets.only(top: 0),
            child: const Row(
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
          /*
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "My Attendance",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),*/

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
                  ),
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
                                primary: primary,
                                secondary: primary,
                                onSecondary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: primary,
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
                        _month = DateFormat('MMMM').format(month);
                      });
                    }
                  },
                  child: Text(
                    "Pick a Month",
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: screenHeight / 1.45,
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection("Staff")
          //         .doc(User.id)
          //         .collection("Record")
          //         .snapshots(),
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (snapshot.hasData) {
          //         final snap = snapshot.data!.docs;
          //         return ListView.builder(
          //           itemCount: snap.length,
          //           itemBuilder: (context, index) {
          //             return DateFormat("MMMM")
          //                         .format(snap[index]["date"].toDate()) ==
          //                     _month
          //                 ? Container(
          //                     margin: EdgeInsets.only(
          //                         top: index > 0 ? 12 : 0, left: 6, right: 6),
          //                     height: 150,
          //                     decoration: const BoxDecoration(
          //                       color: Colors.white,
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.black26,
          //                           blurRadius: 10,
          //                           offset: Offset(2, 2),
          //                         )
          //                       ],
          //                       borderRadius:
          //                           BorderRadius.all(Radius.circular(20)),
          //                     ),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Expanded(
          //                           child: Container(
          //                             margin: const EdgeInsets.only(),
          //                             decoration: BoxDecoration(
          //                               color: primary,
          //                               borderRadius: const BorderRadius.all(
          //                                   Radius.circular(20)),
          //                             ),
          //                             child: Center(
          //                               child: Text(
          //                                 DateFormat("dd").format(
          //                                     snap[index]["date"].toDate()),
          //                                 style: TextStyle(
          //                                   fontFamily: "NexaBold",
          //                                   fontSize: screenWidth / 18,
          //                                   color: Colors.white,
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                         Expanded(
          //                             child: Column(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           children: [
          //                             Text(
          //                               "Clock In",
          //                               style: TextStyle(
          //                                   fontFamily: "NexaLight",
          //                                   fontSize: screenWidth / 20,
          //                                   color: Colors.black54),
          //                             ),
          //                             Text(
          //                               snap[index]["clockIn"],
          //                               style: TextStyle(
          //                                 fontFamily: "NexaBold",
          //                                 fontSize: screenWidth / 18,
          //                               ),
          //                             ),
          //                           ],
          //                         )),
          //                         Expanded(
          //                             child: Column(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           children: [
          //                             Text(
          //                               "Clock Out",
          //                               style: TextStyle(
          //                                   fontFamily: "NexaLight",
          //                                   fontSize: screenWidth / 20,
          //                                   color: Colors.black54),
          //                             ),
          //                             Text(
          //                               snap[index]["clockOut"],
          //                               style: TextStyle(
          //                                 fontFamily: "NexaBold",
          //                                 fontSize: screenWidth / 18,
          //                               ),
          //                             )
          //                           ],
          //                         )),
          //                       ],
          //                     ),
          //                   )
          //                 : SizedBox();
          //           },
          //         );
          //       } else {
          //         return const SizedBox();
          //       }
          //     },
          //   ),
          // )
        ],
      ),
    ));
  }
}
