import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attendanceapp/Tasks/task_manager_homepage.dart';
import 'package:attendanceapp/controllers/task_controller.dart';
import 'package:attendanceapp/services/isar_service.dart';
import 'package:attendanceapp/services/notification_services.dart';
import 'package:attendanceapp/widgets/drawer.dart';
import 'package:attendanceapp/model/report_model.dart';
import 'package:attendanceapp/model/bio_model.dart';

import '../Attendance/button.dart';

class DailyActivityMonitoringPage extends StatefulWidget {
  @override
  _DailyActivityMonitoringPageState createState() => _DailyActivityMonitoringPageState();
}

class _DailyActivityMonitoringPageState extends State<DailyActivityMonitoringPage> {
  List<String> tbReportIndicators = [
    "Total Number Newly Tested HIV Positive (HTS TST POSITIVE)",
    "TX NEW (Tx New is the number of new patients COMMENCED on ARVs during the week)",
    "No of new ART patients (TX NEW) clinically screened for TB",
    "Number of Presumptive cases Identified (among those TESTED Positive) (Subset of indicator 'Newly Tested HIV Positive')",
    "Number of Presumptive cases evaluated for LF LAM, GeneXpert, or other Test (among the HTS TST POS)",
    "Number of Patients with MTB detected or confirmed TB Positive Including LF LAM or other test",
    "Number of patients Commenced on TB treatment after GeneXpert or LF LAM Diagnosis",
    "Number of patients Less than 5 Years of age commenced on TB treatment after GeneXpert or LF LAM Diagnosis",
    "Total Number of Tx_New screened Negative",
    "Total Number of Tx New Eligible for TPT (INH)",
    "Total Number of Tx New Commenced on TPT (INH)",
    "ART patients already on treatment who came for drug refill ( Facility and other streams)",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) screened for TB",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) Screened positive ( Presumptive TB )",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) evaluated for TB",
    "Number of ART Patients already on treatment tested positive for TB",
    "Number of ART Patients already on treatment started TB Treatment",
    "Number of ART patients Less than 5 Years already on treatment started TB Treatment",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) Screened Negative ( Non presumptive Presumptive TB )",
    "ART patients already on treatment Completed IPT or already commenced IPT ( Subset of the Indicator above)",
    "ART patients already on treatment Eligible for IPT",
    "ART patients already on treatment Started on IPT",
    "TB STAT for the week (Number of Client started on TB treatment both HIV POS & Negative)",
    "Comments"
  ];

  List<String> vlReportIndicators = [
    "Number of clients that had their samples collected and documented in the Lab VL register",
    "Number of samples logged in through LIMS NMRS with generated manifest sent to the PCR lab",
    "Number of viral load results entered into the VL Register",
    "Comments"
  ];

  List<String> pharmTechReportIndicators = [
    "Number of Drug pickup as documented in the Daily Pharmacy worksheet",
    "Number of clients that had completed Tuberculosis Preventive Therapy (TPT)",
    "Number of commodity consumption data entered into NMRS commodity module",
    "Number of Patients with completed Adverse Drug Reaction screening form",
    "Comments"
  ];

  List<String> trackingAssistantReportIndicators = [
    "Number of Clients with a scheduled appointment",
    "Number of clients with a scheduled appointment given a reminder call of the expected appointment",
    "Number of clients with a scheduled appointment who missed appointment",
    "Number of clients with same day tracking for missed appointment",
    "Number of patient who are IIT that were tracked back",
    "Number of verbal autopsy done",
    "Comments"
  ];

  List<String> artNurseReportIndicators = [
    "proportion of Newly Diagnosed patients with baseline CD4 Test done (Denominator is 'Number of the Newly Diagnosed HIV Positive Clients')",
    "Number of those with baseline CD4 with CD4<200 cells/mm3",
    "Proportion of TB LF-LAM Screening done on individuals with CD4<200 cells/mm3 (Denominator is 'Number of those with baseline CD4 with CD4<200 cells/mm3')",
    "Number of TB LF-LAM Positive",
    "Proportion of Xpert Testing done for all TB LF-Lam positives individuals (Denominator is 'Number of TB LF-LAM Positive')",
    "Number of TB LF-LAM/Xpert testing Concurrence",
    "Proportion of CrAg Screening done for individual with CD4<200 cells/mm3 (Denominator is 'Number of TB LF-LAM/Xpert testing Concurrence')",
    "Number of CrAg Screening Positive",
    "Proportion of CrAg CSF done (Denominator is 'Number of CrAg Screening Positive')",
    "Number of diagnosed CCM",
    "Number of un-suppressed clients commenced on EAC",
    "Number of Unsuppressed clients in a cohort completing EAC",
    "Number of EID sample collected for eligible infants within 2 months of birth",
    "Number of AYP (Adolescents and Young Persons) enrolled into OTZ program",
    "Comments"
  ];

  List<String> htsReportIndicators = [
    "Number of the Newly Diagnosed HIV Positive Clients",
    "Number of Index clients with partners and family members tested",
    "Comments"
  ];

  List<String> siReportIndicators = [
    "Number of Tx_New Clients Entries entered on NMRS (EMR)",
    "Number of Existing Clients Entries entered on NMRS (EMR)",
    "Number of Viral Load results Entry on NMRS (EMR)",
    "Number of ANC Records Entry on NMRS (EMR)",
    "Number of Data entry for HTS on NMRS (EMR)",
    "Number of patients on ART having fingerprints captured on NMRS (EMR)",
    "Comments"
  ];

  // Initialize controllers directly in the class definition
  final Map<String, TextEditingController> tbReportControllers = {};
  final Map<String, TextEditingController> vlReportControllers = {};
  final Map<String, TextEditingController> pharmTechReportControllers = {};
  final Map<String, TextEditingController> trackingAssistantReportControllers = {};
  final Map<String, TextEditingController> artNurseReportControllers = {};
  final Map<String, TextEditingController> htsReportControllers = {};
  final Map<String, TextEditingController> siReportControllers = {};

  Map<String, String?> tbReportUsernames = {};
  Map<String, String?> vlReportUsernames = {};
  Map<String, String?> pharmTechReportUsernames = {};
  Map<String, String?> trackingAssistantReportUsernames = {};
  Map<String, String?> artNurseReportUsernames = {};
  Map<String, String?> htsReportUsernames = {};
  Map<String, String?> siReportUsernames = {};

  // Add new maps for Edited By usernames
  Map<String, String?> tbReportEditedUsernames = {};
  Map<String, String?> vlReportEditedUsernames = {};
  Map<String, String?> pharmTechReportEditedUsernames = {};
  Map<String, String?> trackingAssistantReportEditedUsernames = {};
  Map<String, String?> artNurseReportEditedUsernames = {};
  Map<String, String?> htsReportEditedUsernames = {};
  Map<String, String?> siReportEditedUsernames = {};


  String _currentUsername = "";

  String _selectedReportType = "Daily";
  String? _selectedReportPeriod;
  String? _selectedMonthForWeekly;
  List<String> _reportPeriodOptions = [];
  List<String> _monthlyOptions = [];
  Map<String, bool> _isEditingReportSection = {};
  Map<String, Report?> _loadedReports = {}; // Track loaded reports

  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedReportingDate = DateTime.now();
  bool _isLoading = true;

  final IsarService _isarService = IsarService();

  // Form keys for validation
  final GlobalKey<FormState> _htsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _artNurseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _trackingAssistantFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _tbFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _vlFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _pharmacyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _siFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();

    _initializeAsync();

    _monthlyOptions = _generateMonthlyOptions();
    _updateReportPeriodOptions(_selectedReportType);

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }


  Future<void> _initializeAsync() async {
    print("_initializeAsync: Starting initialization");
    await _initializeControllers(); // Initialize controllers first
    await _fetchUsername();
    await _loadReportsForSelectedDate(); // Load reports on init
    print("_initializeAsync: Reports loaded, initializing controllers");


    print("_initializeAsync: Controllers initialized");
  }

  Future<void> _fetchUsername() async {
    print("_fetchUsername: Fetching username");
    BioModel? bio = await _isarService.getBioInfoWithFirebaseAuth();
    setState(() {
      if (bio != null && bio.firstName != null && bio.lastName != null) {
        _currentUsername = "${bio.firstName!} ${bio.lastName!}";
      } else {
        _currentUsername = "Unknown User";
      }
    });
    print("_fetchUsername: Username fetched: $_currentUsername");
  }

  Future<void> _loadReportsForSelectedDate() async {
    print("_loadReportsForSelectedDate: Loading reports for date: $_selectedReportingDate");
    _loadedReports.clear(); // Clear previous loaded reports
    List<Report> reports = await _isarService.getReportsByDate(_selectedReportingDate);
    print("_loadReportsForSelectedDate: Fetched reports count: ${reports.length}");
    print("Loaded Reports: $reports");

    setState(() {

      for (var report in reports) {
        print("_loadReportsForSelectedDate: Processing report type: ${report.reportType}");
        _loadedReports[report.reportType!] = report;


        print("_loadReportsForSelectedDate: Loaded report for ${report.reportType}: ${_loadedReports[report.reportType!]}");
      }


      _updateControllerValuesFromLoadedReports(); // Update controllers with loaded data
    });
    print("_loadReportsForSelectedDate: Report loading and controller update complete.");
  }

  void _updateControllerValuesFromLoadedReports() {
    print("_updateControllerValuesFromLoadedReports: Updating controllers from loaded reports");
    _updateControllersFromReport(_loadedReports["tb_report"], tbReportControllers, tbReportIndicators, tbReportUsernames, tbReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["vl_report"], vlReportControllers, vlReportIndicators, vlReportUsernames, vlReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["pharmacy_report"], pharmTechReportControllers, pharmTechReportIndicators, pharmTechReportUsernames, pharmTechReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["tracking_report"], trackingAssistantReportControllers, trackingAssistantReportIndicators, trackingAssistantReportUsernames, trackingAssistantReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["art_nurse_report"], artNurseReportControllers, artNurseReportIndicators, artNurseReportUsernames, artNurseReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["hts_report"], htsReportControllers, htsReportIndicators, htsReportUsernames, htsReportEditedUsernames);
    _updateControllersFromReport(_loadedReports["si_report"], siReportControllers, siReportIndicators, siReportUsernames, siReportEditedUsernames);
    print("_updateControllerValuesFromLoadedReports: Controller update process completed.");
  }

  void _updateControllersFromReport(Report? report, Map<String, TextEditingController> controllers, List<String> indicators, Map<String, String?> usernames, Map<String, String?> editedUsernames) {
    String reportType = report?.reportType ?? 'unknown';
    print("_updateControllersFromReport: Updating controllers for report type: $reportType");
    if (report != null && report.reportEntries != null) {
      print("_updateControllersFromReport: Report entries found, processing entries.");
      for (var entry in report.reportEntries!) {
        print("_updateControllersFromReport: Entry Key from report: ${entry.key}"); // Print entry key
        if (controllers.containsKey(entry.key)) {
          print("_updateControllersFromReport: Found controller for key: ${entry.key}");
          print("_updateControllersFromReport: Current controller value for ${entry.key}: '${controllers[entry.key]!.text}'");
          print("_updateControllersFromReport: Setting controller value for ${entry.key} to: '${entry.value}'");
          controllers[entry.key]!.text = entry.value;
          usernames[entry.key] = entry.enteredBy; // Populate Entered By from report
          editedUsernames[entry.key] = entry.editedBy; // Populate Edited By from report
          print("_updateControllersFromReport: Controller value for ${entry.key} updated to: '${controllers[entry.key]!.text}'");
        } else {
          print("_updateControllersFromReport: No controller found for key: ${entry.key}");
        }
      }
      print("_updateControllersFromReport: All report entries processed for report type: $reportType");
    } else {
      print("_updateControllersFromReport: No report found or report entries are null for report type: $reportType. Resetting controllers.");
      _resetControllers(controllers, indicators, usernames, editedUsernames); // Reset if no report loaded
    }
    print("_updateControllersFromReport: Controller update for report type: $reportType finished.");
  }


  Future<void> _initializeControllers() async {
    print("_initializeControllers: Initializing all controllers");
    _initializeControllerMap(tbReportIndicators, tbReportControllers);
    _initializeControllerMap(vlReportIndicators, vlReportControllers);
    _initializeControllerMap(pharmTechReportIndicators, pharmTechReportControllers);
    _initializeControllerMap(trackingAssistantReportIndicators, trackingAssistantReportControllers);
    _initializeControllerMap(artNurseReportIndicators, artNurseReportControllers);
    _initializeControllerMap(htsReportIndicators, htsReportControllers);
    _initializeControllerMap(siReportIndicators, siReportControllers);
    print("_initializeControllers: All controllers initialized.");
  }

  void _initializeControllerMap(List<String> indicators, Map<String, TextEditingController> controllers) {
    for (String indicator in indicators) {
      controllers[indicator] = TextEditingController();
    }
  }


  void _updateReportPeriodOptions(String reportType) {
    setState(() {
      _selectedReportPeriod = null;
      _selectedMonthForWeekly = null;
      _reportPeriodOptions = reportType == "Daily" ? ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"] : [];
    });
  }

  List<String> _generateMonthlyOptions() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1);
      months.add(DateFormat("MMMM yyyy").format(monthDate));
    }
    return months;
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Text("Reporting Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedReportingDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null && pickedDate != _selectedReportingDate) {
              setState(() {
                _selectedReportingDate = pickedDate;
                _loadReportsForSelectedDate(); // Load reports when date changes
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('yyyy-MM-dd').format(_selectedReportingDate),
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorTextField({
    required Map<String, TextEditingController> controllers,
    required String indicator,
    required Map<String, String?> usernames,
    required Map<String, String?> editedUsernames, // Add editedUsernames map
    required bool isReadOnly,
    required VoidCallback onEditPressed,
  }) {
    TextInputType keyboardType = indicator == "Comments" ? TextInputType.multiline : TextInputType.number;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isReadOnly ? Text(controllers[indicator]!.text.isNotEmpty ? "${indicator}: ${controllers[indicator]!.text}" : "$indicator: Not Entered (Click Edit)", style: TextStyle(fontSize: 16)) :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: controllers[indicator],
                  keyboardType: keyboardType,
                  maxLines: indicator == "Comments" ? 3 : 1,
                  readOnly: isReadOnly,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    suffixIcon: isReadOnly ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onEditPressed,
                    ) : null,
                  ),
                  validator: (value) {
                    if (indicator != "Comments" && (value == null || value.isEmpty)) {
                      return 'Please enter value for $indicator';
                    }
                    return null;
                  },
                  onChanged: isReadOnly ? null : (value) {
                    setState(() {
                      editedUsernames[indicator] = _currentUsername; // Update Edited By username on change
                    });
                  },
                ),
              ),
            ],
          ),
          if (usernames[indicator] != null && !isReadOnly)
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Entered by: ${usernames[indicator]}",
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
          if (editedUsernames[indicator] != null && !isReadOnly) // Show Edited By if available
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Edited by: ${editedUsernames[indicator]}",
                style: TextStyle(color: Colors.blue, fontSize: 12.0),
              ),
            ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildReportSection({
    required GlobalKey<FormState> formKey,
    required String title,
    required List<String> indicators,
    required Map<String, TextEditingController> controllers, // Pass the correct controller map here
    required Map<String, String?> usernames,
    required Map<String, String?> editedUsernames, // Pass editedUsernames map
    required String reportType,
    required Future<void> Function() onSubmit,
    String? selectedReportPeriodValue, // Add these to receive populated values, nullable
    String? selectedMonthForWeeklyValue, // Add these to receive populated values, nullable
  }) {
    bool isReadOnlySection = _isEditingReportSection[reportType] ?? (_loadedReports[reportType] != null); // Read only if report exists or in editing mode
    return ExpansionTile(
      leading: _getReportCompletionStatus(reportType, controllers, indicators),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      onExpansionChanged: (expanded) {
        if (expanded) {
          setState(() {
            _isEditingReportSection[reportType] = false;
          });
        }
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDatePicker(),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Report Type*'),
                  value: _selectedReportType,
                  items: ["Daily"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Report Type is required' : null,
                  onChanged: isReadOnlySection ? null : (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedReportType = newValue;
                        _updateReportPeriodOptions(_selectedReportType);
                      });
                    }
                  },
                  disabledHint: _selectedReportType != null ? Text(_selectedReportType) : null,
                ),
                SizedBox(height: 10),
                if (_selectedReportType == "Daily")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Reporting Week*'),
                        value: selectedReportPeriodValue, // Now directly use the value passed in
                        items: _reportPeriodOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Reporting Week is required' : null,
                        onChanged: isReadOnlySection ? null : (newValue) {
                          setState(() {
                            _selectedReportPeriod = newValue;
                          });
                        },
                        disabledHint: selectedReportPeriodValue != null ? Text(selectedReportPeriodValue) : (_selectedReportPeriod != null ? Text(_selectedReportPeriod!) : null), // Conditionally show hint
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Reporting Month*'),
                        value: selectedMonthForWeeklyValue, // Now directly use the value passed in
                        items: _monthlyOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Reporting Month is required' : null,
                        onChanged: isReadOnlySection ? null : (newValue) {
                          setState(() {
                            _selectedMonthForWeekly = newValue;
                          });
                        },
                        disabledHint: selectedMonthForWeeklyValue != null ? Text(selectedMonthForWeeklyValue) : (_selectedMonthForWeekly != null? Text(_selectedMonthForWeekly!) : null), // Conditionally show hint
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ...indicators.map((indicator) => _buildIndicatorTextField(
                  controllers: controllers, // Use the passed controllers here
                  indicator: indicator,
                  usernames: usernames,
                  editedUsernames: editedUsernames, // Pass editedUsernames map
                  isReadOnly: isReadOnlySection,
                  onEditPressed: () {
                    setState(() {
                      _isEditingReportSection[reportType] = false;
                    });
                  },
                )).toList(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isReadOnlySection ?  ()  =>  setState(() {_isEditingReportSection[reportType] = false;}) : ()  {
                      if (formKey.currentState!.validate()) {
                        onSubmit();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all required fields marked with *')),
                        );
                      }
                    },
                    child: Text(isReadOnlySection ? 'Edit ${title}' : 'Submit ${title}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getReportCompletionStatus(String reportType, Map<String, TextEditingController> controllers, List<String> indicators) {
    bool allFilled = true;
    bool anyFilled = false;
    for (String indicator in indicators) {
      if (controllers[indicator]!.text.isEmpty) {
        allFilled = false;
      } else {
        anyFilled = true;
      }
    }

    if (allFilled) {
      return Icon(Icons.check_circle, color: Colors.green);
    } else if (anyFilled) {
      return Icon(Icons.check, color: Colors.orange);
    } else {
      return Icon(Icons.remove);
    }

  }

  Future<void> _saveReportToIsar(String reportType, Map<String, TextEditingController> controllers, List<String> indicators, Map<String, String?> editedUsernames) async {
    if (_selectedReportType.isEmpty || _selectedReportPeriod == null || _selectedMonthForWeekly == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select Report Type, Reporting Week, and Reporting Month')),
      );
      return;
    }

    List<ReportEntry> reportDataEntries = [];
    for (String indicator in indicators) {
      reportDataEntries.add(
        ReportEntry(
          key: indicator,
          value: controllers[indicator]!.text.trim(),
          enteredBy: _currentUsername, // Set Entered By
          editedBy: editedUsernames[indicator], // Set Edited By
        ),
      );
    }

    final report = Report(
      reportType: reportType,
      date: _selectedReportingDate,
      reportingWeek: _selectedReportPeriod!,
      reportingMonth: _selectedMonthForWeekly!,
      reportEntries: reportDataEntries,
    );

    try {
      await _isarService.saveReport(report);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${titleCase(reportType.replaceAll('_', ' '))} Report saved successfully!')),
      );
      _resetControllers(controllers, indicators, tbReportUsernames, tbReportEditedUsernames);
      setState(() {
        _isEditingReportSection[reportType] = true; // Lock inputs after saving
        _loadReportsForSelectedDate(); //refresh the loaded reports after saving to reflect changes immediately
      });


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving ${titleCase(reportType.replaceAll('_', ' '))} Report.')),
      );
      print("Error saving report to Isar: $e");
    }

  }

  Future<void> _updateReportToIsar(String reportType, Map<String, TextEditingController> controllers, List<String> indicators) async {
    // Implement update logic here
  }


  void _resetControllers(Map<String, TextEditingController> controllers, List<String> indicators, Map<String, String?> usernames, Map<String, String?> editedUsernames) {
    for (String indicator in indicators) {
      controllers[indicator]!.clear();
      usernames[indicator] = null; // Clear username as well when resetting
      editedUsernames[indicator] = null; // Clear edited username when resetting
    }
    setState(() {});
  }


  Future<void> _saveHtsReport() async {
    await _saveReportToIsar("hts_report", htsReportControllers, htsReportIndicators, htsReportEditedUsernames);
  }

  Future<void> _saveArtNurseReport() async {
    await _saveReportToIsar("art_nurse_report", artNurseReportControllers, artNurseReportIndicators, artNurseReportEditedUsernames);
  }

  Future<void> _saveTrackingAssistantReport() async {
    await _saveReportToIsar("tracking_report", trackingAssistantReportControllers, trackingAssistantReportIndicators, trackingAssistantReportEditedUsernames);
  }

  Future<void> _saveTbReport() async {
    await _saveReportToIsar("tb_report", tbReportControllers, tbReportIndicators, tbReportEditedUsernames);
  }

  Future<void> _saveVlReport() async {
    await _saveReportToIsar("vl_report", vlReportControllers, vlReportIndicators, vlReportEditedUsernames);
  }

  Future<void> _savePharmacyReport() async {
    await _saveReportToIsar("pharmacy_report", pharmTechReportControllers, pharmTechReportIndicators, pharmTechReportEditedUsernames);
  }

  Future<void> _saveSiReport() async {
    await _saveReportToIsar("si_report", siReportControllers, siReportIndicators, siReportEditedUsernames);
  }


  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Activity Monitoring",
        style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.grey[600], fontFamily: "NexaBold"),
      ),
      elevation: 0.5,
      iconTheme: IconThemeData(color: Get.isDarkMode ? Colors.white : Colors.black87),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
          child: Image.asset("assets/image/ccfn_logo.png"),
        )
      ],
    );
  }

  _addActivityBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text:"${DateTime.now().day},",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.080 : 0.060),
                              fontFamily: "NexaBold"
                          ),
                          children: [
                            TextSpan(
                                text: DateFormat(" MMMM, yyyy").format(
                                    DateTime.now()),
                                style: TextStyle(
                                    color: Get.isDarkMode?Colors.white:Colors.black,
                                    fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                                    fontFamily: "NexaBold"
                                )
                            )
                          ]
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(0,5,0,0),
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize:  MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyButton(label: "Go to Daily Activity",onTap: ()async{
            await Get.to(()=>const TaskManagerHomePage());
          })
        ],
      ),
    );
  }

  String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, _isarService),
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _addActivityBar(),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _htsFormKey,
                    title: 'HTS Report',
                    indicators: htsReportIndicators,
                    controllers: htsReportControllers, // Pass htsReportControllers
                    usernames: htsReportUsernames,
                    editedUsernames: htsReportEditedUsernames, // Pass editedUsernames map
                    reportType: "hts_report",
                    onSubmit: _saveHtsReport,
                    selectedReportPeriodValue: _loadedReports["hts_report"]?.reportingWeek, // Populate from loaded report if exists
                    selectedMonthForWeeklyValue: _loadedReports["hts_report"]?.reportingMonth, // Populate from loaded report if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _artNurseFormKey,
                    title: 'ART Nurse Report',
                    indicators: artNurseReportIndicators,
                    controllers: artNurseReportControllers, // Pass artNurseReportControllers
                    usernames: artNurseReportUsernames,
                    editedUsernames: artNurseReportEditedUsernames, // Pass editedUsernames map
                    reportType: "art_nurse_report",
                    onSubmit: _saveArtNurseReport,
                    selectedReportPeriodValue: _loadedReports["art_nurse_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["art_nurse_report"]?.reportingMonth, // Populate if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _trackingAssistantFormKey,
                    title: 'Tracking Assistant Report',
                    indicators: trackingAssistantReportIndicators,
                    controllers: trackingAssistantReportControllers, // Pass trackingAssistantReportControllers
                    usernames: trackingAssistantReportUsernames,
                    editedUsernames: trackingAssistantReportEditedUsernames, // Pass editedUsernames map
                    reportType: "tracking_report",
                    onSubmit: _saveTrackingAssistantReport,
                    selectedReportPeriodValue: _loadedReports["tracking_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["tracking_report"]?.reportingMonth, // Populate if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _tbFormKey,
                    title: 'TB Report',
                    indicators: tbReportIndicators,
                    controllers: tbReportControllers, // Pass tbReportControllers
                    usernames: tbReportUsernames,
                    editedUsernames: tbReportEditedUsernames, // Pass editedUsernames map
                    reportType: "tb_report",
                    onSubmit: _saveTbReport,
                    selectedReportPeriodValue: _loadedReports["tb_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["tb_report"]?.reportingMonth, // Populate if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _vlFormKey,
                    title: 'VL Report',
                    indicators: vlReportIndicators,
                    controllers: vlReportControllers, // Pass vlReportControllers
                    usernames: vlReportUsernames,
                    editedUsernames: vlReportEditedUsernames, // Pass editedUsernames map
                    reportType: "vl_report",
                    onSubmit: _saveVlReport,
                    selectedReportPeriodValue: _loadedReports["vl_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["vl_report"]?.reportingMonth, // Populate if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _pharmacyFormKey,
                    title: 'Pharmacy Report',
                    indicators: pharmTechReportIndicators,
                    controllers: pharmTechReportControllers, // Pass pharmTechReportControllers
                    usernames: pharmTechReportUsernames,
                    editedUsernames: pharmTechReportEditedUsernames, // Pass editedUsernames map
                    reportType: "pharmacy_report",
                    onSubmit: _savePharmacyReport,
                    selectedReportPeriodValue: _loadedReports["pharmacy_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["pharmacy_report"]?.reportingMonth, // Populate if exists
                  ),
                  SizedBox(height: 20),
                  _buildReportSection(
                    formKey: _siFormKey,
                    title: 'SI Report',
                    indicators: siReportIndicators,
                    controllers: siReportControllers, // Pass siReportControllers
                    usernames: siReportUsernames,
                    editedUsernames: siReportEditedUsernames, // Pass editedUsernames map
                    reportType: "si_report",
                    onSubmit: _saveSiReport,
                    selectedReportPeriodValue: _loadedReports["si_report"]?.reportingWeek, // Populate if exists
                    selectedMonthForWeeklyValue: _loadedReports["si_report"]?.reportingMonth, // Populate if exists
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}