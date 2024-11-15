import 'package:attendanceapp/model/leave_request_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import the package
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../model/attendancemodel.dart';
import '../../model/bio_model.dart';
import '../../model/remaining_leave_model.dart';
import '../../services/isar_service.dart';




class LeaveRequestsPage1 extends StatefulWidget {
  final IsarService service;

  const LeaveRequestsPage1({Key? key, required this.service}) : super(key: key);

  @override
  _LeaveRequestsPage1State createState() => _LeaveRequestsPage1State();
}

class _LeaveRequestsPage1State extends State<LeaveRequestsPage1> {
  int _totalAnnualLeaves = 10;
  int _totalPaternityLeaves = 6;
  int _totalMaternityLeaves = 60;
  int _totalHolidayLeaves = 0; // Or a default limit if you want
  int _usedAnnualLeaves = 0;
  int _usedPaternityLeaves = 0;
  int _usedMaternityLeaves = 0;

  int? _usedAnnualLeaves1;
  int? _usedPaternityLeaves1;
  int? _usedMaternityLeaves1;
  int _usedHolidayLeaves = 0;
  String _selectedLeaveType = 'Annual';
  late RemainingLeaveModel _remainingLeaves; // Store remaining leaves
  late Isar isar;
  final TextEditingController _reasonController = TextEditingController();
  PickerDateRange? _selectedDateRange;
  List<LeaveRequestModel> _leaveRequests = [];
  bool _isarInitialized = false;
  String? _selectedSupervisor;
  String? _selectedSupervisorEmail;
  BioModel? _bioInfo;
  late LeaveRequestModel _leaveRequestInfo;

  @override
  void initState() {
    super.initState();
    //_init();
    // _openIsar();
    // _initialize(); // Call the initialization logic
  }

  Future<void> _init() async {
    if (_isarInitialized) return; // Prevent re-initialization
    print("Starting _init");

    // Initialize `isar` and fetch `_bioInfo`
    isar = await widget.service.openDB();
    final bioInfo = await widget.service.getBioInfoWithFirebaseAuth();

    // Check if bioInfo is null (if necessary)
    if (bioInfo == null) {
      throw Exception("Failed to fetch bioInfo from the service");
    }

    // Initialize remaining leaves after `_bioInfo` is set
    final remainingLeaves = await _initializeRemainingLeaveModel(bioInfo);
    await _getLeaveData();

    // Update state
    if (mounted) {
      setState(() {
        _bioInfo = bioInfo;
        _remainingLeaves = remainingLeaves;
        _isarInitialized = true;
      });
    }

    print("Finished _init");
  }


  Future<RemainingLeaveModel> _initializeRemainingLeaveModel(BioModel bioInfo) async {
    var remainingLeave = await isar.remainingLeaveModels
        .filter()
        .staffIdEqualTo(bioInfo.firebaseAuthId!)
        .findFirst();

    if (remainingLeave == null) {
      remainingLeave = RemainingLeaveModel()
        ..staffId = bioInfo.firebaseAuthId!
        ..annualLeaveBalance = await _calculateInitialAnnualLeave()
        ..holidayLeaveBalance = await _calculateInitialHoliday()
        ..paternityLeaveBalance = (bioInfo.gender == 'Male' && bioInfo.maritalStatus == 'Married')
            ? _totalPaternityLeaves
            : 0
        ..maternityLeaveBalance = (bioInfo.gender == 'Female' && bioInfo.maritalStatus == 'Married')
            ? _totalMaternityLeaves
            : 0;


      await isar.writeTxn(() => isar.remainingLeaveModels.put(remainingLeave!));
    } else{
      setState(() {
        _usedPaternityLeaves = _totalPaternityLeaves -remainingLeave!.paternityLeaveBalance!;
        _usedMaternityLeaves =_totalMaternityLeaves -remainingLeave!.maternityLeaveBalance!;
        _usedAnnualLeaves = _totalAnnualLeaves - remainingLeave!.annualLeaveBalance! ;
      });
    }

    return remainingLeave;
  }


