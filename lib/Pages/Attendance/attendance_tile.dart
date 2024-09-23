import 'package:attendanceapp/model/attendance.dart';
import 'package:attendanceapp/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceTile extends StatelessWidget {
  final Attendance? attendance;
  AttendanceTile(this.attendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: primaryClr, //_getBGClr(attendance?.color??0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendance?.id.toString() ?? "",
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                    fontFamily: "NexaBold",
                    fontSize: 16,
                  ),
                  /*GoogleFonts.lato(
                    textStyle: TextStyle(
                     
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),*/
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${attendance!.clockIn} - ${attendance!.clockOut}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[100]),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  attendance?.date ?? "",
                  style: TextStyle(fontSize: 15, color: Colors.grey[100]),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              attendance!.isSynced == 1 ? "SYNCED" : "NOT SYNCED",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return primaryClr;
      case 1:
        return bluishClr;
      case 2:
        return yellowClr;
      default:
        return primaryClr;
    }
  }
}
