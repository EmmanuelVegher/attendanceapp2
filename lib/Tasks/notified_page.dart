import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Pages/Attendance/button.dart'; // Assuming MyButton is here
import '../controllers/task_controller.dart'; // Assuming TaskController is here
import '../model/task.dart'; // Assuming Task model is here
import '../services/isar_service.dart'; // Assuming IsarService is here
import '../services/notification_services.dart'; // Assuming NotifyHelper is here
import '../widgets/drawer.dart'; // Assuming drawer widget is here
import '../widgets/task_tile.dart'; // Assuming TaskTile widget is here
import 'add_tasks.dart'; // Assuming AddTaskPage is here


class ActivityMonitoringPage extends StatefulWidget {
  @override
  _ActivityMonitoringPageState createState() => _ActivityMonitoringPageState();
}

class _ActivityMonitoringPageState extends State<ActivityMonitoringPage> {
  // --- Dummy Data for other reports (Replace with Firebase data later) ---
  List<Map<String, dynamic>> monthlySummaryData = [
    {"indicator": "ART 1", "age_1_4": 0, "age_5_9": 0, "age_10_14": 0, "age_15_19": 0, "age_20_24": 0, "age_25_29": 0, "age_30_34": 0, "age_35_39": 0, "age_40_44": 0, "age_45_49": 0, "age_50_plus": 1, "total": 2},
    {"indicator": "ART 2", "age_1_4": "-", "age_5_9": "-", "age_10_14": "-", "age_15_19": "-", "age_20_24": "-", "age_25_29": "-", "age_30_34": "-", "age_35_39": "-", "age_40_44": "-", "age_45_49": "-", "age_50_plus": "-", "total": 3},
  ];

  List<Map<String, dynamic>> weeklyDataValues = [
    {"indicatorGroup": "HTS GROUPS", "hts_ts_facility_index": 10, "hts_ts_facility_pos": 2, "hts_ts_community_index": 5, "hts_ts_community_pos": 1},
  ];

  Map<String, dynamic> performanceIndicatorsData = {
    "facility_index_tested": 100, "facility_index_positive": 10, "pitc_ward_opd_tested": 44, "pitc_ward_opd_positive": 15,
  };

  List<Map<String, dynamic>> indicatorAchievementData = [
    {"indicator": "HTS_TST", "fy24_target": 1525, "month1": 488, "month2": 166, "month3": 166, "achievement_ytd": 2314, "percent_achievement": 119, "gaps": 1438},
  ];

  List<Map<String, dynamic>> itRateData = [
    {"facility_name": "St. Charles Hospital", "tx_curr_all": 1060, "tx_curr_0_9": 9, "tx_curr_10_19": 15, "total_it_all_age": 659, "total_it_all_age_0_9": 2, "total_it_all_age_10_19": 1, "it_rate_all": "40%", "it_rate_0_9": "20%", "it_rate_10_19": "6%", "to_become_it_12th_december_2024": 765, "missed_appointment": 190, "q4_it": 39},
  ];

  Map<String, dynamic> newHIVPositiveData = {
    "total_number_newly_tested_positive": 1, "tx_new_weekly_arvs": 1, "no_new_art_patients": 0,
  };
  // ---------------------------------------------------