  Future<int> _calculateInitialAnnualLeave() async {
    final now = DateTime.now();
    final currentYear = now.year;

    // Define October 1st for the current and previous years
    final octoberFirstCurrentYear = DateTime(currentYear, 10, 1);
    final octoberFirstPreviousYear = DateTime(currentYear - 1, 10, 1);

    // Determine the start date
    final start = now.isAfter(octoberFirstCurrentYear)
        ? octoberFirstCurrentYear
        : octoberFirstPreviousYear;

    final annualLeaveRecords = await isar.attendanceModels
        .filter()
        .durationWorkedEqualTo('Annual Leave')
        .offDayEqualTo(true)
        .dateBetween(
      DateFormat('dd-MMMM-yyyy').format(start),
      DateFormat('dd-MMMM-yyyy').format(now),
    ).findAll();

    // Count records excluding weekends
    final leaveDaysExcludingWeekends = annualLeaveRecords.where((date) {
      final recordDate = DateFormat('dd-MMMM-yyyy').parse(date.date!);
      return recordDate.weekday != DateTime.saturday &&
          recordDate.weekday != DateTime.sunday;
    }).length;

  //  print("annualLeaveRecords = ${annualLeaveRecords.length}");
   // print("leaveDaysExcludingWeekends = $leaveDaysExcludingWeekends");

    return (_totalAnnualLeaves - leaveDaysExcludingWeekends).clamp(0, _totalAnnualLeaves);
   }

  Future<int> _calculateInitialHoliday() async {
    print("holidayLeaveRecords Here");
    final now = DateTime.now();
    final currentYear = now.year;

    // Define October 1st for the current and previous years
    final octoberFirstCurrentYear = DateTime(currentYear, 10, 1);
    final octoberFirstPreviousYear = DateTime(currentYear - 1, 10, 1);

    // Determine the start date
    final start = now.isAfter(octoberFirstCurrentYear)
        ? octoberFirstCurrentYear
        : octoberFirstPreviousYear;

    final holidayRecords = await isar.attendanceModels
        .filter()
        .durationWorkedEqualTo('Holiday')
        //.offDayEqualTo(true)
        .dateBetween(
      DateFormat('dd-MMMM-yyyy').format(start),
      DateFormat('dd-MMMM-yyyy').format(now),
    ).findAll();


    // Count records excluding weekends
    final holidayDaysExcludingWeekends = holidayRecords.where((date) {
      final recordDate = DateFormat('dd-MMMM-yyyy').parse(date.date!);
      return recordDate.weekday != DateTime.saturday &&
          recordDate.weekday != DateTime.sunday;
    }).length;

  //  print("holidayLeaveRecords = ${holidayRecords.length}");
   // print("holidayDaysExcludingWeekends = $holidayDaysExcludingWeekends");
    return holidayDaysExcludingWeekends;

  }


  Future<LeaveRequestModel> _getOrCreateLeaveRequestModel(String userId) async {
    final existingRequest = await isar.leaveRequestModels.filter().staffIdEqualTo(userId).findFirst();

    if (existingRequest != null) {
      return existingRequest;
    } else {
      final newRequest = LeaveRequestModel()
        ..staffId = userId
        // ..annualLeaveBalance = _totalAnnualLeaves
        // ..paternityLeaveBalance = (_bioInfo.gender == 'Male' && _bioInfo.maritalStatus == 'Married') ? _totalPaternityLeaves : 0
        // ..maternityLeaveBalance = (_bioInfo.gender == 'Female' && _bioInfo.maritalStatus == 'Married') ? _totalMaternityLeaves : 0
        // ..holidayLeaveBalance = _totalHolidayLeaves
        ..endDate = DateTime.now()
        ..startDate = DateTime.now()
        ..leaveRequestId = const Uuid().v4()
        ..reason = "Annual Leave"
        ..selectedSupervisor = "Super User"
        ..selectedSupervisorEmail = "superuser@ccfng.org"
        ..type = "Annual";

      await isar.writeTxn(() async => await isar.leaveRequestModels.put(newRequest));
      return newRequest;
    }
  }


  Future<void> _getLeaveData() async {
    print("Starting getLeaveData");
    final userLeaveRequests = await isar.leaveRequestModels
        .filter()
        .staffIdEqualTo(_bioInfo?.firebaseAuthId!)
        .findAll();



    if (mounted) {
      setState(() {
        _leaveRequests = userLeaveRequests;
      });
    }

    print("Finished getLeaveData");
    await _checkAndUpdateLeaveStatus();
  }



