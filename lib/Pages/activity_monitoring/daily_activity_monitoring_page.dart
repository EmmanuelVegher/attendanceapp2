import 'package:date_picker_timeline/date_picker_widget.dart';
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
import 'package:isar/isar.dart'; // Import Isar
import 'dart:async'; // Import async for StreamSubscription

import '../../model/task.dart';
import '../Attendance/button.dart';

class DailyActivityMonitoringPage extends StatefulWidget {
  @override
  _DailyActivityMonitoringPageState createState() => _DailyActivityMonitoringPageState();
}

class _DailyActivityMonitoringPageState extends State<DailyActivityMonitoringPage> {
  // Define lists of report indicators for each report type
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

  // Initialize TextEditingControllers for each indicator for each report type.
  // These controllers will hold the values entered by the user and will be populated when editing a record.
  final Map<String, TextEditingController> tbReportControllers = {};
  final Map<String, TextEditingController> vlReportControllers = {};
  final Map<String, TextEditingController> pharmTechReportControllers = {};
  final Map<String, TextEditingController> trackingAssistantReportControllers = {};
  final Map<String, TextEditingController> artNurseReportControllers = {};
  final Map<String, TextEditingController> htsReportControllers = {};
  final Map<String, TextEditingController> siReportControllers = {};

  // Maps to store the username of who entered the data for each indicator.
  Map<String, String?> tbReportUsernames = {};
  Map<String, String?> vlReportUsernames = {};
  Map<String, String?> pharmTechReportUsernames = {};
  Map<String, String?> trackingAssistantReportUsernames = {};
  Map<String, String?> artNurseReportUsernames = {};
  Map<String, String?> htsReportUsernames = {};
  Map<String, String?> siReportUsernames = {};

  // Maps to store the username of who edited the data for each indicator.
  Map<String, String?> tbReportEditedUsernames = {};
  Map<String, String?> vlReportEditedUsernames = {};
  Map<String, String?> pharmTechReportEditedUsernames = {};
  Map<String, String?> trackingAssistantReportEditedUsernames = {};
  Map<String, String?> artNurseReportEditedUsernames = {};
  Map<String, String?> htsReportEditedUsernames = {};
  Map<String, String?> siReportEditedUsernames = {};


  String _currentUsername = ""; // Stores the current logged-in user's name.

  String _selectedReportType = "Daily"; // Default report type.
  String? _selectedReportPeriod; // Selected reporting week (Week 1, Week 2, etc.)
  String? _selectedMonthForWeekly; // Selected month for weekly report.
  List<String> _reportPeriodOptions = []; // Options for report period dropdown.
  List<String> _monthlyOptions = []; // Options for month dropdown.
  Map<String, bool> _isEditingReportSection = {}; // Tracks if a report section is in editing mode.
  Map<String, Report?> _loadedReports = {}; // Stores loaded reports for the selected date.
  List<Task> _tasksForDate = []; // Stores tasks for the selected date.

  //final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  DateTime _selectedDate = DateTime.now(); // Currently selected date (not used for reporting date).
  DateTime _selectedReportingDate = DateTime.now(); // Date for which reports are being viewed/entered.
  bool _isLoading = true; // Loading indicator flag.
  Color _datePickerSelectionColor = Colors.red;
  Color _datePickerSelectedTextColor = Colors.white;

  final IsarService _isarService = IsarService();

  // Global keys for form validation for each report section.
  final GlobalKey<FormState> _htsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _artNurseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _trackingAssistantFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _tbFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _vlFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _pharmacyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _siFormKey = GlobalKey<FormState>();

  // Track StreamSubscriptions for database watchers to refresh data on changes.
  List<StreamSubscription> _reportWatchers = [];
  Timer? _reportPollingTimer; // Not used in this version, using StreamSubscriptions instead.

  //Controllers for Task BottomSheet
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    //_taskController.getTasks();

    _initializeAsync(); // Initialize controllers, fetch username and load reports.

