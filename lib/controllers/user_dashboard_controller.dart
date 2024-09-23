import 'package:attendanceapp/model/attendancemodel.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserDashBoardController extends GetxController {
  late IsarService service;
  UserDashBoardController(this.service);

  var firstName = "".obs;
  var lastName = "".obs;
  var firebaseAuthId = "".obs;
  var role = "".obs;
  var dataSet = <FlSpot>[].obs;
  var totalClockIns = 0.obs;
  var totalClockOuts = 0.obs;
  var totalHoursWorked = 0.0.obs;
  var totalHoursWorkedString = "".obs;
  var totalDaysOff = 0.obs;
  var selectedMonth = DateFormat("MMMM yyyy").format(DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    _getUserDetail();
  }

  Stream<List<AttendanceModel>> attendanceStream() {
    return service.getHourWorkedForMonth(selectedMonth.value);
  }

  Stream<List<AttendanceModel>> daysOffStream() {
    return service.getDaysOffForMonth(selectedMonth.value);
  }

  void updateAttendanceData(List<AttendanceModel> data) {
    dataSet.value = getPlotPoints(data);
    totalClockIns.value = getTotalClockIn(data);
    totalClockOuts.value = getTotalClockOut(data);
    totalHoursWorked.value = getTotalHoursWorked(data);
    totalHoursWorkedString.value = getTotalHoursandMins(totalHoursWorked.value);
  }

  void updateSelectedMonth(DateTime month) {
    selectedMonth.value = DateFormat('MMMM yyyy').format(month);
    dataSet.clear();
  }

  List<FlSpot> getPlotPoints(List<AttendanceModel> entireData) {
    List<FlSpot> dataSet = [];
    for (var specificMonthAttend in entireData) {
      // Add a null check for specificMonthAttend.date
      if (specificMonthAttend.date != null) {
        dataSet.add(
          FlSpot(
            (int.parse(specificMonthAttend.date!.split("-")[0])).toDouble(),
            (specificMonthAttend.noOfHours!).toDouble(),
          ),
        );
      } else {
        // Handle the case where the date is null (e.g., add a default FlSpot)
        dataSet.add(const FlSpot(0, 0)); // Example default
      }
    }
    return dataSet;
  }

  int getTotalClockIn(List<AttendanceModel> entireData) {
    List clockInSet = [];
    for (var clockLength in entireData) {
      if (clockLength.clockIn != "--/--") {
        clockInSet.add(clockLength.clockIn);
      }
    }
    return clockInSet.length;
  }

  int getTotalClockOut(List<AttendanceModel> entireData) {
    List clockOutSet = [];
    for (var clockLength in entireData) {
      if (clockLength.clockOut != "--/--") {
        clockOutSet.add(clockLength.clockOut);
      }
    }
    return clockOutSet.length;
  }

  double getTotalHoursWorked(List<AttendanceModel> entireData) {
    double totalHoursWorked = 0;
    for (var clockLength in entireData) {
      totalHoursWorked += clockLength.noOfHours!;
    }
    return totalHoursWorked;
  }

  String getTotalHoursandMins(double getTotal) {
    final hour = int.parse(getTotal.toString().split(".")[0]);
    final min = double.parse("0.${getTotal.toString().split(".")[1]}");
    final minute = min * 60;
    String inStringMin = minute.toStringAsFixed(0);
    int roundedMinDouble = int.parse(inStringMin);
    return ('$hour hours $roundedMinDouble minute(s)');
  }

  Future<int> getTotalDaysOff(String month) async {
    return await service.getCountForoffDay(month); // Correct method name
  }

  //Get Details from Isar database
  void _getUserDetail() async {
    final userDetail = await service.getBioInfoWithFirebaseAuth();
    firebaseAuthId.value = userDetail?.firebaseAuthId ?? "";
    firstName.value = userDetail?.firstName ?? "";
    lastName.value = userDetail?.lastName ?? "";
    role.value = userDetail?.role ?? "";
  }
}