  // Update leave balances based on approved leaves
  void _updateLeaveBalances() {
    _usedAnnualLeaves = 0;
    _usedPaternityLeaves = 0;
    _usedMaternityLeaves = 0;
    _usedHolidayLeaves = 0;

    for (final request in _leaveRequests) {
      if (request.status == 'Approved' && request.startDate != null && request.endDate != null) {
        final leaveDuration = _calculateLeaveDuration(request.type!, request.startDate!, request.endDate!);
        switch (request.type) {
          case 'Annual':
            _usedAnnualLeaves += leaveDuration;
            break;
          case 'Paternity':
            _usedPaternityLeaves += leaveDuration;
            break;
          case 'Maternity':
            _usedMaternityLeaves += leaveDuration;
            break;
          case 'Holiday':
            _usedHolidayLeaves += leaveDuration;
            break;
        }
      }
    }

    // Ensure used leaves don't exceed total allocated leaves
    _usedAnnualLeaves = _usedAnnualLeaves.clamp(0, _totalAnnualLeaves);
    _usedPaternityLeaves = _usedPaternityLeaves.clamp(0, _totalPaternityLeaves);
    _usedMaternityLeaves = _usedMaternityLeaves.clamp(0, _totalMaternityLeaves);
    // Holiday leaves might not have a limit

    setState(() {}); // Rebuild UI with updated balances
  }


