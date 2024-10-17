import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/attendancemodel.dart';
import '../../services/isar_service.dart';
import '../../widgets/date_helper.dart';

class LocationRecord {
  final String location;
  final int attendanceCount;

  LocationRecord({required this.location, required this.attendanceCount});
}


class AttendanceReportPage extends StatefulWidget {
  @override
  _AttendanceReportPageState createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  late Isar _isar;
 // late Stream<List<AttendanceRecord>> _attendanceStream;

  @override
  void initState() {
    super.initState();
    // Replace with your Isar instance
   // _isar = Isar.openSync(Directory('path/to/your/isar/directory'));
    // Initialize attendance stream
  //  _attendanceStream = _getAttendanceStream();
  }

  @override
  void dispose() {
    // appBar: AppBar(
    //   title: Text('Attendance Report'),
    // ), _isar.close(); // Close Isar connection when the widget is disposed
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<List<AttendanceModel>>(
          stream: IsarService().searchAllAttendance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final attendance = snapshot.data;
            if (attendance!.isEmpty) {
              return const Center(child: Text('No Attendance found for the current month'));
            }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (Your date pickers if needed)

                // ... (Your summary card if needed)

                _buildClockInOutTrendsChart(attendance),
                SizedBox(height: 20),
                _buildDurationWorkedDistributionChart(attendance),
                SizedBox(height: 20),
                _buildAttendanceByLocationChart(attendance),
                SizedBox(height: 20),
                _buildEarlyLateClockInsChart(attendance),
                // ... (Add more charts as needed)
              ],
            ),
          );
          } else {
            return const Center(child: Text('Unable to generate Report as No Attendance ever recorded yet.Navigate to the Attendance page in the center tab and clock-in'));
          }
        },
      ),
    );
  }

  // ... (Chart building widgets)

          Widget _buildClockInOutTrendsChart(List<AttendanceModel> attendanceData) {
        // Define the time format (assuming it's in hh:mm a format)
        final timeFormat = DateFormat('hh:mm a'); // AM/PM format



        return Card(
      elevation: 3,
      child: Container(
        height: 300,
        padding: EdgeInsets.all(16.0),
        child: SfCartesianChart(
          title: ChartTitle(text: 'Clock-In and Clock-Out Trends (When People Clock In (Green) and Clock Out (Red))',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
          primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(fontSize: 20),
              title: AxisTitle(text: 'Days of the Week',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) // Add X-axis title
          ),
          primaryYAxis: NumericAxis(
              labelStyle: TextStyle(fontSize: 20), // Style for Y-axis labels
              title: AxisTitle(text: 'Time of the Day',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)

          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'Clock-In: point.yClockIn\nClock-Out: point.yClockOut',
          ),
          series: <CartesianSeries<AttendanceModel, String>>[

            LineSeries<AttendanceModel, String>(
              dataSource: attendanceData,
              xValueMapper: (data, _) => DateFormat('dd-MMM').format(DateFormat('dd-MMMM-yyyy').parse(data.date!)),
              yValueMapper: (data, _) {
                // Parse clockInTime string to DateTime
                DateTime clockIn = timeFormat.parse(data.clockIn!);
                // Return rounded value for plotting
                return double.parse((clockIn.hour + (clockIn.minute / 60)).toStringAsFixed(1));
              },
              name: 'Clock-In',
              color: Colors.green,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    return Text(
                      timeFormat.format(timeFormat.parse(data.clockIn)),
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    );
                  }

              ),
            ),
            LineSeries<AttendanceModel, String>(
              dataSource: attendanceData,
              xValueMapper: (data, _) => DateFormat('dd-MMM').format(DateFormat('dd-MMMM-yyyy').parse(data.date!)),
              yValueMapper: (data, _) {
                // Parse clockOutTime string to DateTime
                DateTime clockOut = timeFormat.parse(data.clockOut!);
                // Return rounded value for plotting
                return double.parse((clockOut.hour + (clockOut.minute / 60)).toStringAsFixed(1));
              },
              name: 'Clock-Out',
              color: Colors.red,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    return Text(
                      timeFormat.format(timeFormat.parse(data.clockOut)),
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    );
                  }

              ),
            ),
          ],
        ),
      ),
    );
  }


        Widget _buildDurationWorkedDistributionChart(List<AttendanceModel> attendanceData) {
      return Card(
        elevation: 3,
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          child: SfCartesianChart(
            // key: _durationWorkedDistributionChartKey,
            title: ChartTitle(text: 'Distribution of Hours Worked (How Many Hours You Worked (For example, if you see a "2" on top of a bar between 8 and 9, it means you worked between 8 and 9 hours two times.)',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            primaryXAxis: NumericAxis(
                labelStyle: TextStyle(fontSize: 20),
                title: AxisTitle(text: 'Duration of Hours Worked (Grouped By Hours)',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) // Add X-axis title
            ),
            primaryYAxis: NumericAxis(
                labelStyle: TextStyle(fontSize: 20), // Style for Y-axis labels
                title: AxisTitle(text: 'Frequency',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)

            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <HistogramSeries<AttendanceModel, double>>[
              HistogramSeries<AttendanceModel, double>(
                dataSource: attendanceData,
                yValueMapper: (data, _) => DateHelper.calculateHoursWorked(data.clockIn!,data.clockOut!),// Calculate duration in hours
                binInterval: 1,
                color: Colors.purple,
                // Add data label settings here
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  // Customize appearance (optional):
                  textStyle: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                  // labelAlignment: ChartDataLabelAlignment.top,
                ),
              ),
            ],
          ),
        ),
      );
    }

  // Function to extract location data from attendance records
  List<LocationRecord> _getLocationData(List<AttendanceModel> attendanceData) {
    Map<String, int> locationCounts = {};
    for (var record in attendanceData) {
      final location = record.clockInLocation;
      if (location != null) {
        locationCounts.update(location, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    return locationCounts.entries
        .map((entry) => LocationRecord(location: entry.key, attendanceCount: entry.value))
        .toList();
  }


    Widget _buildAttendanceByLocationChart(List<AttendanceModel> attendanceData){
      List<LocationRecord> _locationData1 = _getLocationData(attendanceData);
      return Card(
        elevation: 3,
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          child: SfCircularChart(
            //key: _attendanceByLocationChartKey,
            title: ChartTitle(text: 'Where you Clocked In (Attendance by Location)',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            legend: Legend(isVisible: true,textStyle: TextStyle(fontSize: 20),), // Style for legend text),
            series: <CircularSeries>[
              PieSeries<LocationRecord, String>(
                dataSource: _locationData1,
                xValueMapper: (LocationRecord data, _) => data.location,
                yValueMapper: (LocationRecord data, _) => data.attendanceCount,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  // labelAlignment: ChartDataLabelAlignment.middle,
                  textStyle: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),

                ),
              ),
            ],
          ),
        ),
      );
    }


    Widget _buildEarlyLateClockInsChart(List<AttendanceModel> attendanceData) {

      // Define the time format for clock-in time
      final timeFormat = DateFormat('hh:mm a'); // AM/PM format
      // Calculate early/late minutes for each record
      List<Map<String, dynamic>> chartData = attendanceData.map((record) {
        int earlyLateMinutes = DateHelper.calculateEarlyLateTime(record.clockIn);
        DateTime date = DateFormat('dd-MMMM-yyyy').parse(record.date!);
        return {
          'date': DateFormat('dd-MMM').format(date),
          'earlyLateMinutes': earlyLateMinutes,
          'clockInTime': timeFormat.format(timeFormat.parse(record.clockIn!)),
        };
      }).toList();
      return Card(
        elevation: 3,
        child: Container(
          height: 300,
          padding: EdgeInsets.all(16.0),
          child: SfCartesianChart(
            // key: _earlyLateClockInsChartKey,
            title: ChartTitle(text: 'Did You Clock In Early or Late? (Green = Early, Red = Late, 0 = On Time)',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            primaryXAxis: CategoryAxis(labelStyle: TextStyle(fontSize: 20),
                title: AxisTitle(text: 'Days Of the Week',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Number of minutes before ,on or after 8:00 AM',textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              // Center the Y-axis around zero
              labelStyle: TextStyle(fontSize: 20),
              minimum: chartData.map((data) => data['earlyLateMinutes'] as int).reduce((a, b) => a < b ? a : b) < 0
                  ? chartData.map((data) => data['earlyLateMinutes'] as int).reduce((a, b) => a < b ? a : b).toDouble()
                  : null,
              maximum: chartData.map((data) => data['earlyLateMinutes'] as int).reduce((a, b) => a > b ? a : b) > 0
                  ? chartData.map((data) => data['earlyLateMinutes'] as int).reduce((a, b) => a > b ? a : b).toDouble()
                  : null,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<Map<String, dynamic>, String>>[
              ColumnSeries<Map<String, dynamic>, String>(
                dataSource: chartData,
                xValueMapper: (data, _) => data['date'] as String,
                yValueMapper: (data, _) => data['earlyLateMinutes'] as int,
                name: 'Clock-In/Out',
                pointColorMapper: (data, _) =>
                (data['earlyLateMinutes'] as int) >= 0 ? Colors.red : Colors.green, // Green for positive, red for negative
                dataLabelSettings: DataLabelSettings(
                  isVisible: true, // Make data labels visible
                  // You can further customize the appearance of data labels
                  // using properties like:
                  // textStyle: TextStyle(fontSize: 12, color: Colors.black),
                  // labelAlignment: ChartDataLabelAlignment.top,
                  // Custom data labels showing clock-in time and early/late minutes
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    // Display clock-in time and early/late minutes in brackets
                    return Text(
                      '${data['clockInTime']} (${data['earlyLateMinutes']} mins)',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    );
                  },
                  textStyle: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold), // Adjust label text style

                ),
              ),
            ],
          ),
        ),
      );
    }


  // ... (Helper functions)

  Widget _buildChartContainer(String title, Widget chart) {
    return Card(
      elevation: 3,
      child: Container(
        height: 300,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }


}