  // --- Task Manager related variables and controllers ---
  final TaskController _taskController = Get.put(TaskController()); // Get the task controller
  late NotifyHelper notifyHelper;
  double screenHeight = 0;
  double screenWidth = 0;
  DateTime _selectedDate = DateTime.now();
  // ---------------------------------------------------

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks(); // Load tasks from Isar on page load
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: drawer(context, IsarService()), // Assuming drawer is defined elsewhere
      appBar: _appBar(), // Extracted AppBar to _appBar() method
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('National Facility ART Monthly Summary Form', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildMonthlySummaryReport(),

            SizedBox(height: 20),
            Text('FY25 BI-WEEKLY DATA VALUE', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildWeeklyDataValuesReport(),

            SizedBox(height: 20),
            Row( // Task Bar and Date Bar are now in a Row
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _addTaskBar()), // Task Bar takes available width
                Expanded(child: _addDateBar()), // Date Bar takes available width
              ],
            ),
            SizedBox(height: 10),
            Text('Daily Activities', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildDailyActivitiesReport(), // Now shows tasks from Isar

            SizedBox(height: 20),
            Text('Performance Indicators', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildPerformanceIndicatorsReport(),

            SizedBox(height: 20),
            Text('Indicator Achievement Summary', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildIndicatorAchievementReport(),

            SizedBox(height: 20),
            Text('Missed Appointment Tracking (IT Rate)', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildITRateReport(),

            SizedBox(height: 20),
            Text('New HIV Positive Tracking', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildNewHIVPositiveReport(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Activity Monitoring", // Changed title to Activity Monitoring
        style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.grey[600], fontFamily: "NexaBold"),
      ),
      elevation: 0.5,
      iconTheme: IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black87),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: Stack(
            children: <Widget>[
              Image.asset("assets/image/ccfn_logo.png"),
            ],
          ),
        )
      ],
    );
  }


  Widget _buildMonthlySummaryReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
              DataColumn(label: Text('Indicator')),
              DataColumn(label: Text('<1')),
              DataColumn(label: Text('1-4')),
              DataColumn(label: Text('5-9')),
              DataColumn(label: Text('10-14')),
              DataColumn(label: Text('15-19')),
              DataColumn(label: Text('20-24')),
              DataColumn(label: Text('25-29')),
              DataColumn(label: Text('30-34')),
              DataColumn(label: Text('35-39')),
              DataColumn(label: Text('40-44')),
              DataColumn(label: Text('45-49')),
              DataColumn(label: Text('50+')),
              DataColumn(label: Text('Total')),
            ],
            rows: monthlySummaryData.map((data) => DataRow(cells: [
              DataCell(Text(data['indicator'] ?? '')),
              DataCell(Text(data['age_1_4'].toString() ?? '')),
              DataCell(Text(data['age_5_9'].toString() ?? '')),
              DataCell(Text(data['age_10_14'].toString() ?? '')),
              DataCell(Text(data['age_15_19'].toString() ?? '')),
              DataCell(Text(data['age_20_24'].toString() ?? '')),
              DataCell(Text(data['age_25_29'].toString() ?? '')),
              DataCell(Text(data['age_30_34'].toString() ?? '')),
              DataCell(Text(data['age_35_39'].toString() ?? '')),
              DataCell(Text(data['age_40_44'].toString() ?? '')),
              DataCell(Text(data['age_45_49'].toString() ?? '')),
              DataCell(Text(data['age_50_plus'].toString() ?? '')),
              DataCell(Text(data['total'].toString() ?? '')),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyDataValuesReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
              DataColumn(label: Text('Indicator Group')),
              DataColumn(label: Text('Facility Index (Tested)')),
              DataColumn(label: Text('Facility Index (Positive)')),
              DataColumn(label: Text('Community Index (Tested)')),
              DataColumn(label: Text('Community Index (Positive)')),
            ],
            rows: weeklyDataValues.map((data) => DataRow(cells: [
              DataCell(Text(data['indicatorGroup'] ?? '')),
              DataCell(Text(data['hts_ts_facility_index'].toString() ?? '')),
              DataCell(Text(data['hts_ts_facility_pos'].toString() ?? '')),
              DataCell(Text(data['hts_ts_community_index'].toString() ?? '')),
              DataCell(Text(data['hts_ts_community_pos'].toString() ?? '')),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyActivitiesReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() { // Wrap with Obx to react to task list changes
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.0,
              horizontalMargin: 10.0,
              border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
              columns: [
                DataColumn(label: Text('Day')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Daily Activities')),
                DataColumn(label: Text('Responsible Persons')), // You might need to add this to Task model
                DataColumn(label: Text('Status')),
              ],
              rows: _taskController.taskList.map((task) { // Use taskList from controller
                return DataRow(cells: [
                  DataCell(Text(DateFormat('EEEE').format(DateFormat.yMd().parse(task.date!)))), // Day from date
                  DataCell(Text(task.date ?? '')),
                  DataCell(Text(task.title ?? '')),
                  DataCell(Text('')), // Responsible person - you can set user name or leave empty
                  DataCell(Text(task.isCompleted == true ? 'Done' : 'Pending')), // Status from isCompleted
                ]);
              }).toList(),
            ),
          );
        }),
      ),
    );
  }


  Widget _buildPerformanceIndicatorsReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildPerformanceIndicatorRow('Facility Index (Tested)', performanceIndicatorsData['facility_index_tested']),
            _buildPerformanceIndicatorRow('Facility Index (Positive)', performanceIndicatorsData['facility_index_positive']),
            _buildPerformanceIndicatorRow('PITC (Ward, OPD, etc.) Tested', performanceIndicatorsData['pitc_ward_opd_tested']),
            _buildPerformanceIndicatorRow('PITC (Ward, OPD, etc.) Positive', performanceIndicatorsData['pitc_ward_opd_positive']),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicatorRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildIndicatorAchievementReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
              DataColumn(label: Text('Indicator')),
              DataColumn(label: Text('FY24 Target')),
              DataColumn(label: Text('Month 1')),
              DataColumn(label: Text('Month 2')),
              DataColumn(label: Text('Month 3')),
              DataColumn(label: Text('Achievement YTD')),
              DataColumn(label: Text('% Achievement')),
              DataColumn(label: Text('Gaps')),
            ],
            rows: indicatorAchievementData.map((data) => DataRow(cells: [
              DataCell(Text(data['indicator'] ?? '')),
              DataCell(Text(data['fy24_target'].toString() ?? '')),
              DataCell(Text(data['month1'].toString() ?? '')),
              DataCell(Text(data['month2'].toString() ?? '')),
              DataCell(Text(data['month3'].toString() ?? '')),
              DataCell(Text(data['achievement_ytd'].toString() ?? '')),
              DataCell(Text(data['percent_achievement'].toString() ?? '')),
              DataCell(Text(data['gaps'].toString() ?? '')),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildITRateReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
              DataColumn(label: Text('Facility Name')),
              DataColumn(label: Text('TX Curr All')),
              DataColumn(label: Text('TX Curr 0-9')),
              DataColumn(label: Text('TX Curr 10-19')),
              DataColumn(label: Text('Total IT All Age')),
              DataColumn(label: Text('Total IT All Age 0-9')),
              DataColumn(label: Text('Total IT All Age 10-19')),
              DataColumn(label: Text('IT Rate All')),
              DataColumn(label: Text('IT Rate 0-9')),
              DataColumn(label: Text('IT Rate 10-19')),
              DataColumn(label: Text('To Become IT 12th Dec 2024')),
              DataColumn(label: Text('Missed Appointment')),
              DataColumn(label: Text('Q4 IT')),
            ],
            rows: itRateData.map((data) => DataRow(cells: [
              DataCell(Text(data['facility_name'] ?? '')),
              DataCell(Text(data['tx_curr_all'].toString() ?? '')),
              DataCell(Text(data['tx_curr_0_9'].toString() ?? '')),
              DataCell(Text(data['tx_curr_10_19'].toString() ?? '')),
              DataCell(Text(data['total_it_all_age'].toString() ?? '')),
              DataCell(Text(data['total_it_all_age_0_9'].toString() ?? '')),
              DataCell(Text(data['total_it_all_age_10_19'].toString() ?? '')),
              DataCell(Text(data['it_rate_all'].toString() ?? '')),
              DataCell(Text(data['it_rate_0_9'].toString() ?? '')),
              DataCell(Text(data['it_rate_10_19'].toString() ?? '')),
              DataCell(Text(data['to_become_it_12th_december_2024'].toString() ?? '')),
              DataCell(Text(data['missed_appointment'].toString() ?? '')),
              DataCell(Text(data['q4_it'].toString() ?? '')),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNewHIVPositiveReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Total Number Newly Tested HIV Positive (HTS TST POSITIVE): ${newHIVPositiveData['total_number_newly_tested_positive'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('TX NEW (TX New is the number of new patients COMMENCED on ARVs during the week): ${newHIVPositiveData['tx_new_weekly_arvs'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('No of new ART patients (TX NEW) clinically screened for TB: ${newHIVPositiveData['no_new_art_patients'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted == 1
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.32,
          color: Get.isDarkMode ? Colors.black : Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
              const Spacer(),
              task.isCompleted == 1
                  ? Container()
                  : _bottomSheetButton(
                label: "Task Completed",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: Colors.red,
                context: context,
              ),
              _bottomSheetButton(
                label: "Delete Task",
                onTap: () {
                  _taskController.deleteTask(task.id!); // Calling delete function
                  Get.back();
                },
                clr: Colors.blue,
                context: context,
              ),
              const SizedBox(height: 20,),
              _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.blue,
                isClose: true,
                context: context,
              ),
              const SizedBox(height: 10,),
            ],
          ),
        )
    );
  }

  _bottomSheetButton({required String label, required Function()? onTap, required Color clr,
    bool isClose = false, required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? TextStyle(fontSize: 16, color: Get.isDarkMode ? Colors.white : Colors.black87, fontFamily: "NexaBold")
                : const TextStyle(fontSize: 16, color: Colors.white, fontFamily: "NexaBold"),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.red,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
            fontSize: 20, fontFamily: "NexaBold", color: Colors.grey),
        dayTextStyle: const TextStyle(
            fontSize: 15, fontFamily: "NexaLight", color: Colors.grey),
        monthTextStyle: const TextStyle(
            fontSize: 14, fontFamily: "NexaBold", color: Colors.grey),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: "${DateTime.now().day},",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600
                                      ? 0.080
                                      : 0.060),
                              fontFamily: "NexaBold"),
                          children: [
                            TextSpan(
                                text: DateFormat(" MMMM, yyyy").format(DateTime.now()),
                                style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white : Colors.black,
                                    fontSize: MediaQuery.of(context).size.width *
                                        (MediaQuery.of(context).size.shortestSide < 600
                                            ? 0.050
                                            : 0.030),
                                    fontFamily: "NexaBold"))
                          ]),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "Today's Task", // Changed to Today's Task
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: MediaQuery.of(context).size.width *
                          (MediaQuery.of(context).size.shortestSide < 600
                              ? 0.050
                              : 0.030),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTasks(); // Refresh tasks after adding
          },
          )
        ],
      ),
    );
  }
}