  Widget _buildLeaveSummaryItem(String leaveType, int used, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to edges
            children: [

              Text("$leaveType Leave:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)), // Style adjustments

              Text("$used Used, ${total - used} Remaining", style: TextStyle(fontSize: 14)), // Usage/Remaining info
            ],
          ),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: total > 0 ? used.toDouble() / total : 0,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveSummaryItem1(String leaveType, int used, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to edges
            children: [
             Text("No of $leaveType(s) observed:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),// Style adjustments
              Text("$used Observed", style: TextStyle(fontSize: 14))
            ],
          ),
          // LinearPercentIndicator(
          //   lineHeight: 10,
          //   percent: total > 0 ? used.toDouble() / total : 0,
          //   progressColor: Colors.blue,
          //   backgroundColor: Colors.grey[300],
          // ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _isarInitialized ? Future.value() : _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return _buildMainScaffold();
        }
      },
    );
  }


  Widget _buildMainScaffold() { //Widget builds the main scaffold
    List<Widget> leaveSummaryItems = []; //Create a list of widget for leave summary items



    //Create Leave Summary Items
    leaveSummaryItems.add(
        _buildLeaveSummaryItem("Annual", _totalAnnualLeaves - (_remainingLeaves?.annualLeaveBalance ?? 0), _totalAnnualLeaves)); //Safe null checks


    if (_bioInfo?.maritalStatus == 'Married') {
      if (_bioInfo?.gender == 'Male') {
        leaveSummaryItems.add(
          _buildLeaveSummaryItem("Paternity", _totalPaternityLeaves - (_remainingLeaves?.paternityLeaveBalance ?? 0), _totalPaternityLeaves),
        );
      } else {
        leaveSummaryItems.add(
          _buildLeaveSummaryItem("Maternity", _totalMaternityLeaves - (_remainingLeaves?.maternityLeaveBalance ?? 0), _totalMaternityLeaves),
        );
      }
    }
    leaveSummaryItems.add(_buildLeaveSummaryItem1("Holiday", _totalHolidayLeaves + (_remainingLeaves?.holidayLeaveBalance ?? 0), _totalHolidayLeaves));



    return Scaffold( //Build Scaffold. Now you can safely access _remainingLeaves and _bioInfo here
      appBar: AppBar(
        title: const Text("Leave Requests"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCircularPercentIndicator(),
            Card(
              margin: const EdgeInsets.only(top: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Leave Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...leaveSummaryItems,
                  ],
                ),
              ),
            ),
            _buildLeaveRequestsCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showApplyLeaveBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );


  }


  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }



  void _showApplyLeaveBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            List<Widget> leaveTypeButtons = [];

            if (_bioInfo?.maritalStatus == 'Married') {
              if (_bioInfo?.gender == 'Male') {
                leaveTypeButtons.addAll([
                  _leaveTypeButton(setState, 'Paternity', 'Paternity Leave'),
                  _leaveTypeButton(setState, 'Annual', 'Annual Leave'),
                ]);
              } else {
                leaveTypeButtons.addAll([
                  _leaveTypeButton(setState, 'Maternity', 'Maternity Leave'),
                  _leaveTypeButton(setState, 'Annual', 'Annual Leave'),
                ]);
              }
            } else {
              leaveTypeButtons.add(_leaveTypeButton(setState, 'Annual', 'Annual Leave'));
            }

            leaveTypeButtons.add(_leaveTypeButton(setState, 'Holiday', 'Holidays'));


            return SingleChildScrollView( // Wrap with SingleChildScrollView
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch across width
                  children: <Widget>[
                    // ... (rest of the bottom sheet content)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: leaveTypeButtons,
                    ),
                    // ... (date picker, reason field, supervisor dropdown)
                    // Date Range Picker
                    SfDateRangePicker(
                      onSelectionChanged: (args) {
                        _onSelectionChanged(args, setState);
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                        DateTime.now(),
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                      headerStyle: const DateRangePickerHeaderStyle(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      todayHighlightColor: Colors.red,
                    ),
                    // Other Leave Details
                    TextFormField(
                      controller: _reasonController, // Use a controller
                      decoration: const InputDecoration(labelText: "Reason(s) For been Out-Of-Office"),
                    ),

                    FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: _fetchSupervisorsFromIsar(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No supervisors found.');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: _selectedSupervisor,
                            hint: const Text('Select Supervisor'),
                            onChanged: (newValue) async {


                              setState(() {
                                _selectedSupervisor = newValue;

                              });

                              List<String?> supervisorsemail = await widget.service.getSupervisorEmailFromIsar(_bioInfo?.department,newValue);


                              setState(() {
                                _selectedSupervisorEmail = supervisorsemail[0];

                              });
                              print(_selectedSupervisorEmail);

                            },
                            items: snapshot.data,
                            decoration: const InputDecoration(labelText: 'Supervisor'),
                          );
                        }
                      },
                    ),



                    SizedBox(height: 16.0), // Add spacing between dropdown and buttons

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space buttons
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _handleSaveAndSubmit(context, setState);
                          },
                          child: Text("Save Request"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }




  Widget _leaveTypeButton(StateSetter setState, String type, String label) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedLeaveType = type),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedLeaveType == type ? Colors.blue : Colors.grey,
      ),
      child: Text(label),
    );
  }


  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs args, StateSetter setState) {
    _selectedDateRange = args.value;
    setState(() {});
  }




  Future<List<DropdownMenuItem<String>>> _fetchSupervisorsFromIsar() async {
    final userBio = await widget.service.getBioInfoForUser();
    final supervisors = await widget.service.getSupervisorsFromIsar(userBio[0].department, userBio[0].state);

    return supervisors.map((supervisor) => DropdownMenuItem<String>(
      value: supervisor,
      child: Text(supervisor!),
    )).toList();
  }

  Widget _buildCircularPercentIndicator() {
    int totalLeaves;
    int usedLeaves;


    if (_bioInfo?.maritalStatus == 'Married') {
      if (_bioInfo?.gender == 'Male') {
        totalLeaves = _totalAnnualLeaves + _totalPaternityLeaves;
        usedLeaves = _usedAnnualLeaves + _usedPaternityLeaves;
      } else { // Female
        totalLeaves = _totalMaternityLeaves;  // Maternity leave includes annual leave
        usedLeaves = _usedMaternityLeaves ;     // Reduce if some annual is part of it. This part need clarity
      }
    } else { // Other marital statuses
      totalLeaves = _totalAnnualLeaves;
      usedLeaves = _usedAnnualLeaves;

    }


    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width * 0.2, // Responsive radius
              lineWidth: 10.0,
              percent: totalLeaves > 0 ? usedLeaves / totalLeaves : 0,
              center: Text(
                "$totalLeaves", // Total available across leave types
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              progressColor: Colors.blue,
              backgroundColor: Colors.grey,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Used", usedLeaves, Colors.blue),
                _buildSummaryItem("Balance", totalLeaves-usedLeaves, Colors.grey),

              ],
            ),

          ],

        ),
      ),
    );
  }



  Widget _buildLeaveRequestsCard() {
    return Card(
      margin: const EdgeInsets.only(top: 16.0), // Add margin to the top
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Leave Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_leaveRequests.isEmpty)
              const Center(child: Text("No leave requests found."))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _leaveRequests.length,
                itemBuilder: (context, index) {
                  final leaveRequest = _leaveRequests[index];
                  return ListTile(
                    title: Text(leaveRequest.type!),
                    subtitle: Text('${DateFormat('yyyy-MM-dd').format(leaveRequest.startDate!)} - ${DateFormat('yyyy-MM-dd').format(leaveRequest.endDate!)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                      [
                        Icon(
                          _getStatusIcon(leaveRequest.status),
                          color: _getStatusColor(leaveRequest.status),
                        ),
                        const SizedBox(width: 8),
                        Text(leaveRequest.status!),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditLeaveBottomSheet(context, leaveRequest);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, leaveRequest);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.sync),

                          onPressed: () {

                            _handleSync(leaveRequest);


                          },


                        ),
                      ],
                    ),


                  );

                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSync(LeaveRequestModel newLeaveRequest) async{
    await _submitLeaveRequest(newLeaveRequest, context);
  }


  void _showEditLeaveBottomSheet(BuildContext context, LeaveRequestModel leaveRequest) {
    // Set initial values for the bottom sheet fields
    _selectedLeaveType = leaveRequest.type!;
    _reasonController.text = leaveRequest.reason!;
    _selectedDateRange = PickerDateRange(leaveRequest.startDate, leaveRequest.endDate);
    _selectedSupervisor = leaveRequest.selectedSupervisor;
    _selectedSupervisorEmail = leaveRequest.selectedSupervisorEmail;



    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            List<Widget> leaveTypeButtons = [];

            if (_bioInfo?.maritalStatus == 'Married') {
              if (_bioInfo?.gender == 'Male') {
                leaveTypeButtons.addAll([
                  _leaveTypeButton(setState, 'Paternity', 'Paternity Leave'),
                  _leaveTypeButton(setState, 'Annual', 'Annual Leave'),
                ]);
              } else {
                leaveTypeButtons.addAll([
                  _leaveTypeButton(setState, 'Maternity', 'Maternity Leave'),
                  _leaveTypeButton(setState, 'Annual', 'Annual Leave'),
                ]);
              }
            } else {
              leaveTypeButtons.add(_leaveTypeButton(setState, 'Annual', 'Annual Leave'));
            }

            leaveTypeButtons.add(_leaveTypeButton(setState, 'Holiday', 'Holidays'));


            return SingleChildScrollView( // Wrap with SingleChildScrollView
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch across width
                  children: <Widget>[
                    // ... (rest of the bottom sheet content)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: leaveTypeButtons,
                    ),
                    // ... (date picker, reason field, supervisor dropdown)
                    // Date Range Picker
                    SfDateRangePicker(
                      onSelectionChanged: (args) {
                        _onSelectionChanged(args, setState);
                      },
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                        DateTime.now(),
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                      headerStyle: const DateRangePickerHeaderStyle(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      todayHighlightColor: Colors.red,
                    ),
                    // Other Leave Details
                    TextFormField(
                      controller: _reasonController, // Use a controller
                      decoration: const InputDecoration(labelText: "Reason(s) For been Out-Of-Office"),
                    ),

                    FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: _fetchSupervisorsFromIsar(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No supervisors found.');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: _selectedSupervisor,
                            hint: const Text('Select Supervisor'),
                            onChanged: (newValue) async {


                              setState(() {
                                _selectedSupervisor = newValue;

                              });

                              List<String?> supervisorsemail = await widget.service.getSupervisorEmailFromIsar(_bioInfo?.department,newValue);


                              setState(() {
                                _selectedSupervisorEmail = supervisorsemail[0];

                              });
                              print(_selectedSupervisorEmail);

                            },
                            items: snapshot.data,
                            decoration: const InputDecoration(labelText: 'Supervisor'),
                          );
                        }
                      },
                    ),



                    SizedBox(height: 16.0), // Add spacing between dropdown and buttons

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space buttons
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _handleUpdateLeaveRequest(context, leaveRequest, setState); // Add setState here
                          },
                          child: Text("Update"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _handleUpdateLeaveRequest(BuildContext context, LeaveRequestModel leaveRequest, StateSetter setState) async{
    try {
      leaveRequest.type = _selectedLeaveType;
      leaveRequest.startDate = _selectedDateRange!.startDate;
      leaveRequest.endDate = _selectedDateRange!.endDate ?? _selectedDateRange!.startDate;
      leaveRequest.reason = _reasonController.text;
      leaveRequest.selectedSupervisor = _selectedSupervisor;
      leaveRequest.selectedSupervisorEmail = _selectedSupervisorEmail;


      await _saveLeaveRequest(leaveRequest);
      await _updateLeaveBalanceAfterApproval(leaveRequest);

      try{
        // Update Firestore
        await FirebaseFirestore.instance
            .collection('Staff')
            .doc(leaveRequest.staffId)
            .collection('Leave Request')
            .doc(leaveRequest.leaveRequestId)
            .update(leaveRequest.toJson());

      }catch(e){}

      // // Update Remaining leave Balance
      // final updatedLeaveRequest2 = await isar.remainingLeaveModels
      //     .filter()
      //     .staffIdEqualTo(_bioInfo.firebaseAuthId!)
      //     .findFirst();
      //
      // if (updatedLeaveRequest2 != null) {
      //   setState(() {
      //     updatedLeaveRequest2.annualLeaveBalance = _leaveRequestInfo.annualLeaveBalance;
      //     updatedLeaveRequest2.paternityLeaveBalance = _leaveRequestInfo.paternityLeaveBalance;
      //     updatedLeaveRequest2.maternityLeaveBalance = _leaveRequestInfo.maternityLeaveBalance;
      //
      //   });
      //   await isar.writeTxn(() async => await isar.remainingLeaveModels.put(updatedLeaveRequest2));
      // }


      // Update status to Pending after updating Firestore
      await isar.writeTxn(() async {
        leaveRequest.status = 'Pending';
        await isar.leaveRequestModels.put(leaveRequest);
      });

      if (mounted) { // Add mounted check
        Navigator.of(context).pop(); // Close the bottom sheet
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
   //         content: Text("Leave Request updated successfully")));
        Fluttertoast.showToast(
            msg: "Leave Request updated successfully",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }




    } catch (e) {
      // Handle any errors
      print("Error updating leave request: $e");
      if (mounted) {
       // ScaffoldMessenger.of(context).showSnackBar(
          //  const SnackBar(content: Text("Failed to update leave request.")));
        Fluttertoast.showToast(
            msg: "Failed to update leave request.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);

      }

    }

  }



  void _showDeleteConfirmationDialog(BuildContext context, LeaveRequestModel leaveRequest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this leave request?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                try {
                  // Delete from Firestore first
                  await FirebaseFirestore.instance
                      .collection('Staff')
                      .doc(leaveRequest.staffId)
                      .collection('Leave Request')
                      .doc(leaveRequest.leaveRequestId)
                      .delete();

                  // Delete from Isar
                  await isar.writeTxn(() async => await isar.leaveRequestModels.delete(leaveRequest.id));
                  // Refresh the UI
                  _getLeaveData();

                  if(mounted){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Leave Request deleted successfully")));
                  }


                } catch (e) {
                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete Leave Request")));
                  }
                  print("Error deleting leave request: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }






  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Approved': return Icons.check_circle;
      case 'Rejected': return Icons.cancel;
      case 'Pending': return Icons.access_time;
      default: return Icons.help;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved': return Colors.green;
      case 'Rejected': return Colors.red;
      case 'Pending': return Colors.orange;
      default: return Colors.grey;
    }
  }



  Future<void> _handleSaveAndSubmit(
      BuildContext context, StateSetter setState) async {

    if (_selectedDateRange == null ||
        _reasonController.text.isEmpty ||
        _selectedSupervisor == null) {
      Fluttertoast.showToast(
          msg: "Please fill all fields.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    final leaveDuration = _calculateLeaveDuration(
      _selectedLeaveType,
      _selectedDateRange!.startDate!,
      _selectedDateRange!.endDate ?? _selectedDateRange!.startDate!,
    );


    if (leaveDuration <= 0) {
      Fluttertoast.showToast(
          msg: "Selected dates are invalid.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }

    // Validation for leave duration based on type
    switch (_selectedLeaveType) {
      case 'Annual':
        if (leaveDuration > _remainingLeaves.annualLeaveBalance!) {
          _showLeaveExceedsBalanceError(context, 'Annual', _remainingLeaves.annualLeaveBalance!);
          return;
        }
        break;
      case 'Paternity':
        if (leaveDuration > _remainingLeaves.paternityLeaveBalance!) {
          _showLeaveExceedsBalanceError(context, 'Paternity', _remainingLeaves.paternityLeaveBalance!);
          return;
        }
        break;
      case 'Maternity':
        if (leaveDuration > _remainingLeaves.maternityLeaveBalance!) {
          _showLeaveExceedsBalanceError(context, 'Maternity', _remainingLeaves.maternityLeaveBalance!);
          return;
        }
        break;
    }


    final newLeaveRequest = LeaveRequestModel()
      ..type = _selectedLeaveType
      ..startDate = _selectedDateRange!.startDate
      ..endDate = _selectedDateRange!.endDate ?? _selectedDateRange!.startDate
      ..reason = _reasonController.text
      ..staffId = _bioInfo?.firebaseAuthId
      ..selectedSupervisor = _selectedSupervisor
      ..selectedSupervisorEmail = _selectedSupervisorEmail
      ..leaveDuration = leaveDuration
      ..status = 'Pending'
      ..leaveRequestId = const Uuid().v4(); // Generate UUID for leaveRequestId




    // The await calls don't return a value, so just await them directly
    try {
      await _saveLeaveRequest(newLeaveRequest);  // Save to Isar

      if (mounted) {
        Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Leave request saved locally.")));
        Fluttertoast.showToast(
            msg: "Request saved locally.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {}); // Rebuild to show saved request.


      }

    } catch (error) {
      // Handle any errors during submission
      print("Error in Save and Submit: $error");
      // Show an error message to the user if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again.")),
        );
      }

    }

  }


  void _showLeaveExceedsBalanceError(BuildContext context, String leaveType, int remainingBalance) {
    Fluttertoast.showToast(
      msg: "$leaveType leave cannot exceed $remainingBalance working days. You have $remainingBalance days remaining.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }


  int _calculateLeaveDuration(String leaveType, DateTime startDate, DateTime endDate) {
    int duration = endDate.difference(startDate).inDays + 1;
    if (leaveType == 'Annual') {
      for (var date = startDate; !date.isAfter(endDate); date = date.add(const Duration(days: 1))) {
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          duration--;
        }
      }
    }
    return duration;
  }




  Future<void> _saveLeaveRequest(LeaveRequestModel leaveRequest) async {
    await isar.writeTxn(() async => await isar.leaveRequestModels.put(leaveRequest));
  }



  Future<void> _submitLeaveRequest(LeaveRequestModel leaveRequest, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final staffCollection =
        FirebaseFirestore.instance.collection('Staff').doc(user.uid);
        final leaveRequestCollection = staffCollection.collection('Leave Request');

        // Use the leaveRequestId from the Isar record as the document ID in Firestore
        final leaveRequestId = leaveRequest.leaveRequestId; // Get leaveRequestId

        if (leaveRequestId != null) {  //Check if leaveRequestId exists for local requests
          await leaveRequestCollection.doc(leaveRequestId).set({ // Use set() with doc ID
            ...leaveRequest.toJson(),
            'leaveRequestId': leaveRequestId, // Include leaveRequestId in document

          });


          // Update isSynced flag in Isar after successful submission
          await isar.writeTxn(() async {
            leaveRequest.isSynced = true;
            await isar.leaveRequestModels.put(leaveRequest);
          });


          // Refresh leave data and UI
          _getLeaveData(); // Or setState(() {});
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Leave request synced successfully.")));
          }


        }



      }
    } catch (e) {
      print("Error submitting leave request: $e");
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error syncing leave request. Please try again."),
        ));
      }
    }
  }


  Future<void> _checkAndUpdateLeaveStatus() async {
    try {
      final userLeaveRequests = await isar.leaveRequestModels
          .filter()
          .staffIdEqualTo(_bioInfo?.firebaseAuthId!)
          .findAll();

      for (final leaveRequest in userLeaveRequests) {
        try {  // Inner try-catch for each leave request
          final doc = await FirebaseFirestore.instance
              .collection('Staff')
              .doc(_bioInfo?.firebaseAuthId)
              .collection('Leave Request')
              .doc(leaveRequest.leaveRequestId) // Crucial: use the same ID
              .get();

          if (doc.exists) {
            final firestoreStatus = doc.data()?['status'] as String?;

            if (firestoreStatus != null && firestoreStatus != leaveRequest.status) {
              await isar.writeTxn(() async {
                leaveRequest.status = firestoreStatus;
                await isar.leaveRequestModels.put(leaveRequest);
              });



              if (firestoreStatus == 'Approved') {

                // Add attendance records (outside the deduction logic)
                await _addLeaveToAttendance1(_bioInfo?.firebaseAuthId, leaveRequest.startDate, leaveRequest.endDate, leaveRequest.type).then((_) async {
                  // Use safe access for leaveRequest properties
                  final leaveDuration = leaveRequest.leaveDuration ?? 0; // Provide default if null
                  await _deductLeaveBalance(leaveRequest, leaveDuration);
                });
                Fluttertoast.showToast(msg: "Leave Request Approved");
              } else if (firestoreStatus == 'Rejected') {
                Fluttertoast.showToast(msg: "Leave Request Rejected");
              }

              if (mounted) {
                setState(() {}); // Rebuild UI after updating status and balance
              }
            }
          }
        } catch (innerError) {
          print('Error processing individual leave request: $innerError');
          // Handle error for this specific leave request, e.g., log it
        }
      }
    } catch (e) {
      print('Error checking leave status: $e');
      Fluttertoast.showToast(msg: "Error syncing leave status");
    }
  }

  Future<void> _addLeaveAttendanceRecord(DateTime date, String leaveType) async {

    await widget.service.saveAttendance(
      AttendanceModel()
        ..clockIn = '08:00 AM'
        ..date = DateFormat('dd-MMMM-yyyy').format(date)
        ..clockInLatitude = 0.0
        ..clockInLocation = ""
        ..clockInLongitude = 0.0
        ..clockOut = '05:00 PM'
        ..clockOutLatitude = 0.0
        ..clockOutLocation = ""
        ..clockOutLongitude = 0.0
        ..isSynced = false
        ..voided = false
        ..isUpdated = true
        ..offDay = true // Set offDay to true for leave days
        ..durationWorked = leaveType
        ..noOfHours = 8.1
        ..month = DateFormat('MMMM yyyy').format(date),


    );
  }

  Future<void> _deductLeaveBalance(LeaveRequestModel leaveRequest, int daysToDeduct) async {
    //final updatedLeaveRequest = await isar.leaveRequestModels.filter().staffIdEqualTo(_bioInfo.firebaseAuthId!).findFirst();
    final updatedLeaveRequest = await isar.remainingLeaveModels // Use the correct collection
        .filter()
        .staffIdEqualTo(_bioInfo?.firebaseAuthId!)
        .findFirst();

    if (updatedLeaveRequest != null) {
      await isar.writeTxn(() async {
        switch (leaveRequest.type) {
          case 'Annual':
            updatedLeaveRequest.annualLeaveBalance = (updatedLeaveRequest.annualLeaveBalance! - daysToDeduct).clamp(0, _totalAnnualLeaves);
            break;
          case 'Paternity':
            updatedLeaveRequest.paternityLeaveBalance = (updatedLeaveRequest.paternityLeaveBalance! - daysToDeduct).clamp(0, _totalPaternityLeaves);
            break;
          case 'Maternity':
            updatedLeaveRequest.maternityLeaveBalance = (updatedLeaveRequest.maternityLeaveBalance! - daysToDeduct).clamp(0, _totalMaternityLeaves);
            break;
          case 'Holiday':
            updatedLeaveRequest.holidayLeaveBalance = (updatedLeaveRequest.holidayLeaveBalance! - daysToDeduct).clamp(0, _totalHolidayLeaves);
            break;
        }
        await isar.remainingLeaveModels.put(updatedLeaveRequest);
      });
    }
  }




  Future<void> _addLeaveToAttendance1(
      String? userId,
      DateTime? startDate,
      DateTime? endDate,
      String? leaveType,
      ) async {
    if (userId == null || startDate == null || endDate == null || leaveType == null) {
      print('Invalid input for _addLeaveToAttendance');
      return;
    }

    for (var date = startDate!; !date.isAfter(endDate!); date = date.add(const Duration(days: 1))) {
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        await widget.service.saveAttendance(
          AttendanceModel()
            ..clockIn = '08:00 AM'
            ..date = DateFormat('dd-MMMM-yyyy').format(date)
            ..clockInLatitude = 0.0
            ..clockInLocation = ""
            ..clockInLongitude = 0.0
            ..clockOut = '05:00 PM'
            ..clockOutLatitude = 0.0
            ..clockOutLocation = ""
            ..clockOutLongitude = 0.0
            ..isSynced = false
            ..voided = false
            ..isUpdated = true
            ..offDay = true // Set offDay to true for leave days
            ..durationWorked = leaveType
            ..noOfHours = 8.1
            ..month = DateFormat('MMMM yyyy').format(date),
        );



      }
    }

    _getLeaveData();


    Fluttertoast.showToast(
      msg: "Leave added to attendance records.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,

    );





  }


  Future<void> _updateLeaveBalanceAfterApproval(LeaveRequestModel leaveRequest) async {
    if (leaveRequest.status == 'Approved') {
      final leaveDuration = leaveRequest.leaveDuration;
      if (leaveDuration != null && leaveDuration > 0) {
        try {
          await isar.writeTxn(() async { // Important: Perform updates in a transaction
            switch (leaveRequest.type) {
              case 'Annual':
                _remainingLeaves.annualLeaveBalance = (_remainingLeaves.annualLeaveBalance! - leaveDuration).clamp(0, _totalAnnualLeaves);
                break;
              case 'Paternity':
                _remainingLeaves.paternityLeaveBalance = (_remainingLeaves.paternityLeaveBalance! - leaveDuration).clamp(0, _totalPaternityLeaves);
                break;
              case 'Maternity':
                _remainingLeaves.maternityLeaveBalance = (_remainingLeaves.maternityLeaveBalance! - leaveDuration).clamp(0, _totalMaternityLeaves);
                break;
              case 'Holiday':
                _remainingLeaves.holidayLeaveBalance = (_remainingLeaves.holidayLeaveBalance! - leaveDuration).clamp(0, _totalHolidayLeaves);
                break;
            }
            // Save the updated _remainingLeaves object:
            await isar.remainingLeaveModels.put(_remainingLeaves); // This is the crucial fix
          });

          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          print('Error updating leave balance: $e');
          // Handle the error appropriately (e.g., display an error message)
        }
      }
    }
  }


}