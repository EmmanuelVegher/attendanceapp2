import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../Tasks/task_manager_homepage.dart';
import '../../controllers/task_controller.dart';
import '../../services/isar_service.dart';
import '../../services/notification_services.dart';
import '../../widgets/drawer.dart';
import '../Attendance/button.dart';
import 'daily_activity_monitoring_page.dart'; // Import Firebase Firestore

class ActivityMonitoringPage extends StatefulWidget {
  @override
  _ActivityMonitoringPageState createState() => _ActivityMonitoringPageState();
}

class _ActivityMonitoringPageState extends State<ActivityMonitoringPage> {
  // --- Dummy Data (Replace with Firebase data later) ---
  List<Map<String, dynamic>> monthlySummaryData = [
    {
      "section": "Number of HIV positive persons newly enrolled in clinical care during the month",
      "data": [
        {"indicator": "All", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "0"), "age_15_19": TextEditingController(text: "0"), "age_20_24": TextEditingController(text: "0"), "age_25_29": TextEditingController(text: "2"), "age_30_34": TextEditingController(text: "0"), "age_35_39": TextEditingController(text: "0"), "age_40_44": TextEditingController(text: "0"), "age_45_49": TextEditingController(text: "0"), "age_50_plus": TextEditingController(text: "1")},
        {"indicator": "Male", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "0"), "age_15_19": TextEditingController(text: "0"), "age_20_24": TextEditingController(text: "0"), "age_25_29": TextEditingController(text: "1"), "age_30_34": TextEditingController(text: "0"), "age_35_39": TextEditingController(text: "0"), "age_40_44": TextEditingController(text: "0"), "age_45_49": TextEditingController(text: "0"), "age_50_plus": TextEditingController(text: "1")},
        {"indicator": "Female", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "0"), "age_15_19": TextEditingController(text: "0"), "age_20_24": TextEditingController(text: "0"), "age_25_29": TextEditingController(text: "1"), "age_30_34": TextEditingController(text: "0"), "age_35_39": TextEditingController(text: "0"), "age_40_44": TextEditingController(text: "0"), "age_45_49": TextEditingController(text: "0"), "age_50_plus": TextEditingController(text: "0")},
      ]
    },
    {
      "section": "Number of people living with HIV newly started on ART during the month (excludes ART transfer-in)",
      "data": [
        {"indicator": "All", "age_<1": TextEditingController(text: "-"), "age_1_4": TextEditingController(text: "-"), "age_5_9": TextEditingController(text: "-"), "age_10_14": TextEditingController(text: "-"), "age_15_19": TextEditingController(text: "-"), "age_20_24": TextEditingController(text: "-"), "age_25_29": TextEditingController(text: "2"), "age_30_34": TextEditingController(text: "-"), "age_35_39": TextEditingController(text: "-"), "age_40_44": TextEditingController(text: "-"), "age_45_49": TextEditingController(text: "-"), "age_50_plus": TextEditingController(text: "1")},
        {"indicator": "Male", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "0"), "age_15_19": TextEditingController(text: "0"), "age_20_24": TextEditingController(text: "0"), "age_25_29": TextEditingController(text: "1"), "age_30_34": TextEditingController(text: "0"), "age_35_39": TextEditingController(text: "0"), "age_40_44": TextEditingController(text: "0"), "age_45_49": TextEditingController(text: "0"), "age_50_plus": TextEditingController(text: "1")},
        {"indicator": "Female", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "0"), "age_15_19": TextEditingController(text: "0"), "age_20_24": TextEditingController(text: "0"), "age_25_29": TextEditingController(text: "1"), "age_30_34": TextEditingController(text: "0"), "age_35_39": TextEditingController(text: "0"), "age_40_44": TextEditingController(text: "0"), "age_45_49": TextEditingController(text: "0"), "age_50_plus": TextEditingController(text: "0")},
        {"indicator": "Pregnant", "value": TextEditingController(text: "1")},
        {"indicator": "Breastfeeding", "value": TextEditingController(text: "0")},
        {"indicator": "TB Patients", "value": TextEditingController(text: "1")},
      ]
    },
    {
      "section": "Total number of people living with HIV who are currently receiving ART during the month (All regimens)",
      "data": [
        {"indicator": "All", "age_<1": TextEditingController(text: "-"), "age_1_4": TextEditingController(text: "-"), "age_5_9": TextEditingController(text: "3"), "age_10_14": TextEditingController(text: "8"), "age_15_19": TextEditingController(text: "16"), "age_20_24": TextEditingController(text: "316"), "age_25_29": TextEditingController(text: "803"), "age_30_34": TextEditingController(text: "871"), "age_35_39": TextEditingController(text: "342"), "age_40_44": TextEditingController(text: "227"), "age_45_49": TextEditingController(text: "78"), "age_50_plus": TextEditingController(text: "124")},
        {"indicator": "Male", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "0"), "age_10_14": TextEditingController(text: "5"), "age_15_19": TextEditingController(text: "8"), "age_20_24": TextEditingController(text: "122"), "age_25_29": TextEditingController(text: "374"), "age_30_34": TextEditingController(text: "387"), "age_35_39": TextEditingController(text: "152"), "age_40_44": TextEditingController(text: "100"), "age_45_49": TextEditingController(text: "35"), "age_50_plus": TextEditingController(text: "64")},
        {"indicator": "Female", "age_<1": TextEditingController(text: "0"), "age_1_4": TextEditingController(text: "0"), "age_5_9": TextEditingController(text: "3"), "age_10_14": TextEditingController(text: "3"), "age_15_19": TextEditingController(text: "8"), "age_20_24": TextEditingController(text: "194"), "age_25_29": TextEditingController(text: "429"), "age_30_34": TextEditingController(text: "484"), "age_35_39": TextEditingController(text: "190"), "age_40_44": TextEditingController(text: "127"), "age_45_49": TextEditingController(text: "43"), "age_50_plus": TextEditingController(text: "60")},
        {"indicator": "Pregnant (subset of ART 2)", "value": TextEditingController(text: "2")},
        {"indicator": "Breastfeeding (subset of ART 2)", "value": TextEditingController(text: "0")},
      ]
    },
    {
      "section": "Regimens (subset of ART 2 above)",
      "data": [
        {"indicator": "1st line regimens", "male_<15": TextEditingController(text: "5"), "male_>=15": TextEditingController(text: "1242"), "female_<15": TextEditingController(text: "6"), "female_>=15": TextEditingController(text: "1535")},
        {"indicator": "2nd line regimens", "male_<15": TextEditingController(text: "0"), "male_>=15": TextEditingController(text: "0"), "female_<15": TextEditingController(text: "0"), "female_>=15": TextEditingController(text: "0")},
        {"indicator": "3rd line regimens", "male_<15": TextEditingController(text: "0"), "male_>=15": TextEditingController(text: "0"), "female_<15": TextEditingController(text: "0"), "female_>=15": TextEditingController(text: "0")},
      ]
    },
    {
      "section": "Multi-Month Dispensing",
      "data": [
        {"indicator": "MMD3", "male_<15": TextEditingController(text: "1"), "male_>=15": TextEditingController(text: "16"), "female_<15": TextEditingController(text: "0"), "female_>=15": TextEditingController(text: "24")},
        {"indicator": "MMD4", "male_<15": TextEditingController(text: "2"), "male_>=15": TextEditingController(text: "147"), "female_<15": TextEditingController(text: "4"), "female_>=15": TextEditingController(text: "168")},
      ]
    },
  ];


  List<Map<String, dynamic>> weeklyDataValues = [
    {"indicatorGroup": "HTS GROUPS", "hts_ts_facility_index": 10, "hts_ts_facility_pos": 2, "hts_ts_community_index": 5, "hts_ts_community_pos": 1},
  ];

  List<Map<String, dynamic>> dailyActivitiesData = [
    {"day": "Monday", "date": "1/13/2025", "daily_activities": "Collect forms", "responsible_persons": "John Doe", "status": "Done"},
  ];

  Map<String, dynamic> performanceIndicatorsData = {
    "facility_index_tested": 100, "facility_index_positive": 10, "pitc_ward_opd_tested": 44, "pitc_ward_opd_positive": 15,
  };

  List<Map<String, dynamic>> indicatorAchievementData = [
    {"indicator": "HTS_TST", "fy24_target": 1525, "month1": 488, "month2": 166, "month3": 166, "achievement_ytd": 2314, "percent_achievement": 119, "gaps": 1438},
  ];

  List<Map<String, dynamic>> itRateData = [
    { "expected_appointment": 1060, "total_came":1000, "total_missed": 60, "total_tracked": 50, "appointment_compliance": 2,"comments":"All tracked"},
  ];

  Map<String, dynamic> newHIVPositiveData = {
    "total_number_newly_tested_positive": 1, "tx_new_weekly_arvs": 1, "no_new_art_patients": 0,
  };

  // --- TB Report Data and Controllers ---
  List<String> tbReportIndicators = [
    "Total Number Newly Tested HIV Positive (HTS TST POSITIVE)",
    "TX NEW (Tx New is the number of new patients COMMENCED on ARVs during the week)",
    "No of new ART patients (TX NEW) clinically screened for TB",
    "Number of Presumptive cases Identified (among those TESTED Positive) (Subset of indicator 1 Above)",
    "Number of Presumptive cases evaluated for LF LAM, GeneXpert, or other Test (among the HTS TST POS in 4 above)",
    "Indicate the type of test ( TB LF LAMGene Xpert, C-Xray, AFB,TB LF LAM)",
    "Number of results from 7 above that returned in the week under review",
    "Number of results returned from previous weeks only",
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
    "Indicate the type of test ( Gene Xpert, C-Xray, AFB)",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) results returned for the index week",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) results returned from previous week/s only ) indicate particular week e.g week 16",
    "Number of ART Patients already on treatment tested positive for TB",
    "Number of ART Patients already on treatment started TB Treatment",
    "Number of ART patients Less than 5 Years already on treatment started TB Treatment",
    "ART patients already on treatment who came for drug refill ( Facility and other streams) Screened Negative ( Non presumptive Presumptive TB )",
    "ART patients already on treatment Completed IPT or already commenced IPT ( Subset of 26 above)",
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

  Map<String, TextEditingController> tbReportControllers = {};
  Map<String, TextEditingController> vlReportControllers = {};
  Map<String, TextEditingController> pharmTechReportControllers = {};
  Map<String, TextEditingController> trackingAssistantReportControllers = {};
  Map<String, TextEditingController> artNurseReportControllers = {};
  Map<String, TextEditingController> htsReportControllers = {};
  Map<String, TextEditingController> siReportControllers = {};
  Map<String, String?> tbReportUsernames = {}; // Track username per indicator
  Map<String, String?> vlReportUsernames = {}; // Track username per indicator
  Map<String, String?> pharmTechReportUsernames = {}; // Track username per indicator
  Map<String, String?> trackingAssistantReportUsernames = {}; // Track username per indicator
  Map<String, String?> artNurseReportUsernames = {}; // Track username per indicator
  Map<String, String?> htsReportUsernames = {}; // Track username per indicator
  Map<String, String?> siReportUsernames = {}; // Track username per indicator

  // --- Data Concurrence Report Data and Controllers ---
  List<Map<String, dynamic>> dataConcurrenceData = [
    {
      "indicator": "MMD<3",
      "emrController": TextEditingController(text: "0"),
      "pdwController": TextEditingController(text: "0"),
    },
    {
      "indicator": "MMD 3 - 5",
      "emrController": TextEditingController(text: "0"),
      "pdwController": TextEditingController(text: "0"),
    },
    {
      "indicator": "MMD 6",
      "emrController": TextEditingController(text: "0"),
      "pdwController": TextEditingController(text: "0"),
    },
    {
      "indicator": "Total Drugs Dispensed",
      "emrController": TextEditingController(text: "0"),
      "pdwController": TextEditingController(text: "0"),
    },
  ];


  // --- Target vs Achievement Report Data and Controllers ---
  List<Map<String, dynamic>> targetVsAchievementData = [
    {"indicator": "HTS_TST", "fyTarget": 1926, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_SELF", "fyTarget": 30, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_INDEX", "fyTarget": 98, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_INDEX_POS", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_TST_POS", "fyTarget": 29, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_RECENT", "fyTarget": 29, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TX_NEW", "fyTarget": 27, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TX_CURR", "fyTarget": 659, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_STAT", "fyTarget": 729, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_STAT_POS", "fyTarget": 10, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_ART", "fyTarget": 9, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_EID (Samples)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_HEI (Results)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_FO (Same as from MR)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PMTCT_HEI_POS", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "VL ELIGIBLE", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "VL SAMPLES COLLECTED", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "VL RESULTS RECEIVED", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "CXCA_SCRN", "fyTarget": 97, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "CXCA_SCRN_POS", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TB_STAT", "fyTarget": 14, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TB_STAT_POS", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TB_ART", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TB_PREV_D (Started)", "fyTarget": 40, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TB_PREV_N(Completed)", "fyTarget": 40, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PrEP_NEW", "fyTarget": 60, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "PrEP_CT", "fyTarget": 17, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "OVC_OFFER", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "OVC_ART_ENROLL", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "GEND_GBV", "fyTarget": 12, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_TST (0-14yrs)", "fyTarget": 78, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_TST_POS (0-14yrs)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TX_NEW (0-14yrs)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_TST (15-19yrs)", "fyTarget": 9, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "HTS_TST_POS (15-19yrs)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
    {"indicator": "TX_NEW (15-19yrs)", "fyTarget": 0, "fyAchievementController": TextEditingController(text: "0")},
  ];


  // --- HTS Testing Report Data and Controllers ---
  List<Map<String, dynamic>> htsTestingData = [
    {"section": "Facility Index", "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "PITC (Ward, OPD, etc.)", "newOdpAttendanceController": TextEditingController(text: "44"), "testedController": TextEditingController(text: "19"), "positiveController": TextEditingController(text: "1")},
    {"section": "PITC (TB)", "newTbClientsController": TextEditingController(), "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "PITC (ANC)", "newAncAttendeesController": TextEditingController(text: "4"), "testedController": TextEditingController(text: "4"), "positiveController": TextEditingController()},
    {"section": "PITC(Spoke)", "testedController": TextEditingController(text: "75"), "positiveController": TextEditingController()},
    {"section": "Community(ANC)", "newAncAttendeesController": TextEditingController(text: "56"), "testedController": TextEditingController(text: "56"), "positiveController": TextEditingController()},
    {"section": "Other HTS (Community Testing)", "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "Other HTS (Community testing - INDEX)", "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "Other HTS (CBO testing)", "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "Other HTS (CBO testing - INDEX)", "testedController": TextEditingController(), "positiveController": TextEditingController()},
    {"section": "VIRAL LOAD", "totalPositiveController": TextEditingController(text: "1"), "linkageRateController": TextEditingController(text: "100"), "txNewController": TextEditingController(text: "1")},
    {"section": "TLD 30", "usageController": TextEditingController(), "stockOnHandController": TextEditingController()},
    {"section": "TLD 90", "usageController": TextEditingController(text: "39"), "stockOnHandController": TextEditingController()},
    {"section": "DETERMINE", "usageController": TextEditingController(text: "98"), "stockOnHandController": TextEditingController()},
  ];


  String _currentUsername = "User1"; // Replace with actual username retrieval
  // ---------------------------------------------------
  // --- State variables for TB Report Dropdowns ---
  String _selectedReportType = "Weekly"; // Default Report Type
  String? _selectedReportPeriod;       // Selected Report Period (initially null)
  String? _selectedMonthForWeekly;    // Selected Month for Weekly report
  List<String> _reportPeriodOptions = []; // Options for Report Period dropdown
  List<String> _monthlyOptions = [];     // Options for Month dropdown (Month Year format)


  // --- Task Manager related variables and controllers ---
  //final TaskController _taskController = Get.put(TaskController()); // Get the task controller
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
    //_taskController.getTasks(); // Load tasks from Isar on page load

    // Initialize TextEditingControllers for TB Report
    for (String indicator in tbReportIndicators) {
      tbReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      tbReportUsernames[indicator] = null; // Initially no username
    }

    // Initialize TextEditingControllers for TB Report
    for (String indicator in vlReportIndicators) {
      vlReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      vlReportUsernames[indicator] = null; // Initially no username
    }

    for (String indicator in pharmTechReportIndicators) {
      pharmTechReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      pharmTechReportUsernames[indicator] = null; // Initially no username
    }

    for (String indicator in trackingAssistantReportIndicators) {
      trackingAssistantReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      trackingAssistantReportUsernames[indicator] = null; // Initially no username
    }

    for (String indicator in artNurseReportIndicators) {
      artNurseReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      artNurseReportUsernames[indicator] = null; // Initially no username
    }

    for (String indicator in htsReportIndicators) {
      htsReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      htsReportUsernames[indicator] = null; // Initially no username
    }

    for (String indicator in siReportIndicators) {
      siReportControllers[indicator] = TextEditingController(text: "0"); // Initialize with "0" or empty string
      siReportUsernames[indicator] = null; // Initially no username
    }

    _monthlyOptions = _generateMonthlyOptions(); // Generate monthly options
    _updateReportPeriodOptions(_selectedReportType); // Initialize Report Period Options based on default Report Type

    _calculateTotalDispensed(); // Calculate initial total dispensed values
  }

  // Function to update Report Period options based on Report Type
  void _updateReportPeriodOptions(String reportType) {
    setState(() {
      _selectedReportPeriod = null; // Reset selected period when type changes
      _selectedMonthForWeekly = null; // Reset selected month when type changes
      if (reportType == "Weekly") {
        _reportPeriodOptions = ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"];
      } else if (reportType == "Monthly") {
        _reportPeriodOptions = _monthlyOptions;
      } else {
        _reportPeriodOptions = []; // No options if report type is not valid
      }
    });
  }

  // Function to generate monthly options for the last 12 months
  List<String> _generateMonthlyOptions() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1); // Go back i months
      months.add(DateFormat("MMMM yyyy").format(monthDate)); // Format as "Month Year"
    }
    return months;
  }

  void _calculateTotalDispensed() {
    double totalEmr = 0;
    double totalPdw = 0;

    for (int i = 0; i < 3; i++) { // Iterate through MMD<3, MMD 3-5, MMD 6 rows
      totalEmr += double.tryParse(dataConcurrenceData[i]['emrController'].text) ?? 0;
      totalPdw += double.tryParse(dataConcurrenceData[i]['pdwController'].text) ?? 0;
    }

    dataConcurrenceData[3]['emrController'].text = totalEmr.toString();
    dataConcurrenceData[3]['pdwController'].text = totalPdw.toString();
  }

  String _calculatePercentage(String achievementValue, String targetValue) {
    double achievement = double.tryParse(achievementValue) ?? 0;
    double target = double.tryParse(targetValue) ?? 0;

    if (target == 0) {
      return "0%";
    }
    double percentage = (achievement / target) * 100;
    return "${percentage.toStringAsFixed(0)}%";
  }

  String _calculateGaps(String achievementValue, String targetValue) {
    double achievement = double.tryParse(achievementValue) ?? 0;
    double target = double.tryParse(targetValue) ?? 0;
    double gaps = target - achievement;
    return "${gaps.toStringAsFixed(0)}";
  }

  String _calculateFYYear() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    if (currentMonth < 10) { // Months before October (10)
      return currentYear.toString();
    } else {
      return (currentYear + 1).toString();
    }
  }

  String _calculateYield(String positiveValue, String testedValue) {
    double positive = double.tryParse(positiveValue) ?? 0;
    double tested = double.tryParse(testedValue) ?? 0;
    if (tested == 0) return "0.0%";
    double yieldValue = (positive / tested) * 100;
    return "${yieldValue.toStringAsFixed(1)}%"; // Format to 1 decimal place
  }

  String _calculateLinkageRate(String txNewValue, String totalPositiveValue) {
    double txNew = double.tryParse(txNewValue) ?? 0;
    double totalPositive = double.tryParse(totalPositiveValue) ?? 0;
    if (totalPositive == 0) return "0%";
    double linkageRate = (txNew / totalPositive) * 100;
    return "${linkageRate.toStringAsFixed(0)}%";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, IsarService()), // Assuming drawer is defined elsewhere
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // For vertical scrolling of the entire page
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _addActivityBar(),

            SizedBox(height: 20),
            Text('HTS Testing Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildHTSTestingReport(),


            SizedBox(height: 20),
            Text('Target vs Achievement Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildTargetVsAchievementReport(),

            SizedBox(height: 20),
            Text('Missed Appointment Tracking', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildITRateReport(),

            SizedBox(height: 20),
            Text('TB Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildTBReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('VL Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildVLReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('Pharmacy Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildPharmTechReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('Tracking Assistant Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildTrackingAssistantReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('ART Nurse Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildARTNurseReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('HTS Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildHTSReport(), // Add TB Report Widget here

            SizedBox(height: 20),

            Text('SI Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildSIReport(), // Add TB Report Widget here

            SizedBox(height: 20),
            Text('Data Concurrence Report', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            _buildDataConcurrenceReport(),
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


  Widget _buildNationalFacilityARTMonthlySummaryFormReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(monthlySummaryData[0], ["", "<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50+", "Total"]),
            _buildSummarySection(monthlySummaryData[1], ["", "<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50+", "Total"]),
            _buildSummaryLabels(monthlySummaryData[1]["data"].sublist(3)), // Pregnant, Breastfeeding, TB Patients
            _buildSummarySection(monthlySummaryData[2], ["", "<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50+", "Total"]),
            _buildSummaryLabels(monthlySummaryData[2]["data"].sublist(3)), // Pregnant, Breastfeeding (subset of ART 2)
            //_buildSummaryRegimensSection(monthlySummaryData[3], ["", "Male", "Female", "Total"]),
            _buildSummaryRegimensSection(monthlySummaryData[3], ["", "<15 Male", ">=15 Male", "<15 Female", ">=15 Female", "Total"]),
           // _buildSummaryMMDSection(monthlySummaryData[4], ["", "Male", "Female", "Total"]),
            _buildSummaryMMDSection(monthlySummaryData[4], ["", "<15 Male", ">=15 Male", "<15 Female", ">=15 Female", "Total"]),
          ],
        ),
      ),
    );
  }


  Widget _buildSummarySection(Map<String, dynamic> sectionData, List<String> headers) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(sectionData["section"], style: Theme.of(context).textTheme.titleMedium),
    SizedBox(height: 8),
    DataTable(
    columnSpacing: 15.0,
    dataRowHeight: 30,
    headingRowHeight: 30,
    border: TableBorder.all(width: 0.8, color: Colors.grey.shade400),
    columns: headers.map((header) => DataColumn(
      label: header == "" ? Text(header) : Center(child: Text(header)), // Center align headers except the first one
    )).toList(),
      rows: (sectionData["data"] as List<Map<String, dynamic>>).map((rowData) {
        List<DataCell> cells = [];
        if (rowData["indicator"] != null) {
          cells.add(DataCell(Text(rowData["indicator"])));
        } else {
          cells.add(DataCell(Container())); // Empty cell for labels section
        }

        List<String> ageGroups = ["<1", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50_plus"]; // Age groups for iteration
        for (String age in ageGroups) {
          if (rowData["age_$age"] != null) {
            cells.add(DataCell(
              SizedBox(
                width: 30,
                height: 30,
                child: TextFormField(
                  controller: rowData["age_$age"],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Rebuild on value change
                  },
                ),
              ),
            ));
          } else {
            cells.add(DataCell(Container())); // Empty cell if no age data
          }
        }
        cells.add(DataCell(Container())); // Empty cell for "Total" - will calculate later if needed

        return DataRow(cells: cells);
      }).toList(),
    ),
          SizedBox(height: 15),
        ],
    );
  }


  Widget _buildSummaryLabels(List<Map<String, dynamic>> labelData) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: labelData.map((labelRow) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text("${labelRow["indicator"]}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: labelRow["value"],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildSummaryRegimensSection(Map<String, dynamic> sectionData, List<String> headers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionData["section"], style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        DataTable(
          columnSpacing: 15.0,
          dataRowHeight: 30,
          headingRowHeight: 30,
          border: TableBorder.all(width: 0.8, color: Colors.grey.shade400),
          columns: headers.map((header) => DataColumn(
            label: header == "" ? Text(header) : Center(child: Text(header)),
          )).toList(),
          rows: (sectionData["data"] as List<Map<String, dynamic>>).map((rowData) {
            return DataRow(cells: [
              DataCell(Text(rowData["indicator"])),
              DataCell(_buildSizedBoxTextField(rowData["male_<15"])),
              DataCell(_buildSizedBoxTextField(rowData["male_>=15"])),
              DataCell(_buildSizedBoxTextField(rowData["female_<15"])),
              DataCell(_buildSizedBoxTextField(rowData["female_>=15"])),
              DataCell(Container()), // Empty cell for "Total" - will calculate later if needed
            ]);
          }).toList(),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSummaryMMDSection(Map<String, dynamic> sectionData, List<String> headers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionData["section"], style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        DataTable(
          columnSpacing: 15.0,
          dataRowHeight: 30,
          headingRowHeight: 30,
          border: TableBorder.all(width: 0.8, color: Colors.grey.shade400),
          columns: headers.map((header) => DataColumn(
            label: header == "" ? Text(header) : Center(child: Text(header)),
          )).toList(),
          rows: (sectionData["data"] as List<Map<String, dynamic>>).map((rowData) {
            return DataRow(cells: [
              DataCell(Text(rowData["indicator"])),
              DataCell(_buildSizedBoxTextField(rowData["male_<15"])),
              DataCell(_buildSizedBoxTextField(rowData["male_>=15"])),
              DataCell(_buildSizedBoxTextField(rowData["female_<15"])),
              DataCell(_buildSizedBoxTextField(rowData["female_>=15"])),
              DataCell(Container()), // Empty cell for "Total" - will calculate later if needed
            ]);
          }).toList(),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSizedBoxTextField(TextEditingController controller) {
    return SizedBox(
      width: 70,
      height: 30,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild on value change
        },
      ),
    );
  }


  Widget _buildWeeklyDataValuesReport() {
    return _buildDataTableCard(
      title: 'FY25 BI-WEEKLY DATA VALUE',
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
    );
  }

  Widget _buildDailyActivitiesReport() {
    return _buildDataTableCard(
      title: 'Daily Activities',
      columns: [
        DataColumn(label: Text('Day')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Daily Activities')),
        DataColumn(label: Text('Responsible Persons')),
        DataColumn(label: Text('Status')),
      ],
      rows: dailyActivitiesData.map((data) => DataRow(cells: [
        DataCell(Text(data['day'] ?? '')),
        DataCell(Text(data['date'] ?? '')),
        DataCell(Text(data['daily_activities'] ?? '')),
        DataCell(Text(data['responsible_persons'] ?? '')),
        DataCell(Text(data['status'] ?? '')),
      ])).toList(),
    );
  }


  Widget _buildMonthlySummaryReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Added for horizontal scrolling
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
              DataCell(Text(data['age_lessthan_1'].toString() ?? '')),
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

  Widget _buildWeeklyDataValuesReport1() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Added for horizontal scrolling
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

  Widget _buildDailyActivitiesReport1() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Added for horizontal scrolling
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
              DataColumn(label: Text('Day')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Daily Activities')),
              DataColumn(label: Text('Responsible Persons')),
              DataColumn(label: Text('Status')),
            ],
            rows: dailyActivitiesData.map((data) => DataRow(cells: [
              DataCell(Text(data['day'] ?? '')),
              DataCell(Text(data['date'] ?? '')),
              DataCell(Text(data['daily_activities'] ?? '')),
              DataCell(Text(data['responsible_persons'] ?? '')),
              DataCell(Text(data['status'] ?? '')),
            ])).toList(),
          ),
        ),
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
        child: SingleChildScrollView( // Added for horizontal scrolling
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
        child: SingleChildScrollView( // Added for horizontal scrolling
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0,
            horizontalMargin: 10.0,
            border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
            columns: [
             // DataColumn(label: Text('Facility Name')),
              DataColumn(label: Text('Expected Appointment')),
              DataColumn(label: Text('Total Who Came')),
              DataColumn(label: Text('Total Who Missed')),
              DataColumn(label: Text('Total Tracked')),
              DataColumn(label: Text('Appointment Compliance')),
              DataColumn(label: Text('Comments')),
            ],
            rows: itRateData.map((data) => DataRow(cells: [
              //DataCell(Text(data['facility_name'] ?? '')), "expected_appointment": 1060, "total_came":1000, "total_missed": 60, "total_tracked": 50, "appointment_compliance": 2
              DataCell(Text(data['expected_appointment'].toString() ?? '')),
              DataCell(Text(data['total_came'].toString() ?? '')),
              DataCell(Text(data['total_missed'].toString() ?? '')),
              DataCell(Text(data['total_tracked'].toString() ?? '')),
              DataCell(Text(data['appointment_compliance'].toString() ?? '')),
              DataCell(Text(data['comments'].toString() ?? '')),
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

  Widget _buildTBReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...tbReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: tbReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                tbReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (tbReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${tbReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildVLReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...vlReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: vlReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                vlReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (vlReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${vlReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmTechReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...pharmTechReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: pharmTechReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                pharmTechReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (pharmTechReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${pharmTechReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _buildTrackingAssistantReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...trackingAssistantReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: trackingAssistantReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                trackingAssistantReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (trackingAssistantReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${trackingAssistantReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _buildARTNurseReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...artNurseReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: artNurseReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                artNurseReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (artNurseReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${artNurseReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _buildHTSReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...htsReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: htsReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                htsReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (htsReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${htsReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _buildSIReport() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Report Type Dropdown ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: _selectedReportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedReportType = newValue;
                    _updateReportPeriodOptions(_selectedReportType); // Update Period options based on Type
                  });
                }
              },
            ),
            SizedBox(height: 10),

            // --- Report Period Dropdowns based on Report Type ---
            if (_selectedReportType == "Monthly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            else if (_selectedReportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: _selectedReportPeriod,
                    items: _reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReportPeriod = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: _selectedMonthForWeekly,
                    items: _monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonthForWeekly = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),


            // --- Indicator Input Fields ---
            ...siReportIndicators.map((indicator) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column( // Wrap each indicator row in a Column
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex values as needed for layout
                          child: Text(indicator, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1, // Adjust flex values as needed for layout
                          child: TextFormField(
                            controller: siReportControllers[indicator],
                            keyboardType: TextInputType.number, // Allow only number input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true, // Reduce vertical padding
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding inside
                            ),
                            onChanged: (value) {
                              setState(() {
                                siReportUsernames[indicator] = _currentUsername; // Store username on input
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (siReportUsernames[indicator] != null) // Show username if available
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10.0),
                        child: Text(
                          "Entered by: ${siReportUsernames[indicator]}",
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    SizedBox(height: 5), // Add some spacing below the username
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }



  Widget _buildReportCard({
    required String title,
    required String reportType,
    required String? reportPeriod,
    required String? monthForWeekly,
    required List<String> reportPeriodOptions,
    required List<String> monthlyOptions,
    required ValueChanged<String?> onReportTypeChanged,
    required ValueChanged<String?> onReportPeriodChanged,
    required ValueChanged<String?> onMonthForWeeklyChanged,
    required List<Widget> indicatorFields,
  }) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Report Type'),
              value: reportType,
              items: ["Weekly", "Monthly"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onReportTypeChanged,
            ),
            SizedBox(height: 10),
            if (reportType == "Monthly")
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Report Period'),
                value: reportPeriod,
                items: reportPeriodOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onReportPeriodChanged,
              )
            else if (reportType == "Weekly")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Report Period'),
                    value: reportPeriod,
                    items: reportPeriodOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: onReportPeriodChanged,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Month'),
                    value: monthForWeekly,
                    items: monthlyOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: onMonthForWeeklyChanged,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            SizedBox(height: 20),
            ...indicatorFields,
          ],
        ),
      ),
    );
  }


  Widget _buildTargetVsAchievementReport() {
    final fyYear = _calculateFYYear();
    DateTime date = DateTime(int.parse(fyYear));
    String formattedYear = DateFormat('yy').format(date);
    return _buildReportCard(
        title: '',
        reportType: _selectedReportType,
        reportPeriod: _selectedReportPeriod,
        monthForWeekly: _selectedMonthForWeekly,
        reportPeriodOptions: _reportPeriodOptions,
        monthlyOptions: _monthlyOptions,
        onReportTypeChanged: (newValue) {
          setState(() {
            _selectedReportType = newValue!;
            _updateReportPeriodOptions(_selectedReportType);
          });
        },
        onReportPeriodChanged: (newValue) {
          setState(() {
            _selectedReportPeriod = newValue;
          });
        },
        onMonthForWeeklyChanged: (newValue) {
          setState(() {
            _selectedMonthForWeekly = newValue;
          });
        },
        indicatorFields: [
          _buildDataTableCard(
            title: '',
            showTitle: false,
            columns: [
              DataColumn(label: Text('Indicator')),
              DataColumn(label: Text('FY$formattedYear Target')),
              DataColumn(label: Text('FY$formattedYear Achievement')),
              DataColumn(label: Text('% FY$formattedYear Achievement')),
              DataColumn(label: Text('Gaps')),
            ],
            rows: targetVsAchievementData.map((data) {
              return DataRow(cells: [
                DataCell(Text(data['indicator'] ?? '')),
                DataCell(Text(data['fyTarget'].toString())), // Non-editable Target
                DataCell(
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: data['fyAchievementController'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Rebuild to recalculate percentage and gaps
                      },
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _calculatePercentage(data['fyAchievementController'].text, data['fyTarget'].toString()),
                  ),
                ),
                DataCell(
                  Text(
                    _calculateGaps(data['fyAchievementController'].text, data['fyTarget'].toString()),
                  ),
                ),
              ]);
            }).toList(),
          )
        ]
    );
  }

  Widget _buildDataConcurrenceReport() {
    return _buildReportCard(
      title: '',
      reportType: _selectedReportType,
      reportPeriod: _selectedReportPeriod,
      monthForWeekly: _selectedMonthForWeekly,
      reportPeriodOptions: _reportPeriodOptions,
      monthlyOptions: _monthlyOptions,
      onReportTypeChanged: (newValue) {
        setState(() {
          _selectedReportType = newValue!;
          _updateReportPeriodOptions(_selectedReportType);
        });
      },
      onReportPeriodChanged: (newValue) {
        setState(() {
          _selectedReportPeriod = newValue;
        });
      },
      onMonthForWeeklyChanged: (newValue) {
        setState(() {
          _selectedMonthForWeekly = newValue;
        });
      },
      indicatorFields: [
        _buildDataTableCard( // Embed DataTable inside the card
          title: '', // No title for the DataTable itself, title is for the whole report card
          showTitle: false, // Hide the DataTable's title
          columns: [
            DataColumn(label: Text('Indicator')),
            DataColumn(label: Text('EMR')),
            DataColumn(label: Text('PDW')),
            DataColumn(label: Text('Concurrence Rate')),
          ],
          rows: dataConcurrenceData.map((data) {
            bool isTotalRow = data['indicator'] == "Total Drugs Dispensed";
            return DataRow(cells: [
              DataCell(Text(data['indicator'] ?? '')),
              DataCell(
                isTotalRow
                    ? Text(data['emrController'].text) // Display sum, not editable
                    : SizedBox(
                  width: 70,
                  child: TextField(
                    controller: data['emrController'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _calculateTotalDispensed(); // Recalculate totals on value change
                      });
                    },
                  ),
                ),
              ),
              DataCell(
                isTotalRow
                    ? Text(data['pdwController'].text) // Display sum, not editable
                    : SizedBox(
                  width: 70,
                  child: TextField(
                    controller: data['pdwController'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _calculateTotalDispensed(); // Recalculate totals on value change
                      });
                    },
                  ),
                ),
              ),
              DataCell(
                Text(_calculateConcurrenceRate(data['emrController'].text, data['pdwController'].text)),
              ),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  String _calculateConcurrenceRate(String emrValue, String pdwValue) {
    double emr = double.tryParse(emrValue) ?? 0;
    double pdw = double.tryParse(pdwValue) ?? 0;

    if (pdw == 0) {
      return "0%"; // Avoid division by zero
    }
    double concurrenceRate = (emr / pdw) * 100;
    return "${concurrenceRate.toStringAsFixed(0)}%"; // Format to percentage, no decimal
  }


  Widget _buildIndicatorInputField({
    required String indicator,
    required TextEditingController controller,
    required Map<String, String?> usernameMap,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
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
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          if (usernameMap[indicator] != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 10.0),
              child: Text(
                "Entered by: ${usernameMap[indicator]}",
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
          SizedBox(height: 5),
        ],
      ),
    );
  }


  Widget _buildDataTableCard({
    required String title,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    bool showTitle = true, // Added to conditionally hide title for embedded DataTable
  }) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) // Conditionally show title
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (showTitle) SizedBox(height: 10), // Conditionally add SizedBox
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20.0,
                horizontalMargin: 10.0,
                border: TableBorder.all(width: 1.0, color: Colors.grey.shade300),
                columns: columns,
                rows: rows,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildColumnCard({
    required String title,
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildHTSTestingReport() {
    return _buildReportCard(
      title: 'HTS Testing Report',
      reportType: _selectedReportType,
      reportPeriod: _selectedReportPeriod,
      monthForWeekly: _selectedMonthForWeekly,
      reportPeriodOptions: _reportPeriodOptions,
      monthlyOptions: _monthlyOptions,
      onReportTypeChanged: (newValue) {
        setState(() {
          _selectedReportType = newValue!;
          _updateReportPeriodOptions(_selectedReportType);
        });
      },
      onReportPeriodChanged: (newValue) {
        setState(() {
          _selectedReportPeriod = newValue;
        });
      },
      onMonthForWeeklyChanged: (newValue) {
        setState(() {
          _selectedMonthForWeekly = newValue;
        });
      },
      indicatorFields: [
        _buildHTSTestingSection('Facility Index', htsTestingData[0]),
        _buildHTSTestingPITCSection('PITC (Ward, OPD, etc.)', htsTestingData[1]),
        _buildHTSTestingPITCSection('PITC (TB)', htsTestingData[2]),
        _buildHTSTestingPITCSection('PITC (ANC)', htsTestingData[3]),
        _buildHTSTestingPITCSpokeSection('PITC(Spoke)', htsTestingData[4]),
        _buildHTSTestingCommunityANCSection('Community(ANC)', htsTestingData[5]),
        _buildHTSTestingOtherHTSSection('Other HTS (Community Testing)', htsTestingData[6]),
        _buildHTSTestingOtherHTSSection('Other HTS (Community testing - INDEX)', htsTestingData[7]),
        _buildHTSTestingOtherHTSSection('Other HTS (CBO testing)', htsTestingData[8]),
        _buildHTSTestingOtherHTSSection('Other HTS (CBO testing - INDEX)', htsTestingData[9]),
        _buildHTSTestingViralLoadSection('VIRAL LOAD', htsTestingData[10]),
        _buildHTSTestingTLDSection('TLD 30', htsTestingData[11]),
        _buildHTSTestingTLDSection('TLD 90', htsTestingData[12]),
        _buildHTSTestingDetermineSection('DETERMINE', htsTestingData[13]),

      ],
    );
  }

  Widget _buildHTSTestingSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingRow('Tested', sectionData['testedController'], sectionData['positiveController']),
        _buildHTSTestingRow('Positive', sectionData['positiveController'], sectionData['testedController']),
        _buildHTSTestingCalculatedRow('% weekly target achieved', sectionData['positiveController'], sectionData['testedController'], calculateType: 'percentage'),
        _buildHTSTestingCalculatedRow('Yield', sectionData['positiveController'], sectionData['testedController'], calculateType: 'yield'),
      ],
    );
  }

  Widget _buildHTSTestingPITCSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sectionData.containsKey('newOdpAttendanceController')) _buildHTSTestingLabelRow('New OPD Attendance(excludes ANC &TB)', sectionData['newOdpAttendanceController']),
        if (sectionData.containsKey('newTbClientsController')) _buildHTSTestingLabelRow('New TB Clients(HIV Status Unknown)', sectionData['newTbClientsController']),
        _buildHTSTestingRow('Tested', sectionData['testedController'], sectionData['positiveController']),
        _buildHTSTestingRow('Positive', sectionData['positiveController'], sectionData['testedController']),
        _buildHTSTestingCalculatedRow('% weekly target achieved', sectionData['positiveController'], sectionData['testedController'], calculateType: 'percentage'),
        _buildHTSTestingCalculatedRow('Yield', sectionData['positiveController'], sectionData['testedController'], calculateType: 'yield'),
      ],
    );
  }
  Widget _buildHTSTestingPITCSpokeSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingRow('Tested', sectionData['testedController'], sectionData['positiveController']),
        _buildHTSTestingRow('Positive', sectionData['positiveController'], sectionData['testedController']),
        _buildHTSTestingCalculatedRow('% weekly target achieved', sectionData['positiveController'], sectionData['testedController'], calculateType: 'percentage'),
        _buildHTSTestingCalculatedRow('Yield', sectionData['positiveController'], sectionData['testedController'], calculateType: 'yield'),
      ],
    );
  }

  Widget _buildHTSTestingCommunityANCSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingLabelRow('New ANC Attendees', sectionData['newAncAttendeesController']),
        _buildHTSTestingRow('Tested', sectionData['testedController'], sectionData['positiveController']),
        _buildHTSTestingRow('Positive', sectionData['positiveController'], sectionData['testedController']),
        _buildHTSTestingCalculatedRow('% weekly target achieved', sectionData['positiveController'], sectionData['testedController'], calculateType: 'percentage'),
        _buildHTSTestingCalculatedRow('Yield', sectionData['positiveController'], sectionData['testedController'], calculateType: 'yield'),
      ],
    );
  }
  Widget _buildHTSTestingOtherHTSSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingRow('Tested', sectionData['testedController'], sectionData['positiveController']),
        _buildHTSTestingRow('Positive', sectionData['positiveController'], sectionData['testedController']),
        _buildHTSTestingCalculatedRow('% weekly target achieved', sectionData['positiveController'], sectionData['testedController'], calculateType: 'percentage'),
        _buildHTSTestingCalculatedRow('Yield', sectionData['positiveController'], sectionData['testedController'], calculateType: 'yield'),
      ],
    );
  }

  Widget _buildHTSTestingViralLoadSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingLabelRow('Total Positive', sectionData['totalPositiveController']),
        _buildHTSTestingCalculatedRow('Linkage rate', sectionData['txNewController'], sectionData['totalPositiveController'], calculateType: 'linkageRate'),
        _buildHTSTestingLabelRow('Tx_NEW', sectionData['txNewController']),
      ],
    );
  }

  Widget _buildHTSTestingTLDSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingLabelRow('Usage', sectionData['usageController']),
        _buildHTSTestingLabelRow('Stock on Hand', sectionData['stockOnHandController']),
      ],
    );
  }
  Widget _buildHTSTestingDetermineSection(String title, Map<String, dynamic> sectionData) {
    return _buildColumnCard(
      title: title,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHTSTestingLabelRow('Usage', sectionData['usageController']),
        _buildHTSTestingLabelRow('Stock on Hand', sectionData['stockOnHandController']),
      ],
    );
  }


  Widget _buildHTSTestingRow(String label, TextEditingController? testedController, TextEditingController? positiveController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Wrap Text with Expanded
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: label == 'Tested' ? testedController : positiveController, // Assign controller based on label
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to recalculate Yield and Percentage
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHTSTestingLabelRow(String label, TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Wrap Text with Expanded
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to recalculate Yield and Percentage
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHTSTestingCalculatedRow(String label, TextEditingController? positiveController, TextEditingController? testedController, {required String calculateType}) {
    String calculatedValue = "";
    if (calculateType == 'percentage') {
      calculatedValue = _calculatePercentage(positiveController?.text ?? "0", testedController?.text ?? "0");
    } else if (calculateType == 'yield') {
      calculatedValue = _calculateYield(positiveController?.text ?? "0", testedController?.text ?? "0");
    } else if (calculateType == 'linkageRate') {
      calculatedValue = _calculateLinkageRate(testedController?.text ?? "0", positiveController?.text ?? "0"); // Example - adjust params if needed
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Wrap Text with Expanded
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
          ),
          Text(calculatedValue), // Display calculated value
        ],
      ),
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
                      // color: Colors.black54,
                      fontFamily: "NexaBold",
                      fontSize:  MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyButton(label: "Go to Daily Activity",onTap: ()async{
            await Get.to(()=>DailyActivityMonitoringPage());

          },
          )
        ],
      ),
    );
  }
}