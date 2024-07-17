import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

// Import your controller
import 'package:attendanceapp/controllers/user_dashboard_controller.dart';

import '../../services/isar_service.dart';
import '../../widgets/drawer.dart';
import '../../widgets/drawer2.dart';
import '../../widgets/drawer3.dart';

class UserDashBoard extends StatelessWidget {
  final IsarService service;
  UserDashBoard({super.key, required this.service});



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final UserDashBoardController controller =
    Get.put(UserDashBoardController(service));
    controller.service = service;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "User DashBoard",
            style: TextStyle(
              color: Colors.red,
              fontFamily: "NexaBold",
              fontSize: screenWidth * 0.045, // Responsive font size
            ),
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
        ),
        drawer: Obx(
              () => controller.role.value == "User"
              ? drawer(context, service)
              : controller.role.value == "Admin"
              ? drawer2(context, service)
              : drawer3(context, service),
        ),
        body: SizedBox(
          height: screenHeight,
          child: Obx(
                () => dashBoardWidget(context, screenWidth, screenHeight, controller), // Pass controller here
          ),
        ),
      ),
    );
  }
}

// Modified dashBoardWidget to accept screen dimensions
Widget dashBoardWidget(
    BuildContext context, double screenWidth, double screenHeight, UserDashBoardController controller) {
  return ListView(
    children: [
      SizedBox(
        height: screenHeight * 0.025,
      ),
      Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Obx(
                  () => Text(
                controller.selectedMonth.value,
                style: TextStyle(
                  color: Colors.brown,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              "No Attendance for current month",
              style: TextStyle(
                color: Colors.red,
                fontFamily: "NexaBold",
                fontSize: screenWidth / 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // Attendance Summary Card
      Container(
        width: screenWidth * 0.9,
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
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
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
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Obx(
                    () => Text(
                  "Total Hours Worked = ${controller.totalHoursWorkedString.value}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardClockIn("0", screenWidth), // Pass screenWidth for responsive sizing
                    cardClockOut("0", screenWidth), // Pass screenWidth for responsive sizing
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Line Chart
      Container(
        height: screenWidth * 0.95,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
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
                spots: getPlotPoints(controller), // Get data from controller
                isCurved: false,
                barWidth: 2.5,
                color: const Color.fromARGB(255, 63, 7, 3),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          "Out-Of-Office History:",
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.w900,
            color: Colors.brown,
          ),
        ),
      ),
    ],
  );
}

List<FlSpot> getPlotPoints(UserDashBoardController controller) {
  return controller.dataSet;
}

// Modified cardClockIn and cardClockOut to accept screenWidth
Widget cardClockIn(String value, double screenWidth) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_downward,
          size: screenWidth * 0.06, // Responsive icon size
          color: Colors.green[700],
        ),
        margin: EdgeInsets.only(right: screenWidth * 0.02), // Responsive margin
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clock-In Total",
            style: TextStyle(
              fontSize: screenWidth * 0.035, // Responsive font size
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget cardClockOut(String value, double screenWidth) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          Icons.arrow_upward,
          size: screenWidth * 0.06, // Responsive icon size
          color: Colors.red[700],
        ),
        margin: EdgeInsets.only(right: screenWidth * 0.02), // Responsive margin
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Clock-Out Total",
            style: TextStyle(
              fontSize: screenWidth * 0.035, // Responsive font size
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  );
}