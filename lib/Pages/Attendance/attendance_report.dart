import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../model/attendancemodel.dart';
import '../../services/isar_service.dart';
import '../../widgets/date_helper.dart';

class LocationRecord {
  final String location;
  final int attendanceCount;

  LocationRecord({required this.location, required this.attendanceCount});
}

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  _AttendanceReportPageState createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 5));
  DateTime _endDate = DateTime.now();

  late Stream<List<AttendanceModel>> _attendanceStream;
  final DateRangePickerController _datePickerController = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    //_attendanceStream = _listenToAttendance();
    _testIsarQuery();
    _attendanceStream = _getAttendanceStream(_startDate, _endDate);
    print("_attendanceStream ==$_attendanceStream");
    _datePickerController.selectedRange = PickerDateRange(_startDate, _endDate);
  }

  Future<void> _testIsarQuery() async {
    final attendance = await IsarService().listenToAttendance(
      // _startDate,
      // _endDate,
    ).first; // Get the first emitted value (the list of attendance)

    print("Isar Query Result: $attendance");
    print("Attendance data count: ${attendance.length}");
  }

  Stream<List<AttendanceModel>> _getAttendanceStream(DateTime startDate, DateTime endDate) {
    return IsarService().searchAttendanceByDateRange(startDate, endDate);
  }

  Stream<List<AttendanceModel>> _listenToAttendance() {
    return IsarService().listenToAttendance();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = args.value.startDate!;
      _endDate = args.value.endDate ?? args.value.startDate!;
      _attendanceStream = _getAttendanceStream(_startDate, _endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('Attendance Report')),
      //   backgroundColor: Colors.purple,
      // ),
      body: Column(
        children: [
          // Date Range Picker Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox( // <-- Add SizedBox here
              height: 220, // <-- Set your desired height
              child:
              SfDateRangePicker(
                controller: _datePickerController,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(_startDate, _endDate),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.black38,
                  textStyle: TextStyle(color: Colors.white),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  showTrailingAndLeadingDates: false,
                ),
              ),),
            ),
          ),

          // Summary and Charts Section (Expanded)
          // Summary and Charts Section (Expanded)
          Expanded(
            child: StreamBuilder<List<AttendanceModel>>(
              stream: _attendanceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final attendance = snapshot.data!;
                  print("Attendance Data: $attendance");

                  if (attendance.isEmpty) {
                    return const Center(
                        child: Text('No Attendance found for the selected date range'));
                  }

                  // Content wrapped in SingleChildScrollView
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Summary Card
                        _buildSummaryCard(attendance),
                        const SizedBox(height: 20),

                        // Charts Section
                        _buildChartCard(
                          'Clock-In and Clock-Out Trends',
                          _buildClockInOutTrendsChart(attendance),
                        ),
                        const SizedBox(height: 20),
                        _buildChartCard(
                          'Distribution of Hours Worked',
                          _buildDurationWorkedDistributionChart(attendance),
                        ),
                        const SizedBox(height: 20),
                        _buildChartCard(
                          'Attendance by Location',
                          _buildAttendanceByLocationChart(attendance),
                        ),
                        const SizedBox(height: 20),
                        _buildChartCard(
                          'Early or Late Clock-Ins',
                          _buildEarlyLateClockInsChart(attendance),
                        ),
                        const SizedBox(height: 20), // Add bottom padding
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: Text('No Attendance data available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

// Widget to build the Summary Card
  Widget _buildSummaryCard(List<AttendanceModel> attendance) {
    final totalHoursWorked = attendance.fold<double>(
        0,
            (previousValue, element) =>
        previousValue +
            DateHelper.calculateHoursWorked(element.clockIn!, element.clockOut ?? ''));
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container( // Wrap content in a Container for gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,  // Very light red at the top
              Colors.white,        // White in the middle
              Colors.black12,      // Very light black (almost gray) at the bottom
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Darker text color for contrast
              ),
            ),
            const SizedBox(height: 10),
            _buildSummaryRow('Total Days Selected:', '${(_endDate.difference(_startDate).inDays) + 1}'),
            _buildSummaryRow('Total Days Worked: ', '${attendance.length}'),
            _buildSummaryRow('Total Hours Worked:', '${totalHoursWorked.toStringAsFixed(1)} hours'),
            // ... Add more summary items as needed ...
          ],
        ),
      ),
    );
  }

  // Widget to build chart cards
  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 400, // Set an explicit height for the chart containers
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildClockInOutTrendsChart(List<AttendanceModel> attendanceData) {
    final timeFormat = DateFormat('hh:mm a');
    final filteredAttendanceData = attendanceData
        .where((data) => data.clockIn != null && data.clockOut != null && data.clockOut != "--/--")
        .toList();

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: 'Days'),
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Time of Day'),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'Clock-In: point.yClockIn\nClock-Out: point.yClockOut',
      ),
      series: <CartesianSeries<AttendanceModel, String>>[
        LineSeries<AttendanceModel, String>(
          dataSource: filteredAttendanceData,
          xValueMapper: (data, _) => DateFormat('dd-MMM').format(DateFormat('dd-MMMM-yyyy').parse(data.date!)),
          yValueMapper: (data, _) {
            DateTime clockIn = timeFormat.parse(data.clockIn!);
            return clockIn.hour + (clockIn.minute / 60);
          },
          name: 'Clock-In',
          color: Colors.green,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Text(
                timeFormat.format(timeFormat.parse(data.clockIn)),
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        LineSeries<AttendanceModel, String>(
          dataSource: filteredAttendanceData,
          xValueMapper: (data, _) => DateFormat('dd-MMM').format(DateFormat('dd-MMMM-yyyy').parse(data.date!)),
          yValueMapper: (data, _) {
            DateTime clockOut = timeFormat.parse(data.clockOut!);
            return clockOut.hour + (clockOut.minute / 60);
          },
          name: 'Clock-Out',
          color: Colors.red,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Text(
                timeFormat.format(timeFormat.parse(data.clockOut)),
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationWorkedDistributionChart(List<AttendanceModel> attendanceData) {
    return SfCartesianChart(
      primaryXAxis: const NumericAxis(
        title: AxisTitle(text: 'Duration of Hours Worked'),
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Frequency'),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <HistogramSeries<AttendanceModel, double>>[
        HistogramSeries<AttendanceModel, double>(
          dataSource: attendanceData,
          yValueMapper: (data, _) => DateHelper.calculateHoursWorked(data.clockIn!, data.clockOut ?? ''),
          binInterval: 1,
          color: Colors.purple,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      ],
    );
  }

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

  Widget _buildAttendanceByLocationChart(List<AttendanceModel> attendanceData) {
    List<LocationRecord> locationData = _getLocationData(attendanceData);
    return SfCircularChart(
      title: const ChartTitle(text: 'Attendance by Location'),
      legend: const Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<LocationRecord, String>(
          dataSource: locationData,
          xValueMapper: (LocationRecord data, _) => data.location,
          yValueMapper: (LocationRecord data, _) => data.attendanceCount,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildEarlyLateClockInsChart(List<AttendanceModel> attendanceData) {
    final timeFormat = DateFormat('hh:mm a');
    List<Map<String, dynamic>> chartData = attendanceData.map((record) {
      int earlyLateMinutes = DateHelper.calculateEarlyLateTime(record.clockIn);
      DateTime date = DateFormat('dd-MMMM-yyyy').parse(record.date!);
      return {
        'date': DateFormat('dd-MMM').format(date),
        'earlyLateMinutes': earlyLateMinutes,
        'clockInTime': timeFormat.format(timeFormat.parse(record.clockIn!)),
      };
    }).toList();
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: 'Days'),
      ),
      primaryYAxis: NumericAxis(
        title: const AxisTitle(text: 'Minutes Before/After 8:00 AM'),
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
          pointColorMapper: (data, _) => (data['earlyLateMinutes'] as int) >= 0 ? Colors.red : Colors.green,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              return Text(
                '${data['clockInTime']} (${data['earlyLateMinutes']} mins)',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
      ],
    );
  }

  Row _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: ', style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}