    _monthlyOptions = _generateMonthlyOptions(); // Generate monthly options for dropdown.
    _updateReportPeriodOptions(_selectedReportType); // Set initial report period options.

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false; // Hide loading indicator after 5 seconds (simulated loading).
      });
    });
  }


  @override
  void dispose() {
    // Cancel all stream subscriptions to prevent memory leaks when the widget is disposed.
    for (var watcher in _reportWatchers) {
      watcher.cancel();
    }
    super.dispose();
  }


  // Async initialization to ensure controllers are initialized before loading reports.
  Future<void> _initializeAsync() async {
    print("_initializeAsync: Starting initialization");
    await _initializeControllers(); // Initialize all TextEditingControllers.
    await _fetchUsername(); // Fetch current username.
    await _loadReportsForSelectedDate(); // Load reports from Isar for the selected reporting date.
    await _loadTasksForSelectedDate(); // Load tasks for the selected reporting date.
    print("_initializeAsync: Reports and Tasks loaded, initializing controllers");
    _initializeReportWatchers(); // Setup watchers for database changes to auto-refresh data.

    print("_initializeAsync: Controllers initialized");
  }

  // Fetches the username of the logged-in user from Isar database.
  Future<void> _fetchUsername() async {
    print("_fetchUsername: Fetching username");
    BioModel? bio = await _isarService.getBioInfoWithFirebaseAuth(); // Get BioModel using Firebase Auth.
    setState(() {
      if (bio != null && bio.firstName != null && bio.lastName != null) {
        _currentUsername = "${bio.firstName!} ${bio.lastName!}"; // Construct full name.
      } else {
        _currentUsername = "Unknown User"; // Default if no bio info found.
      }
    });
    print("_fetchUsername: Username fetched: $_currentUsername");
  }

  Future<void> _loadReportsForSelectedDate() async {
    print("_loadReportsForSelectedDate: Loading reports for date: $_selectedReportingDate");
    _loadedReports.clear();
    _isEditingReportSection.clear(); // Clear editing state when loading new reports.
    List<Report> reports = await _isarService.getReportsByDate(_selectedReportingDate);
    print("_loadReportsForSelectedDate: Fetched reports count: ${reports.length}");
    print("Loaded Reports: $reports");

    setState(() {
      for (var report in reports) {
        print("_loadReportsForSelectedDate: Processing report type: ${report.reportType}");
        _loadedReports[report.reportType!] = report;
        _isEditingReportSection[report.reportType!] = true; // Initialize editing section to true (read-only) when report is loaded.


        print("_loadReportsForSelectedDate: Loaded report for ${report.reportType}: ${_loadedReports[report.reportType!]}");
      }


      _updateControllerValuesFromLoadedReports();
    });
    print("_loadReportsForSelectedDate: Report loading and controller update complete.");
  }

  Future<void> _loadTasksForSelectedDate() async {
    print("_loadTasksForSelectedDate: Loading tasks for date: $_selectedReportingDate");
    List<Task> tasks = await _isarService.getTasksByDate(_selectedReportingDate);
    setState(() {
      _tasksForDate = tasks;
    });
    print("_loadTasksForSelectedDate: Fetched tasks count: ${_tasksForDate.length}");
  }

  // Updates the TextEditingController values from the loaded reports.
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

  // Helper function to update controllers for a specific report type from a loaded report.
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
          controllers[entry.key]!.text = entry.value; // Set controller text to the value from the report.
          usernames[entry.key] = entry.enteredBy; // Populate Entered By username from report
          editedUsernames[entry.key] = entry.editedBy; // Populate Edited By username from report
          print("_updateControllersFromReport: Controller value for ${entry.key} updated to: '${controllers[entry.key]!.text}'");
        } else {
          print("_updateControllersFromReport: No controller found for key: ${entry.key}");
        }
      }
      print("_updateControllersFromReport: All report entries processed for report type: $reportType");
    } else {
      print("_updateControllersFromReport: No report found or report entries are null for report type: $reportType. Resetting controllers.");
      _resetControllers(controllers, indicators, usernames, editedUsernames); // Reset controllers if no report is loaded.
    }
    print("_updateControllersFromReport: Controller update for report type: $reportType finished.");
  }


  // Initializes all TextEditingControllers for all report types and indicators.
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

  // Helper function to initialize a map of TextEditingControllers for a given list of indicators.
  void _initializeControllerMap(List<String> indicators, Map<String, TextEditingController> controllers) {
    for (String indicator in indicators) {
      controllers[indicator] = TextEditingController(); // Create a new controller for each indicator.
    }
  }


  // Updates the report period options based on the selected report type (currently only "Daily").
  void _updateReportPeriodOptions(String reportType) {
    setState(() {
      _selectedReportPeriod = null; // Reset selected period.
      _selectedMonthForWeekly = null; // Reset selected month.
      _reportPeriodOptions = reportType == "Daily" ? ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"] : []; // Set options for "Daily" type.
    });
  }

  // Generates a list of last 12 months for the monthly dropdown options.
  List<String> _generateMonthlyOptions() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1); // Calculate date for each month.
      months.add(DateFormat("MMMM yyyy").format(monthDate)); // Format month and year.
    }
    return months;
  }


  // Builds a single indicator text field, either as read-only text or editable TextFormField.
  Widget _buildIndicatorTextField({
    required Map<String, TextEditingController> controllers,
    required String indicator,
    required Map<String, String?> usernames,
    required Map<String, String?> editedUsernames, // Map to hold edited by usernames
    required bool isReadOnly,
    required VoidCallback onEditPressed,
  }) {
    TextInputType keyboardType = indicator == "Comments" ? TextInputType.multiline : TextInputType.number; // Set keyboard type based on indicator.

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isReadOnly
          ? Column( // Display as Text widgets when read-only
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
              children: <TextSpan>[
                TextSpan(text: "${indicator}: "),
                TextSpan(
                  text: controllers[indicator]!.text.isNotEmpty ? controllers[indicator]!.text : 'Not Entered', // Display value or "Not Entered"
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controllers[indicator]!.text.isNotEmpty ? Colors.black : Colors.red, // Conditional color
                  ),
                ),
              ],
            ),
          ),
          if (usernames[indicator] != null && usernames[indicator]!.isNotEmpty) // Display "Entered by" username if available.
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Entered by: ${usernames[indicator]}",
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
          if (editedUsernames[indicator] != null && editedUsernames[indicator]!.isNotEmpty) // Display "Edited by" username if available.
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Edited by: ${editedUsernames[indicator]}",
                style: TextStyle(color: Colors.blue, fontSize: 12.0),
              ),
            ),
        ],
      )
          : Column( // Display as TextFormField when editable
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
                  readOnly: isReadOnly, // Set readOnly based on isReadOnly flag.
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    suffixIcon: isReadOnly ? IconButton( // Show edit icon only in read-only mode.
                      icon: Icon(Icons.edit),
                      onPressed: onEditPressed, // Callback to switch to edit mode.
                    ) : null,
                  ),
                  onChanged: (value) { // Set onChanged to track entered/edited by usernames
                    setState(() {
                      if (value.isNotEmpty && (usernames[indicator] == null || usernames[indicator]!.isEmpty )) {
                        usernames[indicator] = _currentUsername; // Update Entered By username on first change if empty
                        editedUsernames[indicator] = null; // Reset edited by if newly entered
                      } else if (value.isNotEmpty && value != controllers[indicator]!.text) {
                        editedUsernames[indicator] = _currentUsername; // Update Edited By username on subsequent change
                      } else if (value.isEmpty) {
                        usernames[indicator] = null; // Clear usernames when field is cleared
                        editedUsernames[indicator] = null; // Clear edited usernames when field is cleared
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          if (usernames[indicator] != null && usernames[indicator]!.isNotEmpty) // Display "Entered by" username if available.
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Entered by: ${usernames[indicator]}",
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
          if (editedUsernames[indicator] != null && editedUsernames[indicator]!.isNotEmpty) // Display "Edited by" username if available.
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

  // Builds a report section (e.g., HTS Report, TB Report) with expansion tile and form.
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
    // Determine if the section should be read-only. It's read-only if a report exists in _loadedReports AND the section is NOT in editing mode.
    bool isReadOnlySection = _loadedReports[reportType] != null && (_isEditingReportSection[reportType] ?? true);
    //bool isReadOnlySection = _loadedReports[reportType] != null && (_isEditingReportSection[reportType] ?? true);
    print("Report Type: $reportType, _isEditingReportSection[$reportType]: ${_isEditingReportSection[reportType]}, isReadOnlySection: $isReadOnlySection"); // Debug print

    return ExpansionTile(
      leading: _getReportCompletionStatus(reportType, controllers, indicators), // Completion status icon.
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      onExpansionChanged: (expanded) {
        if (expanded && isReadOnlySection) {
          // Do nothing, keep it read-only when expanded initially after save
        } else if (expanded && !isReadOnlySection) {
          setState(() {
            _isEditingReportSection[reportType] = false; // Ensure it's editable if expanded and not read-only by default
          });
        } else if (!expanded) {
          setState(() {
            _isEditingReportSection[reportType] = isReadOnlySection; // Revert to read-only when collapsed
          });
        }
      },
      initiallyExpanded: false, // Ensure it starts collapsed by default.
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Reporting Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedReportingDate), // Format and display selected date.
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                  onChanged: isReadOnlySection ? null : (newValue) { // Disable dropdown in read-only mode.
                    if (newValue != null) {
                      setState(() {
                        _selectedReportType = newValue;
                        _updateReportPeriodOptions(_selectedReportType); // Update period options based on report type.
                      });
                    }
                  },
                  disabledHint: _selectedReportType != null ? Text(_selectedReportType) : null, // Display selected type as hint when disabled.
                ),
                SizedBox(height: 10),
                if (_selectedReportType == "Daily") // Show weekly/monthly dropdowns only for "Daily" report type.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Reporting Week*'),
                        value: selectedReportPeriodValue, // Use populated value if available
                        items: _reportPeriodOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Reporting Week is required' : null,
                        onChanged: isReadOnlySection ? null : (newValue) { // Disable dropdown in read-only mode.
                          setState(() {
                            _selectedReportPeriod = newValue;
                          });
                        },
                        disabledHint: selectedReportPeriodValue != null ? Text(selectedReportPeriodValue) : (_selectedReportPeriod != null ? Text(_selectedReportPeriod!) : null), // Conditionally show hint
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Reporting Month*'),
                        value: selectedMonthForWeeklyValue, // Use populated value if available
                        items: _monthlyOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Reporting Month is required' : null,
                        onChanged: isReadOnlySection ? null : (newValue) { // Disable dropdown in read-only mode.
                          setState(() {
                            _selectedMonthForWeekly = newValue;
                          });
                        },
                        disabledHint: selectedMonthForWeeklyValue != null ? Text(selectedMonthForWeeklyValue) : (_selectedMonthForWeekly != null? Text(_selectedMonthForWeekly!) : null), // Conditionally show hint
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ...indicators.map((indicator) => _buildIndicatorTextField( // Build text fields for each indicator.
                  controllers: controllers, // Use the passed controllers here
                  indicator: indicator,
                  usernames: usernames,
                  editedUsernames: editedUsernames, // Pass editedUsernames map
                  isReadOnly: isReadOnlySection, // Pass read-only status.
                  onEditPressed: () {
                    print("Edit Button Pressed for Indicator: $indicator, Report Type: $reportType"); // Debug print
                    setState(() {
                      _isEditingReportSection[reportType] = false; // Set to false to enable editing when edit button is pressed.
                      print("_isEditingReportSection[$reportType] set to false"); // Debug print
                    });
                  },
                )).toList(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isReadOnlySection ?  ()  =>  setState(() {_isEditingReportSection[reportType] = false;}) : ()  { // Conditionally handle button press.
                      if (formKey.currentState!.validate()) {
                        onSubmit(); // Call onSubmit to save/update data.
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all required fields marked with *')),
                        );
                      }
                    },
                    child: Text(isReadOnlySection ? 'Edit ${title}' : 'Submit ${title}'), // Button text changes based on read-only status.
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Determines the report completion status based on whether indicators are filled and returns an appropriate icon.
  Widget _getReportCompletionStatus(String reportType, Map<String, TextEditingController> controllers, List<String> indicators) {
    bool allFilled = true;
    bool anyFilled = false;
    for (String indicator in indicators) {
      if (controllers[indicator]!.text.isEmpty) {
        allFilled = false; // If any indicator is empty, allFilled is false.
      } else {
        anyFilled = true; // If at least one indicator is filled, anyFilled is true.
      }
    }

    if (allFilled) {
      return Icon(Icons.check_circle, color: Colors.green); // All indicators filled, return green check.
    } else if (anyFilled) {
      return Icon(Icons.check, color: Colors.orange); // Some indicators filled, return orange check.
    } else {
      return Icon(Icons.remove); // No indicators filled, return remove icon.
    }

  }

  // Saves the report data to Isar database. Handles both new saves and updates to existing reports.
  Future<void> _saveReportToIsar(String reportType, Map<String, TextEditingController> controllers, List<String> indicators, Map<String, String?> editedUsernames) async {
    if (_selectedReportType.isEmpty || _selectedReportPeriod == null || _selectedMonthForWeekly == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select Report Type, Reporting Week, and Reporting Month')),
      );
      return;
    }

    List<ReportEntry> reportDataEntries = []; // List to hold report entries.
    Report? existingReport = _loadedReports[reportType]; // Check if a report already exists for this type and date.
    Map<String, String?> currentEnteredBy = {}; // Map to store entered by usernames for the current save operation.
    Map<String, String?> currentEditedBy = {}; // Map to store edited by usernames for the current save operation.

    for (String indicator in indicators) {
      String? existingValue = existingReport?.reportEntries?.firstWhere((entry) => entry.key == indicator, orElse: () => ReportEntry()).value; // Get existing value if report exists
      String currentValue = controllers[indicator]!.text.trim(); // Get current value from controller.
      String? enteredByUser = existingReport?.reportEntries?.firstWhere((entry) => entry.key == indicator, orElse: () => ReportEntry()).enteredBy; // Get existing enteredBy username

      String? finalEnteredBy = enteredByUser; // Initialize with existing or null
      String? finalEditedBy = editedUsernames[indicator]; // Initialize with current edited username

      // Logic to determine Entered By and Edited By usernames based on changes
      if (currentValue.isNotEmpty && (existingValue == null || existingValue.isEmpty) ) {
        finalEnteredBy = _currentUsername; // Set Entered By only if value is newly entered and was empty
        finalEditedBy = null; // Reset edited by if newly entered
      } else if (currentValue.isNotEmpty && currentValue != existingValue) {
        finalEditedBy = _currentUsername; // Set Edited By if value is changed
        finalEnteredBy = enteredByUser; // Keep original entered by, if available
        if (finalEnteredBy == null || finalEnteredBy.isEmpty) {
          finalEnteredBy = _currentUsername; //If original enteredBy is missing, use current user as enteredBy as well for edit case
        }
      } else {
        if(existingValue != null && existingValue.isNotEmpty){
          finalEnteredBy = enteredByUser; // Retain existing enteredBy if no changes
          finalEditedBy = editedUsernames[indicator]; // Retain existing editedBy if no changes
        } else {
          finalEnteredBy = null;
          finalEditedBy = null;
        }
      }


      reportDataEntries.add(
        ReportEntry(
          key: indicator,
          value: currentValue,
          enteredBy: finalEnteredBy,
          editedBy: finalEditedBy,
        ),
      );
      currentEnteredBy[indicator] = finalEnteredBy; // Update current entered by map
      currentEditedBy[indicator] = finalEditedBy; // Update current edited by map
    }

    final report = Report(
      reportType: reportType,
      date: _selectedReportingDate,
      reportingWeek: _selectedReportPeriod!,
      reportingMonth: _selectedMonthForWeekly!,
      reportEntries: reportDataEntries,
        isSynced:false,
        reportStatus:"Pending"
    );

    try {
      await _isarService.saveReport(report); // Save or update report in Isar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${titleCase(reportType.replaceAll('_', ' '))} Report saved successfully!')),
      );
      setState(() {
        // Update usernames maps to reflect saved EnteredBy and EditedBy in UI
        if(reportType == "tb_report") tbReportUsernames = currentEnteredBy; tbReportEditedUsernames = currentEditedBy;
        if(reportType == "vl_report") vlReportUsernames = currentEnteredBy; vlReportEditedUsernames = currentEditedBy;
        if(reportType == "pharmacy_report") pharmTechReportUsernames = currentEnteredBy; pharmTechReportEditedUsernames = currentEditedBy;
        if(reportType == "tracking_report") trackingAssistantReportUsernames = currentEnteredBy; trackingAssistantReportEditedUsernames = currentEditedBy;
        if(reportType == "art_nurse_report") artNurseReportUsernames = currentEnteredBy; artNurseReportEditedUsernames = currentEditedBy;
        if(reportType == "hts_report") htsReportUsernames = currentEnteredBy; htsReportEditedUsernames = currentEditedBy;
        if(reportType == "si_report") siReportUsernames = currentEnteredBy; siReportEditedUsernames = currentEditedBy;

        _isEditingReportSection[reportType] = true; // Lock inputs after saving, switch to read-only mode.
        _loadReportsForSelectedDate(); // Refresh the loaded reports after saving to reflect changes immediately.
      });


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving ${titleCase(reportType.replaceAll('_', ' '))} Report.')),
      );
      print("Error saving report to Isar: $e");
    }

  }


  // Resets the TextEditingControllers and associated usernames for a given report section.
  void _resetControllers(Map<String, TextEditingController> controllers, List<String> indicators, Map<String, String?> usernames, Map<String, String?> editedUsernames) {
    for (String indicator in indicators) {
      controllers[indicator]!.clear(); // Clear the text in the controller.
      usernames[indicator] = null; // Clear entered username.
      editedUsernames[indicator] = null; // Clear edited username.
    }
    setState(() {}); // Trigger UI refresh.
  }

  // Initializes database watchers using StreamSubscriptions to listen for changes in reports for the selected date.
  void _initializeReportWatchers() {
    _reportWatchers.clear(); // Clear existing watchers before re-initializing to avoid duplicates.

    // Watcher for TB Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("tb_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false) // Do not fire immediately on subscription.
        .listen((_) {
      _showDatabaseChangeDialog("TB Report"); // Show dialog when TB report changes.
      _loadReportsForSelectedDate(); // Refresh data to reflect changes.
    }));

    // Watcher for VL Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("vl_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("VL Report");
      _loadReportsForSelectedDate();
    }));

    // Watcher for Pharmacy Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("pharmacy_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("Pharmacy Report");
      _loadReportsForSelectedDate();
    }));

    // Watcher for Tracking Assistant Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("tracking_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("Tracking Assistant Report");
      _loadReportsForSelectedDate();
    }));

    // Watcher for ART Nurse Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("art_nurse_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("ART Nurse Report");
      _loadReportsForSelectedDate();
    }));

    // Watcher for HTS Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("hts_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("HTS Report");
      _loadReportsForSelectedDate();
    }));

    // Watcher for SI Report
    _reportWatchers.add(_isarService.isar.reports
        .filter()
        .reportTypeEqualTo("si_report")
        .dateEqualTo(_selectedReportingDate)
        .watch(fireImmediately: false)
        .listen((_) {
      _showDatabaseChangeDialog("SI Report");
      _loadReportsForSelectedDate();
    }));
  }


  // Shows an AlertDialog to notify the user that a report has been updated in the database.
  void _showDatabaseChangeDialog(String reportName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Database Change Detected"),
          content: Text("$reportName has been updated in the database."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }

  // Shows an AlertDialog to notify the user that future dates are not allowed.
  void _showFutureDateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Date"),
          content: Text("You cannot fill a report for a future date."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }


  // Save functions for each report type, calling _saveReportToIsar with correct parameters.
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


  // AppBar for the page.
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


  _addDateBar() {
    DateTime threeYearsAgo = DateTime.now().subtract(const Duration(days: 3 * 365));
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
    DateTime endDate = threeYearsAgo.add(Duration(days: 365 * 3 + 30));

    List<DateTime> futureDates = [];
    for (DateTime date = tomorrow; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      futureDates.add(DateTime(date.year, date.month, date.day));
    }

    return Container(
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Row(
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
                          text: "${DateFormat('d').format(_selectedReportingDate)},",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.080 : 0.060),
                              fontFamily: "NexaBold"),
                          children: [
                            TextSpan(
                              text: DateFormat(" MMMM, yyyy").format(_selectedReportingDate),
                              style: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : Colors.black,
                                  fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                                  fontFamily: "NexaBold"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "Reporting Date",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                  children:[
                    Text(
                      "Change Date HERE -->",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.red),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedReportingDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          selectableDayPredicate: (day) {
                            return day.isBefore(DateTime.now().add(const Duration(days: 1)));
                          },
                        );
                        if (pickedDate != null && pickedDate != _selectedReportingDate) {
                          if (pickedDate.isAfter(DateTime.now())) {
                            _showFutureDateDialog();
                            return;
                          }
                          setState(() {
                            _selectedReportingDate = pickedDate;
                            _datePickerSelectionColor = Colors.red;
                            _datePickerSelectedTextColor = Colors.white;
                            _loadReportsForSelectedDate();
                            _loadTasksForSelectedDate(); // Load tasks for the new date
                            _initializeReportWatchers();
                          });
                        }
                      },
                    ),
                  ]
              ),

            ],
          ),
          DatePicker(
            _selectedReportingDate,
            key: UniqueKey(),
            controller: DatePickerController(),
            width: 70,
            height: 90,
            monthTextStyle: const TextStyle(fontSize: 12, fontFamily: "NexaBold", color: Colors.black),
            dayTextStyle: const TextStyle(fontSize: 13, fontFamily: "NexaLight", color: Colors.black),
            dateTextStyle: const TextStyle(fontSize: 18, fontFamily: "NexaBold", color: Colors.black),
            selectedTextColor: _datePickerSelectedTextColor,
            selectionColor: _datePickerSelectionColor,
            deactivatedColor: Colors.grey.shade400,
            initialSelectedDate: _selectedReportingDate,
            activeDates: null,
            inactiveDates: futureDates,
            daysCount: 365 * 3 + 30,
            locale: "en_US",
            calendarType: CalendarType.gregorianDate,
            directionality: null,
            onDateChange: (date) {
              if (date.isAfter(DateTime.now())) {
                _showFutureDateDialog();
                return;
              }
              setState(() {
                _selectedReportingDate = date;
                _datePickerSelectionColor = Colors.red;
                _datePickerSelectedTextColor = Colors.white;
                _loadReportsForSelectedDate();
                _loadTasksForSelectedDate(); // Load tasks for the new date
                _initializeReportWatchers();
              });
            },
          ),
        ],
      ),
    );
  }

  _addTaskBar() {
    return Container( // _addTaskBar is now just an empty container as its content is moved to _addDateBar
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: SizedBox.shrink(), // To keep the margin but not display anything
    );
  }

  _showAddTaskBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add New Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "NexaBold",
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _taskTitleController,
                style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Task Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _taskDescriptionController,
                maxLines: 3,
                style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                label: "Add Task",
                onTap: () {
                  _addTaskToIsar(); // Call the function to add task
                  Get.back(); // Close bottom sheet
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  _addTaskToIsar() async {
    String title = _taskTitleController.text;
    String description = _taskDescriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      Task newTask = Task()
        ..date = _selectedReportingDate
        ..taskTitle = title
        ..taskDescription = description
        ..isSynced = false
        ..taskStatus = "Pending"; // Set default status

      await _isarService.saveTask(newTask); // Save task using IsarService

      _taskTitleController.clear(); // Clear title field
      _taskDescriptionController.clear(); // Clear description field

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );
      _loadTasksForSelectedDate(); // Refresh tasks list after adding
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both task title and description')),
      );
    }
  }

  Widget _getTaskStatusIcon(String status) {
    if (status == "Pending") {
      return Icon(Icons.pending, color: Colors.orange);
    } else if (status == "Approved") {
      return Icon(Icons.check_circle_outline, color: Colors.green);
    } else if (status == "Rejected") {
      return Icon(Icons.cancel_outlined, color: Colors.red);
    }
    return Icon(Icons.help_outline); // Default icon if status is unknown
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.taskTitle ?? "No Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              task.taskDescription ?? "No Description",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.shrink(), // To push status to the right
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getTaskStatusIcon(task.taskStatus ?? "Pending"),
                      SizedBox(width: 4.0),
                      Text(
                        task.taskStatus ?? "Pending",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // Helper function to title case a string.
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
            Center(child: CircularProgressIndicator()) // Show loading indicator while loading.
          else
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // _addActivityBar(), // No longer used
                  _addTaskBar(), // Using _addTaskBar as Reporting Date section - now empty
                  const SizedBox(height: 10),
                  _addDateBar(), // Date picker timeline and date selection
                  const SizedBox(height: 10),
                  SizedBox(height: 20),
                  _buildReportSection( // Build HTS Report section.
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
                  _buildReportSection( // Build ART Nurse Report section.
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
                  _buildReportSection( // Build Tracking Assistant Report section.
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
                  _buildReportSection( // Build TB Report section.
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
                  _buildReportSection( // Build VL Report section.
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
                  _buildReportSection( // Build Pharmacy Report section.
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
                  _buildReportSection( // Build SI Report section.
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

                  SizedBox(height: 30),
                  Text(
                    "Tasks for ${_selectedReportingDate.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (_tasksForDate.isEmpty)
                    Text("No tasks added for this date.")
                  else
                    Column(
                      children: _tasksForDate.map((task) => _buildTaskCard(task)).toList(),
                    ),
                  SizedBox(height: 20), // Add some space at the bottom
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
        label: Text(
          "Click to Add Extra Task",
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
      ),

    );
  }
}