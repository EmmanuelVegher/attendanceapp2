import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import '../../model/attendancemodel.dart';
import '../../model/bio_model.dart';
import '../../services/isar_service.dart';
import '../../widgets/drawer.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Alignment,Border; // Import and hide conflicting classes
import 'package:flutter_email_sender/flutter_email_sender.dart';


class TimesheetScreen extends StatefulWidget {
  const TimesheetScreen({super.key});

  @override
  _TimesheetScreenState createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends State<TimesheetScreen> {
  late DateTime startDate;
  late DateTime endDate;
  List<DateTime> daysInRange = [];
  TextEditingController facilitySupervisorController = TextEditingController();
  TextEditingController caritasSupervisorController = TextEditingController();
  late int selectedMonth; // Selected month index (0-based, 0=January)
  late int selectedYear;
  List<Map<String, dynamic>> facilitySupervisorsList = [];
  Map<String,
      dynamic>? _selectedFacilitySupervisor; // Holds the selected supervisor's data
  String? _selectedFacilitySupervisorFullName; // Holds the full name of the selected supervisor
  String? _selectedFacilitySupervisorEmail;
  String? _selectedFacilitySupervisorSignatureLink;

  bool _isLoading = true;

  String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  List<AttendanceModel> attendanceData = [];
  GlobalKey _globalKey = GlobalKey(); // Define the GlobalKey
  ScrollController _scrollController = ScrollController(); // Add a scroll controller

  List<String?> projectNames = []; // Store project names from Isar
  List<String?> supervisorNames = []; // Store project names from Isar
  //late final bioData;
  String? selectedProjectName;
  String? selectedBioFirstName;
  String? selectedBioLastName;
  String? selectedBioDepartment;
  String? selectedBioState;
  String? selectedBioDesignation;
  String? selectedBioLocation;
  String? selectedBioStaffCategory;
  String? selectedBioEmail;
  String? selectedBioPhone;
  String? selectedFirebaseId;
  String? facilitySupervisor;
  String? caritasSupervisor;
  DateTime? selectedDate;
  String? staffSignatureLink;
  BioModel? bioData; // Make bioData nullable// Currently selected project
  String? selectedSupervisor; // State variable to store the selected supervisor
  String? _selectedSupervisorEmail;
  String? _signatureLink;
  Uint8List? staffSignature; // Store staff signature as Uint8List
  Uint8List? facilitySupervisorSignature; // Array field for facility supervisor signature
  Uint8List? caritasSupervisorSignature; // Array field for Caritas supervisor signature
  List<String> attachments = [];
  bool isHTML = false;
  List<Uint8List> checkSignatureImage = []; // Initialize as empty list

  @override
  void initState() {
    super.initState();

    _readImagesFromDatabase().then((images) {
      setState(() {
        checkSignatureImage =
            images ?? []; // Assign fetched images or empty list
      });
    });

    // Other initialization logic
    _fetchFacilitySupervisor();
    _globalKey = GlobalKey();
    DateTime now = DateTime.now();
    selectedMonth = now.month - 1;
    selectedYear = now.year;
    initializeDateRange(selectedMonth, selectedYear);
    _loadProjectNames();
    _loadAttendanceData();
    _scrollController = ScrollController();
    bool isLoading = true; // Add a loading flag

    // Start the 5-second timer
    Timer(const Duration(seconds: 5), () async {
      await _loadBioData().then((_) async {
        if (bioData != null &&
            bioData!.department != null &&
            bioData!.state != null) {
          await getSupervisor(
              bioData!.firebaseAuthId!, selectedYear, selectedMonth);
          _loadSupervisorNames(bioData!.department!, bioData!.state!);
        } else {
          print("Bio data or department/state is missing!");
        }
      });

      // Stop loading state
      setState(() {
        isLoading = false;
      });
    });
  }

  DateTime createCustomDate(int selectedMonth, int selectedYear) {
    return DateTime(
        selectedYear, selectedMonth, 20); // Directly create the DateTime object
  }

  // ---------------

  Future<void> _showLogo() async {
    try {
      // Load the image as bytes
      final logoBytes = await rootBundle.load('assets/image/ccfn_logo.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      pw.Container(
        child: pw.Image(
          logoImage,
          width: 50, // Adjust width
          height: 50, // Adjust height
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _createAndExportPDF() async {
    final pdf = pw.Document(pageMode: PdfPageMode.outlines);
    String monthYear = DateFormat('MMMM, yyyy').format(
        DateTime(selectedYear, selectedMonth + 1));
    // A4 page in landscape mode
    final pageFormat = PdfPageFormat.a4.landscape;

    try {
      // Fetch supervisor names and signature columns
      final supervisorNames = await _getSupervisorNames();
      final signatureColumns = await _buildSignatureColumns(supervisorNames);

      // Load the image as bytes
      final logoBytes = await rootBundle.load('assets/image/ccfn_logo.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      // Add content to a single page
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Staff Information and Logo Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStaffInfo(context),
                    pw.Column(
                        children: [
                          pw.Text("CARITAS NIGERIA", style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20),),
                          pw.SizedBox(height: 10,),
                          pw.Text("Monthly Time Report ($monthYear)")
                        ]
                    ),
                    pw.Container(
                      child: pw.Image(
                        logoImage,
                        width: 50, // Adjust width
                        height: 50, // Adjust height
                      ),
                    ),
                  ],
                ),

                // Timesheet Table Section
                pw.SizedBox(height: 10), // Adjust spacing
                _buildTimesheetTable(context),

                // Signature Section
                pw.SizedBox(height: 10), // Adjust spacing
                _buildSignatureSection(context, signatureColumns),
              ],
            );
          },
        ),
      );

      // Save and open the PDF
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/timesheet.pdf");
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      print("Error generating PDF: $e");
      // Handle the error, e.g., show a dialog to the user
    }
  }

  Future<void> sendEmailToSelf() async {
    String monthYear1 = DateFormat('MMMM_yyyy').format(
        DateTime(selectedYear, selectedMonth + 1));

    final pdf = pw.Document(pageMode: PdfPageMode.outlines);
    String monthYear = DateFormat('MMMM, yyyy').format(
        DateTime(selectedYear, selectedMonth + 1));
    // A4 page in landscape mode
    final pageFormat = PdfPageFormat.a4.landscape;

    try {
      // Fetch supervisor names and signature columns
      final supervisorNames = await _getSupervisorNames();
      final signatureColumns = await _buildSignatureColumns(supervisorNames);

      // Load the image as bytes
      final logoBytes = await rootBundle.load('assets/image/ccfn_logo.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      // Add content to a single page
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Staff Information and Logo Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStaffInfo(context),
                    pw.Column(
                        children: [
                          pw.Text("CARITAS NIGERIA", style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20),),
                          pw.SizedBox(height: 10,),
                          pw.Text("Monthly Time Report ($monthYear)")
                        ]
                    ),
                    pw.Container(
                      child: pw.Image(
                        logoImage,
                        width: 50, // Adjust width
                        height: 50, // Adjust height
                      ),
                    ),
                  ],
                ),

                // Timesheet Table Section
                pw.SizedBox(height: 10), // Adjust spacing
                _buildTimesheetTable(context),

                // Signature Section
                pw.SizedBox(height: 10), // Adjust spacing
                _buildSignatureSection(context, signatureColumns),
              ],
            );
          },
        ),
      );

      // Save and open the PDF
      // final output = await getTemporaryDirectory();
      // final file = File("${output.path}/timesheet.pdf");
      // await file.writeAsBytes(await pdf.save());
      // await OpenFilex.open(file.path);


    } catch (e) {
      print("Error generating PDF: $e");
      // Handle the error, e.g., show a dialog to the user
    }

    // Clear the attachments list before adding new attachments
    attachments.clear();

    // 2. Save the PDF to a temporary file
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir
        .path}/Timesheet_${monthYear1}_${selectedBioFirstName}_$selectedBioLastName.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // 3. Add the PDF file path to attachments
    attachments.add(pdfFile.path);


    final Email email = Email(
      body: '''
Greetings $selectedBioFirstName,

Please find attached your timesheet for $monthYear.

Best regards,
$selectedBioFirstName $selectedBioLastName

''',
      subject: 'Timesheet for $selectedBioFirstName $selectedBioLastName ,$monthYear',
      recipients: [selectedBioEmail!],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }


  Future<Map<String, String>> _getSupervisorNames() async {
    try {
      String monthYear = DateFormat('MMMM_yyyy').format(
          DateTime(selectedYear, selectedMonth + 1));
      final timesheetDoc = await FirebaseFirestore.instance
          .collection("Staff")
          .doc(selectedFirebaseId)
          .collection("TimeSheets")
          .doc(monthYear)
          .get();

      if (timesheetDoc.exists) {
        final data = timesheetDoc.data() as Map<String, dynamic>;
        return {
          'staffName': data['staffName'] as String? ?? 'Not Assigned',
          'projectCoordinatorName': data['facilitySupervisor'] as String? ??
              'Not Assigned',
          'caritasSupervisorName': data['caritasSupervisor'] as String? ??
              'Not Assigned',
          'projectCoordinatorSignature': data['facilitySupervisorSignature'] as String? ??
              '', // Get signature URLs
          'caritasSupervisorSignature': data['caritasSupervisorSignature'] as String? ??
              '',
          'staffSignature': data['staffSignature'] as String? ?? '',
          'staffSignatureDate': data['staffSignatureDate'] as String? ?? '',
          'facilitySupervisorSignatureDate': data['facilitySupervisorSignatureDate'] as String? ??
              '',
          'caritasSupervisorSignatureDate': data['caritasSupervisorSignatureDate'] as String? ??
              '',
        };
      } else {
        return {
          'staffName': 'Not Assigned',
          'projectCoordinatorName': 'Not Assigned',
          'caritasSupervisorName': 'Not Assigned',
          'projectCoordinatorSignature': '',
          'caritasSupervisorSignature': '',
          'staffSignature': '',
          'staffSignatureDate': '',
          'facilitySupervisorSignatureDate': '',
          'caritasSupervisorSignatureDate': '',
        };
      }
    } catch (e) {
      print("Error fetching supervisor data: $e");
      return {
        'staffName': 'Error fetching name',
        'projectCoordinatorName': 'Error fetching name',
        'caritasSupervisorName': 'Error fetching name',
        'projectCoordinatorSignature': '',
        'caritasSupervisorSignature': '',
        'staffSignature': '',
        'staffSignatureDate': '',
        'facilitySupervisorSignatureDate': '',
        'caritasSupervisorSignatureDate': '',
      };
    }
  }


  pw.Widget _buildStaffInfo(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Name: $selectedBioFirstName $selectedBioLastName'),
        pw.Text('Department: $selectedBioDepartment'),
        pw.Text('Designation: $selectedBioDesignation'),
        pw.Text('Location: $selectedBioLocation'),
        pw.Text('State: $selectedBioState'),
        pw.SizedBox(height: 20), // Add some spacing

      ],
    );
  }

  pw.Widget _buildTimesheetTable(pw.Context context) {
    // Data for the table
    final tableHeaders = [
      'Project Name',
      ...daysInRange.map((date) => DateFormat('dd').format(date)).toList(),
      'Total Hours',
      '%'
    ];

    List<List<String>> allRows = []; // List to hold all rows



    // Project Data Row
    final projectData = [
      selectedProjectName ?? '',
      ...daysInRange.map((date) {
        return _getDurationForDate3(
            date, selectedProjectName, selectedProjectName!)
            .round()
            .toString(); // No rounding here
      }).toList(),
      // calculateTotalHours1(selectedProjectName).toStringAsFixed(2),  // Calculate total for project, 2 decimal places
      // '${calculatePercentageWorked1(selectedProjectName).toStringAsFixed(2)}%'
      //  calculateTotalHours1(selectedProjectName).round().toString(), // Round total hours
      // '${calculatePercentageWorked1(selectedProjectName).round()}%' // Round percentage
      // Total hours and percentage will be calculated later based on rounded values
      '0',
      // Placeholder for Total Hours
      '0%'
      // Placeholder for Percentage


    ];
    allRows.add(projectData); // Add project data to allRows

    // Out-of-office Rows
    final outOfOfficeCategories = [
      'Annual leave',
      'Holiday',
      'Paternity',
      'Maternity'
    ];
    final outOfOfficeData = outOfOfficeCategories.map((category) {
      final rowData = [
        category,
        ...daysInRange.map((date) {
          return _getDurationForDate3(date, selectedProjectName, category)
              .round()
              .toString(); // No rounding here
        }).toList(),
        // calculateCategoryHours(category).toStringAsFixed(2), // Calculate total for category, 2 decimal places
        // '${calculateCategoryPercentage(category).toStringAsFixed(1)}%'
        // calculateCategoryHours(category).round().toString(),  // Round category hours
        // '${calculateCategoryPercentage(category).round()}%' // Round percentage
        '0',
        // Placeholder for Total Hours
        '0%'
        // Placeholder for Percentage
      ];
      allRows.add(rowData); // Add each category row to allRows
      return rowData;
    }).toList();

    // Now calculate totals AFTER rounding for ALL rows (including project data)
    for (List<String> row in allRows) {
      double rowTotal = 0;
      for (int i = 1; i <=
          daysInRange.length; i++) { // Sum the rounded daily hours
        rowTotal += double.tryParse(row[i]) ?? 0;
      }

      row[daysInRange.length + 1] =
          rowTotal.round().toString(); // Rounded total hours

      int workingDays = daysInRange
          .where((date) => !isWeekend(date))
          .length;
      double percentage = (workingDays * 8) != 0 ? (rowTotal /
          (workingDays * 8)) * 100 : 0;
      row[daysInRange.length + 2] =
          '${percentage.round()}%'; // Rounded percentage
    }


    // Total Row Calculation (rounding to whole numbers)
    List<String> totalRow = [
      'Total',
      ...List.generate(daysInRange.length, (index) => '0'),
      '0',
      '0%'
    ];
    for (int i = 1; i <= daysInRange.length; i++) { // Iterate over day columns
      double dayTotal = 0; // Use double to accumulate, round later
      for (List<String> row in allRows) {
        dayTotal += double.tryParse(row[i]) ?? 0.0;
      }
      totalRow[i] =
          dayTotal.round().toString(); // Round day total before storing
    }

    // Calculate grand total and percentage (using rounded day totals)
    int grandTotalHours = 0;
    for (int i = 1; i <= daysInRange.length; i++) {
      grandTotalHours += int.parse(totalRow[i]);
    }
    totalRow[daysInRange.length + 1] =
        grandTotalHours.toString(); // Grand total

    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double grandPercentage = (workingDays * 8) > 0 ? (grandTotalHours /
        (workingDays * 8)) * 100 : 0;
    totalRow[daysInRange.length + 2] =
        '${grandPercentage.round()}%'; // Round percentage


    // Build the table
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FixedColumnWidth(250),
        for (int i = 1; i <= daysInRange.length; i++) i: const pw
            .FixedColumnWidth(80),
        // Fixed width for date columns
        daysInRange.length + 1: const pw.FixedColumnWidth(200),
        // Fixed width for "Total Hours"
        daysInRange.length + 2: const pw.FixedColumnWidth(200),
        // Fixed width for "Percentage"
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: tableHeaders
              .map((header) =>
              pw.Center(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(1.0),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ))
              .toList(),
        ),
        // // Project data row
        // pw.TableRow(
        //   children: projectData
        //       .map((data) => pw.Center(
        //     child: pw.Padding(
        //       padding: const pw.EdgeInsets.all(1.0),
        //       child: pw.Text(data),
        //     ),
        //   ))
        //       .toList(),
        // ),
        // // Out-of-office rows
        // ...outOfOfficeData.map(
        //       (rowData) => pw.TableRow(
        //     children: rowData
        //         .map((data) => pw.Center(
        //       child: pw.Padding(
        //         padding: const pw.EdgeInsets.all(1.0),
        //         child: pw.Text(data),
        //       ),
        //     ))
        //         .toList(),
        //   ),
        // ),

        // Total Row

        // // Project data row
        // pw.TableRow(
        //   children: _buildRowChildrenWithWeekendColor(projectData),
        // ),
        //
        // // Out-of-office rows
        // ...outOfOfficeData.map(
        //       (rowData) => pw.TableRow(
        //       children: _buildRowChildrenWithWeekendColor(rowData) //use method to create the cells for the row
        //   ),
        // ),


        // Combined loop for project and out-of-office rows, including Total row:
        ...allRows.map((rowData) {
          return pw.TableRow(
            children: rowData
                .asMap()
                .entries
                .map((entry) { // Use asMap().entries to get index
              final i = entry.key;
              final data = entry.value;
              final isWeekendColumn = i > 0 && i <= daysInRange.length &&
                  isWeekend(daysInRange[i - 1]);

              return pw.Container(
                color: isWeekendColumn ? PdfColors.grey900 : null,
                // Grey for weekend cells
                padding: const pw.EdgeInsets.all(1.0),
                alignment: pw.Alignment.center,
                // Center the text
                child: pw.Text(data),
              );
            }).toList(),
          );
        }).toList(),


        // Total Row (updated to use rounded values)
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: totalRow.map((data) => pw.Center(child: pw.Padding(
              padding: const pw.EdgeInsets.all(1.0),
              child: pw.Text(data,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))))
              .toList(),
        ),
      ],
    );
  }


  Future<Uint8List?> networkImageToByte(String imageUrl) async {
    try {
      final response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }


  Future<List<pw.Widget>> _buildSignatureColumns(
      Map<String, String> supervisorData) async {
    // Ensure all keys are safely retrieved and provide default values if missing
    final staffSig = (supervisorData['staffSignature'] != null &&
        supervisorData['staffSignature']!.isNotEmpty)
        ? await networkImageToByte(supervisorData['staffSignature']!)
        : await networkImageToByte(staffSignatureLink!);


    final coordSig = (supervisorData['projectCoordinatorSignature'] != null &&
        supervisorData['projectCoordinatorSignature']!.isNotEmpty)
        ? await networkImageToByte(
        supervisorData['projectCoordinatorSignature']!)
        : null;

    final caritasSig = (supervisorData['caritasSupervisorSignature'] != null &&
        supervisorData['caritasSupervisorSignature']!.isNotEmpty)
        ? await networkImageToByte(
        supervisorData['caritasSupervisorSignature']!)
        : null;

    // Fetch names with fallbacks for missing values
    final staffName = '${selectedBioFirstName?.toUpperCase() ??
        'UNKNOWN'} ${selectedBioLastName?.toUpperCase() ?? ''}'.trim();
    //final staffName = supervisorData['staffName']?.toUpperCase()  ?? 'UNKNOWN';
    final projectCoordinatorName = supervisorData['projectCoordinatorName']
        ?.toUpperCase() ?? 'UNKNOWN';
    final caritasSupervisorName = supervisorData['caritasSupervisorName']
        ?.toUpperCase() ?? 'UNKNOWN';

    final staffSignatureDate = supervisorData['staffSignatureDate'] ??
        formattedDate;
    final facilitySupervisorSignatureDate = supervisorData['facilitySupervisorSignatureDate'] ??
        'UNKNOWN';
    final caritasSupervisorSignatureDate = supervisorData['caritasSupervisorSignatureDate'] ??
        'UNKNOWN';

    // Return the list of signature columns
    return [
      _buildSingleSignatureColumn(
          'Name of Staff', staffName, staffSig, staffSignatureDate),
      _buildSingleSignatureColumn(
          'Name of Project Coordinator', projectCoordinatorName, coordSig,
          facilitySupervisorSignatureDate),
      _buildSingleSignatureColumn(
          'Name of Caritas Supervisor', caritasSupervisorName, caritasSig,
          caritasSupervisorSignatureDate),
    ];
  }


  pw.Widget _buildSingleSignatureColumn(String title, String name,
      Uint8List? imageBytes, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text(name),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 100,
          width: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
          ),
          child: pw.Center(
            child: imageBytes != null
                ? pw.Image(pw.MemoryImage(imageBytes))
                : pw.Text("Signature"), // Placeholder if no image
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text("Date: $date"),
      ],
    );
  }


  pw.Widget _buildSignatureSection(pw.Context context,
      List<pw.Widget> signatureColumns) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Signature & Date',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: signatureColumns, // Use the pre-built signature columns

          ),
        ]
    );
  }

  String _getDurationForDate2(DateTime date, String? projectName,
      String category) {
    double totalHoursForDate = 0;
    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
            attendance.date!);
        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName && !attendance.offDay!) {
            double hours = attendance.noOfHours!;
            totalHoursForDate += hours > 8.0 ? 8.0 : hours; // Applying the cap
          } else if (attendance.offDay! &&
              attendance.durationWorked!.toLowerCase() ==
                  category.toLowerCase()) {
            double hours = attendance.noOfHours!;
            totalHoursForDate +=
            hours > 8.0 ? 8.0 : hours; // Cap for off-days too
          }
        }
      } catch (e) {
        print("Error parsing date or calculating hours: $e");
      }
    }
    return totalHoursForDate.toStringAsFixed(2);
  }

  double _getDurationForDate3(DateTime date, String? projectName,
      String category) {
    double totalHoursForDate = 0;
    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
            attendance.date!);
        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName && !attendance.offDay!) {
            double hours = attendance.noOfHours!;
            totalHoursForDate += hours > 8.0 ? 8.0 : hours; // Applying the cap
          } else if (attendance.offDay! &&
              attendance.durationWorked!.toLowerCase() ==
                  category.toLowerCase()) {
            double hours = attendance.noOfHours!;
            totalHoursForDate +=
            hours > 8.0 ? 8.0 : hours; // Cap for off-days too
          }
        }
      } catch (e) {
        print("Error parsing date or calculating hours: $e");
      }
    }
    return totalHoursForDate;
  }

  // Helper function to calculate capped hours for a single date
  double _getCappedHoursForDate(DateTime date, String? projectName,
      String category) {
    double totalHoursForDate = 0;
    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
            attendance.date!);
        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName && !attendance.offDay!) {
            totalHoursForDate +=
            attendance.noOfHours! > 8 ? 8 : attendance.noOfHours!;
          } else if (attendance.offDay! &&
              attendance.durationWorked!.toLowerCase() ==
                  category.toLowerCase()) {
            totalHoursForDate +=
            attendance.noOfHours! > 8 ? 8 : attendance.noOfHours!;
          }
        }
      } catch (e) {
        print("Error parsing date or calculating hours: $e");
      }
    }
    return totalHoursForDate;
  }


// Updated function to calculate total hours for a project (with capping)
  double calculateTotalHours1(String? projectName) {
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        totalHours += _getCappedHoursForDate(
            date, projectName, projectName!); // Use helper function
      }
    }
    return totalHours;
  }

// Updated function to calculate total hours for a category (with capping)
  double calculateCategoryHours1(String category) {
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        totalHours += _getCappedHoursForDate(
            date, selectedProjectName, category); // Use helper function
      }
    }
    return totalHours;
  }


  double calculateTotalHours2(String? projectName) {
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        totalHours +=
            double.parse(_getDurationForDate2(date, projectName, projectName!));
      }
    }
    return totalHours;
  }

  // double calculatePercentageWorked1(String? projectName) {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
  //   double totalHours = calculateTotalHours1(projectName);
  //   return (workingDays * 8) != 0 ? (totalHours / (workingDays * 8)) * 100 : 0;
  // }

  // Updated percentage calculation for a project (using capped hours)
  double calculatePercentageWorked1(String? projectName) {
    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double cappedTotalHours = calculateTotalHours1(
        projectName); // Use capped total hours
    return (workingDays * 8) > 0
        ? (cappedTotalHours / (workingDays * 8)) * 100
        : 0;
  }


  // String _getDurationForDate(DateTime date, String? projectName, String category) {
  //   double totalHoursForDate = 0;
  //   for (var attendance in attendanceData) {
  //     try {
  //       DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
  //       if (attendanceDate.year == date.year &&
  //           attendanceDate.month == date.month &&
  //           attendanceDate.day == date.day) {
  //         if (category == projectName && !attendance.offDay!) {
  //           totalHoursForDate += attendance.noOfHours! > 8 ? 8 : attendance.noOfHours!;
  //         } else if (attendance.offDay! && attendance.durationWorked!.toLowerCase() == category.toLowerCase()) {
  //           totalHoursForDate += attendance.noOfHours! > 8 ? 8 : attendance.noOfHours!;
  //         }
  //       }
  //     } catch (e) {
  //       print("Error parsing date or calculating hours: $e"); // More specific error message
  //     }
  //   }
  //   return totalHoursForDate.toStringAsFixed(2); //Removed "hrs", let PDF handle formatting
  // }

  //Modify calculateTotalHours to use the new capped _getDurationForDate
  // int calculateTotalHours() {
  //   int totalHours = 0;
  //   for (var date in daysInRange) {
  //     if (!isWeekend(date)) {
  //       totalHours += int.parse(_getDurationForDate(date, selectedProjectName, selectedProjectName!)); //Parsing to int since _getDurationForDate returns a string now
  //     }
  //   }
  //   return totalHours;
  // }

  // ----------------


  Future<void> _createAndExportExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Add header row
    sheet.getRangeByName('A1').setText('Project Name');
    for (int i = 0; i < daysInRange.length; i++) {
      sheet.getRangeByIndex(1, i + 2).setText(
          DateFormat('dd MMM').format(daysInRange[i]));
    }
    sheet.getRangeByName('A${daysInRange.length + 2}').setText('Total Hours');
    // Add data rows (similar to how you build the UI table)
    // Example:
    sheet.getRangeByName('A2').setText(selectedProjectName ?? '');


    for (var i = 0; i < daysInRange.length; i++) {
      bool weekend = isWeekend(daysInRange[i]);
      String hours = _getDurationForDate2(
          daysInRange[i], selectedProjectName, selectedProjectName!);

      sheet.getRangeByIndex(2, i + 2).setText(weekend ? '' : hours);
    }

    sheet.getRangeByName('A${daysInRange.length + 2}').setText(
        '${calculateTotalHours()}');


    // Save and launch the file
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/timesheet.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    // OpenFile.open(fileName);
  }


  // Future<void> _createAndExportPDF1() async {
  //   //Create a new PDF document
  //   final PdfDocument document = PdfDocument();
  //   //Add a new page and draw text
  //   document.pages.add().graphics.drawString(
  //       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12));
  //   //Save the document
  //   final List<int> bytes = await document.save();
  //   //Dispose the document
  //   document.dispose();
  //
  //
  //   final String path = (await getApplicationSupportDirectory()).path;
  //   final String fileName = '$path/timesheet.pdf';
  //   final File file = File(fileName);
  //   await file.writeAsBytes(bytes, flush: true);
  //   OpenFile.open(fileName);
  //
  // }

  // Future<void> _createAndExportPDF() async {
  //   final PdfDocument document = PdfDocument();
  //
  //   // Add a page and set it to landscape orientation
  //   final PdfPage page = document.pages.add();
  //   final PdfGraphics graphics = page.graphics;
  //
  //   // Rotate the content for landscape layout
  //   graphics.translateTransform(page.size.height, 0);
  //   graphics.rotateTransform(90);
  //
  //   final PdfGrid grid = PdfGrid();
  //
  //   // Define grid columns
  //   grid.columns.add(count: daysInRange.length + 2); // +2 for Project Name and Total Hours
  //
  //
  //   // Add header row without the month
  //   final PdfGridRow headerRow = grid.headers.add(1)[0];
  //   headerRow.cells[0].value = 'Project Name';
  //   for (int i = 0; i < daysInRange.length; i++) {
  //     headerRow.cells[i + 1].value = DateFormat('dd').format(daysInRange[i]); // Only day
  //   }
  //   headerRow.cells[daysInRange.length + 1].value = 'Total';
  //   headerRow.style.backgroundBrush = PdfBrushes.lightGray; // Optional: highlight header
  //
  //   // Populate data rows with rounded hours
  //   PdfGridRow projectRow = grid.rows.add();
  //   projectRow.cells[0].value = selectedProjectName;
  //   for (int i = 0; i < daysInRange.length; i++) {
  //     double duration = _getDurationForDate1(daysInRange[i], selectedProjectName, selectedProjectName!);
  //     projectRow.cells[i + 1].value = duration.round().toString(); // Rounded hours
  //   }
  //   projectRow.cells[daysInRange.length + 1].value = calculateTotalHours().round().toString(); // Rounded total
  //
  //   // Add out-of-office rows for categories
  //   for (final category in [
  //     'Absent', 'Annual leave', 'Holiday', 'Other Leaves', 'Security Crisis',
  //     'Sick leave', 'Remote working', 'Sit at home', 'Trainings', 'Travel'
  //   ]) {
  //     PdfGridRow row = grid.rows.add();
  //     row.cells[0].value = category;
  //     for (int i = 0; i < daysInRange.length; i++) {
  //       double duration = _getDurationForDate1(daysInRange[i], selectedProjectName, category);
  //       row.cells[i + 1].value = duration.round().toString(); // Now this works as duration is a double
  //     }
  //     double categoryHours = calculateCategoryHours(category).roundToDouble();
  //     row.cells[daysInRange.length + 1].value = categoryHours.toInt().toString(); // Ensure this is a double too
  //   }
  //
  //   // Add a row for the grand total
  //   PdfGridRow totalRow = grid.rows.add();
  //   totalRow.cells[0].value = "Total";
  //   totalRow.cells[daysInRange.length + 1].value = calculateGrandTotalHours().round().toString(); // Rounded grand total
  //
  //   // Set grid to fit the page width for landscape layout
  //   final double gridWidth = page.size.height - 0.02; // Use height as width after rotation
  //   final double gridHeight = page.size.width - 0.02; // Use width as height after rotation
  //   grid.style = PdfGridStyle(
  //     cellPadding: PdfPaddings(left: 2, top: 2, right: 2, bottom: 2),
  //     font: PdfStandardFont(PdfFontFamily.helvetica, 10),
  //   );
  //
  //   for (int i = 0; i < grid.columns.count; i++) {
  //     grid.columns[i].width = 30; // Or another fixed width
  //   }
  //   // Draw the grid within adjusted bounds
  //   grid.draw(page: page, bounds: Rect.fromLTWH(10, 0, gridHeight, gridWidth)); // Adjust bounds
  //
  //  // grid.draw(page: page, bounds: Rect.fromLTWH(0, 0, page.size.height, page.size.width));
  //
  //   // Save and open the PDF
  //   final List<int> bytes = await document.save();
  //   document.dispose();
  //   final String path = (await getApplicationSupportDirectory()).path;
  //   final String fileName = '$path/timesheet.pdf';
  //   final File file = File(fileName);
  //   await file.writeAsBytes(bytes, flush: true);
  //   OpenFile.open(fileName);
  // }

  // Example of how to calculate total content width (you'll need to adapt this)
  double totalContentWidth() {
    // Example: If each column has a width of 300 and you have 3 columns:
    int numberOfColumns = 300; // Replace with actual number of your columns
    double columnWidth = 3000; // Replace with actual your column width
    return numberOfColumns * columnWidth; // Example implementation

  }

// Calculate scrollable width

  double calculateScrollableWidth(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    if (box is RenderBox) {
      return box.size.width; // Use the RepaintBoundary's width directly since
      // we're manually scrolling with ScrollController.
    }
    return 0;
  }


  // Future<void> _createAndExportPDF() async {
  //   try {
  //     final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     final context = _globalKey.currentContext!;
  //
  //     // Get dimensions
  //     final totalWidth = context.size!.width; // Use context.size for visible width
  //     final totalHeight = boundary.size.height;
  //
  //     final pdf = pw.Document();
  //     List<ui.Image> images = [];
  //     double currentScrollOffset = 0;
  //
  //
  //     while (currentScrollOffset < calculateScrollableWidth(context)) { // corrected condition
  //       // Scroll
  //       await _scrollController.animateTo(
  //         currentScrollOffset,
  //         duration: Duration(milliseconds: 300),
  //         curve: Curves.linear,
  //       );
  //       await Future.delayed(Duration(milliseconds: 200)); // short delay
  //
  //       // Capture image
  //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //       images.add(image);
  //
  //       currentScrollOffset += context.size!.width;
  //     }
  //
  //     for (var image in images) {
  //       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //       final pngBytes = byteData!.buffer.asUint8List();
  //
  //       pdf.addPage(pw.Page(
  //           build: (pw.Context context) => pw.Center(child: pw.FittedBox(
  //             fit: pw.BoxFit.contain,
  //             child: pw.Image(pw.MemoryImage(pngBytes)),
  //           ))
  //       ));
  //     }
  //
  //     final output = await getExternalStorageDirectory();
  //     final file = File("${output?.path}/timesheet.pdf");
  //     await file.writeAsBytes(await pdf.save()); // Corrected line
  //     // Open the PDF file
  //     await OpenFilex.open(file.path);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('PDF saved to: ${file.path}')),
  //     );
  //
  //   } catch (e) {
  //     print("Error generating PDF: $e");
  //     // Handle error (e.g., show a dialog)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error generating PDF')),
  //     );
  //   }
  // }


  Future<void> _loadAttendanceData() async {
    attendanceData = await IsarService().getAllAttendance();
    setState(() {}); // Rebuild the UI after fetching data
  }


  // String _getDurationForDate(DateTime date, String? projectName, String category) {
  //   double totalHoursForDate = 0;
  //
  //   for (var attendance in attendanceData) {
  //     try {
  //       DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
  //
  //       if (attendanceDate.year == date.year &&
  //           attendanceDate.month == date.month &&
  //           attendanceDate.day == date.day) {
  //         if (category == projectName) {
  //           if (!attendance.offDay!) {
  //             double hours = attendance.noOfHours!;
  //             totalHoursForDate += hours > 8.0 ? 8.0 : hours; // Cap at 8 hours
  //
  //           }
  //         } else {
  //           if (attendance.offDay! &&
  //               attendance.durationWorked?.toLowerCase() == category.toLowerCase()) {
  //             double hours = attendance.noOfHours!;
  //             totalHoursForDate += hours > 8.0 ? 8.0 : hours; // Cap at 8 hours if needed for off-day categories
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       print("Error parsing date: $e");
  //     }
  //   }
  //   return "${totalHoursForDate.toStringAsFixed(2)} hrs";
  // }

  double _getDurationForDate1(DateTime date, String? projectName,
      String category) {
    double totalHoursForDate = 0;

    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
            attendance.date!);

        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName) {
            if (!attendance.offDay!) {
              totalHoursForDate += attendance.noOfHours!;
            }
          } else {
            if (attendance.offDay! &&
                attendance.durationWorked?.toLowerCase() ==
                    category.toLowerCase()) {
              totalHoursForDate += attendance.noOfHours!;
            }
          }
        }
      } catch (e) {
        print("Error parsing date: $e");
      }
    }

    // Return the total hours as a double
    return totalHoursForDate; // Change here
  }


  Future<void> _loadSupervisorNames(String department, String state) async {
    supervisorNames =
    await IsarService().getSupervisorEmailFromIsar(department, state);
    if (supervisorNames.isNotEmpty) {
      setState(() {}); // Trigger a rebuild to update the UI
    } else {
      // Handle the case where no supervisors are found.
      // Maybe show a message or use a default value.
      print("No supervisors found for department: $department, state: $state");
    }
  }


  Future<void> _loadProjectNames() async {
    projectNames = await IsarService().getProjectFromIsar();
    if (projectNames.isNotEmpty) {
      setState(() {
        selectedProjectName =
        projectNames[0]; // Select the first project initially
      });
    }
  }

  Future<void> _loadBioData() async {
    bioData = await IsarService().getBioData();
    if (bioData !=
        null) { // Check if bioData is not null before accessing its properties
      setState(() {
        selectedBioFirstName =
            bioData!.firstName; // Use the null-aware operator (!)
        selectedBioLastName =
            bioData!.lastName; // Use the null-aware operator (!)
        selectedBioDepartment =
            bioData!.department; // Initialize selectedBioDepartment
        selectedBioState = bioData!.state;
        selectedBioDesignation = bioData!.designation;
        selectedBioLocation = bioData!.location;
        selectedBioStaffCategory = bioData!.staffCategory;
        selectedBioEmail = bioData!.emailAddress;
        selectedBioPhone = bioData!.mobile;
        staffSignatureLink = bioData!.signatureLink;
        selectedFirebaseId =
            bioData!.firebaseAuthId; // Initialize selectedBioState
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
  }


  getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2090),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    } else {
      print("It's null or something is wrong");
    }
  }


  void initializeDateRange(int month, int year) {
    DateTime selectedMonthDate = DateTime(year, month + 1, 1);
    startDate = DateTime(selectedMonthDate.year, selectedMonthDate.month - 1,
        20); //Start from the 19th of previous month
    endDate = DateTime(selectedMonthDate.year, selectedMonthDate.month,
        19); //End on the 20th of current month


    daysInRange = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      daysInRange.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  // // Dummy data for supervisors
  // List<String> facilitySupervisors = ['Supervisor A', 'Supervisor B', 'Supervisor C'];
  // List<String> caritasSupervisors = ['Caritas A', 'Caritas B', 'Caritas C'];

  bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  int calculateTotalHours() {
    double totalHours = 0;

    for (var date in daysInRange) {
      if (!isWeekend(date)) { // Skip weekends
        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
                attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day &&
                !attendance.offDay!) {
              totalHours += attendance.noOfHours!;
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
      }
    }
    return totalHours.toInt();
  }

  int calculateGrandTotalHours() {
    double totalGrandHours = 0;

    for (var date in daysInRange) {
      if (!isWeekend(date)) { // Skip weekends
        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
                attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day) {
              totalGrandHours += attendance.noOfHours!;
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
      }
    }
    return totalGrandHours.toInt();
  }

  double calculateGrandTotalHours1() {
    double projectTotal = calculateTotalHours1(selectedProjectName);

    double categoriesTotal = [
      'Annual leave',
      'Holiday',
      'Paternity',
      'Maternity'
    ].fold<double>(0.0, (sum, category) {
      return sum + calculateCategoryHours1(category);
    });

    return projectTotal + categoriesTotal;
  }

  // double calculatePercentageWorked() {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
  //   double totalExpectedHours = 0; // To store the total possible working hours
  //
  //   if (workingDays == 0) {
  //     return 0; // Avoid division by zero
  //   }
  //
  //
  //   for (var date in daysInRange) {
  //     if (!isWeekend(date)) {
  //       for (var attendance in attendanceData) {
  //         try {
  //           DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
  //           if (attendanceDate.year == date.year &&
  //               attendanceDate.month == date.month &&
  //               attendanceDate.day == date.day &&
  //               !attendance.offDay!) { // Include all entries for the day, offDay or not.
  //             totalExpectedHours += attendance.noOfHours!; // Sum the expected hours, even if 0
  //             break; // Go to next date once expected hours for this date found
  //           }
  //         } catch (e) {
  //           print("Error parsing date: $e");
  //         }
  //       }
  //     }
  //   }
  //
  //
  //   int totalWorkedHours = calculateTotalHours(); // Calculate worked hours (excluding weekends and off-days)
  //
  //
  //   if (totalExpectedHours == 0) {
  //     return 0; // Avoid division by zero if no expected hours are found
  //   }
  //
  //   return (totalWorkedHours / totalExpectedHours) * 100;
  // }

  double calculatePercentageWorked() {
    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length; // Correctly calculates working days in the selected month's date range.

    int totalHours = calculateTotalHours();

    if (workingDays * 8 == 0) {
      return 0;
    }

    return (totalHours / (workingDays * 8)) * 100;
  }

  // double calculateGrandPercentageWorked() {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.
  //
  //   int totalHours = calculateGrandTotalHours();
  //
  //   if (workingDays * 8 == 0) {
  //     return 0;
  //   }
  //
  //   return (totalHours / (workingDays * 8)) * 100;
  // }

// Corrected grand percentage calculation (using capped grand total)
  double calculateGrandPercentageWorked() {
    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double cappedGrandTotalHours = calculateGrandTotalHours1();
    return (workingDays * 8) > 0 ? (cappedGrandTotalHours / (workingDays * 8)) *
        100 : 0; // Correct denominator

  }


  Future<void> getSupervisor(String selectedFirebaseId, int selectedYear,
      int selectedMonth) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("Staff")
          .doc(selectedFirebaseId)
          .collection("TimeSheets")
          .doc(DateFormat('MMMM_yyyy').format(
          DateTime(selectedYear, selectedMonth + 1)))
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final facilitySupervisor2 = data['facilitySupervisor'];
        final caritasSupervisor2 = data['caritasSupervisor'];
        setState(() {
          facilitySupervisor = facilitySupervisor2;
          caritasSupervisor = caritasSupervisor2;
        });
        //return facilitySupervisor ?? ""; // Return empty string if null
      } else {
        print("No timesheet data found.");
      }
    } catch (e) {
      print("Error fetching facility supervisor: $e");
      //return "Error fetching data."; // Or handle the error as needed
    }
  }

  // Function to create the Firestore stream
  Stream<DocumentSnapshot> getSupervisorStream(String selectedFirebaseId,
      int selectedYear, int selectedMonth) {
    return FirebaseFirestore.instance
        .collection("Staff")
        .doc(selectedFirebaseId)
        .collection("TimeSheets")
        .doc(DateFormat('MMMM_yyyy').format(
        DateTime(selectedYear, selectedMonth + 1)))
        .snapshots();
  }


  // Calculate total hours for a specific category
  double calculateCategoryHours(String category) {
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
                attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day &&
                attendance.offDay! && //Check for offDay for these categories
                attendance.durationWorked?.toLowerCase() ==
                    category.toLowerCase()) {
              totalHours += attendance.noOfHours!;
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
      }
    }
    return totalHours;
  }


// Calculate percentage for a specific category
//   double calculateCategoryPercentage(String category) {
//
//     double categoryHours = calculateCategoryHours(category);
//
//     int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
//     double totalExpectedHours = 0;
//
//     if (workingDays == 0) {
//       return 0; // Avoid division by zero
//     }
//
//     for (var date in daysInRange) {
//       if (!isWeekend(date)) {
//         for (var attendance in attendanceData) {
//           try {
//             DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
//             if (attendanceDate.year == date.year &&
//                 attendanceDate.month == date.month &&
//                 attendanceDate.day == date.day) {
//               totalExpectedHours += attendance.noOfHours!;
//               break; // Ensure to only count expected hours for the specific day once
//             }
//           } catch (e) {
//             print("Error parsing date: $e");
//           }
//         }
//       }
//     }
//
//     if (totalExpectedHours == 0) {
//       return 0; // Avoid division by zero if no expected hours found
//     }
//
//     return (categoryHours / totalExpectedHours) * 100;
//
//
//   }

  // double calculateCategoryPercentage(String category) {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.
  //
  //   double totalHours = calculateCategoryHours(category);
  //
  //   if (workingDays * 8 == 0) {
  //     return 0;
  //   }
  //
  //   return (totalHours / (workingDays * 8)) * 100;
  // }

  // Updated percentage calculation for a category (using capped hours)
  double calculateCategoryPercentage(String category) {
    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double cappedCategoryHours = calculateCategoryHours(
        category); // Use capped category hours
    return (workingDays * 8) > 0 ? (cappedCategoryHours / (workingDays * 8)) *
        100 : 0;
  }

  // double calculatePercentageWorked() {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.
  //
  //   int totalHours = calculateTotalHours();
  //
  //   if (workingDays * 8 == 0) {
  //     return 0;
  //   }
  //
  //   return (totalHours / (workingDays * 8)) * 100;
  // }

  // int calculateTotalHours() {
  //   // Mock calculation, replace with actual logic to query Isar database for total hours
  //   return daysInRange.where((date) => !isWeekend(date)).length * 8; // Example: 8 hours per day
  // }
  //
  // double calculatePercentageWorked() {
  //   int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
  //   return (calculateTotalHours() / (workingDays * 8)) * 100; // Assuming 8-hour workday
  // }

  @override
  Widget build(BuildContext context) {
    int totalHours = calculateTotalHours();
    double percentageWorked = calculatePercentageWorked();
    int totalGrandHours = calculateGrandTotalHours();
    double grandPercentageWorked = calculateGrandPercentageWorked();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheet'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: _createAndExportPDF,
          ),
          const Icon(Icons.picture_as_pdf),
          const SizedBox(width: 15)
          // IconButton(
          //   icon: const Icon(Icons.save_alt), // Use a suitable icon for Excel
          //   onPressed: _createAndExportExcel,
          // ),
        ],
      ),
      drawer:
      // role == "User"
      //     ?
      drawer(this.context, IsarService()),
      // : drawer2(this.context, IsarService()),
      body: _isLoading // Conditional rendering based on loading state
          ? const Center(
          child: CircularProgressIndicator()) // Show loading indicator
          :
      SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Image(
                      image: const AssetImage("./assets/image/ccfn_logo.png"),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.15 : 0.10),
                      //height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.30),
                    ),
                    Text('Name: $selectedBioFirstName $selectedBioLastName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Department: $selectedBioDepartment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Designation: $selectedBioDesignation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Location: $selectedBioLocation', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * (MediaQuery
                        .of(context)
                        .size
                        .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('State: $selectedBioState', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * (MediaQuery
                        .of(context)
                        .size
                        .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 10),
                    // Add some spacing
                  ]
              ),),


            // Month Picker Dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Select Month:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      DateTime monthDate = DateTime(2024, index + 1, 1);
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(DateFormat.MMMM().format(monthDate)),
                      );
                    }),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedMonth = newValue;
                          initializeDateRange(selectedMonth, selectedYear);
                        });
                      }
                    },
                  ),


                  const SizedBox(width: 10),
                  const Text(
                    'Select Year:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),


                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(10, (index) {
                      int year = DateTime
                          .now()
                          .year - index;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedYear = newValue;
                          initializeDateRange(selectedMonth, selectedYear);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Attendance Sheet in a Container with 50% screen height
            Container(
              //height: MediaQuery.of(context).size.height * 0.5, // Adjusted height for better visibility
                child: RepaintBoundary(
                    key: _globalKey,
                    child: Column(
                        children: [
                          SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child:
                            // SizedBox( // <-- Use SizedBox to constrain the width
                            //     width: totalContentWidth(), // Calculate this dynamically
                            //     child:
                            Column(
                              children: [
                                Column(
                                  children: [
                                    // Header Row
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          // Set a width for the "Project Name" header
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.blue.shade100,
                                          child: const Text(
                                            'Project Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        ...daysInRange.map((date) {
                                          return Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: isWeekend(date) ? Colors.grey
                                                .shade300 : Colors.blue
                                                .shade100,
                                            child: Text(
                                              DateFormat('dd MMM').format(date),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.blue.shade100,
                                          child: const Text(
                                            'Total Hours',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.blue.shade100,
                                          child: const Text(
                                            'Percentage',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          // Keep the fixed width if you need it
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: projectNames.isEmpty
                                              ? const Text('No projects found')
                                              : DropdownButton<String>(
                                            value: selectedProjectName,
                                            isExpanded: true,
                                            // This will expand the dropdown to the Container's width
                                            items: projectNames.map((
                                                projectName) {
                                              return DropdownMenuItem<String>(
                                                value: projectName,
                                                child: FittedBox( // Use FittedBox to wrap the Text
                                                  fit: BoxFit.scaleDown,
                                                  // Scales down text to fit
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  // Align text to the left
                                                  child: Text(projectName ??
                                                      'No Project Name'),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedProjectName = newValue;
                                              });
                                            },
                                            hint: const Text('Select Project'),
                                          ),
                                        ),
                                        ...daysInRange.map((date) {
                                          bool weekend = isWeekend(date);
                                          String hours = _getDurationForDate2(
                                              date, selectedProjectName,
                                              selectedProjectName!);
                                          return Container(
                                            width: 50,
                                            // Set a fixed width for each day
                                            decoration: BoxDecoration(
                                              color: weekend ? Colors.grey
                                                  .shade300 : Colors.white,
                                              border: Border.all(
                                                  color: Colors.black12),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                weekend
                                                    ? const SizedBox
                                                    .shrink() // No hours on weekends
                                                    : Text(
                                                  hours,
                                                  // Placeholder, replace with Isar data
                                                  style: const TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: Text(
                                            //'$totalHours hrs',
                                            "${calculateTotalHours1(
                                                selectedProjectName)
                                                .round()} hrs",

                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: Text(
                                            // '${percentageWorked.toStringAsFixed(2)}%',
                                            '${calculatePercentageWorked1(
                                                selectedProjectName).round()}%',
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    // "Out-of-office" Header Row
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: const Text(
                                            'Out-of-office',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        ...List.generate(
                                            daysInRange.length, (index) {
                                          return Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: const Text(
                                              '', // Placeholder for out-of-office data, can be replaced later
                                            ),
                                          );
                                        }).toList(),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: const Text(
                                            '', // Placeholder for total hours
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: const Text(
                                            '', // Placeholder for percentage
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Rows for out-of-office categories
                                    ...[
                                      'Annual leave',
                                      'Holiday',
                                      'Paternity',
                                      'Maternity'
                                    ].map((category) {
                                      double outOfOfficeHours = calculateCategoryHours(
                                          category);
                                      double outOfOfficePercentage = calculateCategoryPercentage(
                                          category);
                                      return Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Text(
                                              category,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ...daysInRange.map((date) {
                                            bool weekend = isWeekend(date);
                                            String offDayHours = _getDurationForDate2(
                                                date, selectedProjectName,
                                                category);


                                            return Container(
                                              width: 50,
                                              // Set a fixed width for each day
                                              decoration: BoxDecoration(
                                                color: weekend ? Colors.grey
                                                    .shade300 : Colors.white,
                                                border: Border.all(
                                                    color: Colors.black12),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  weekend
                                                      ? const SizedBox
                                                      .shrink() // No hours on weekends
                                                      : Text(
                                                    offDayHours,
                                                    // Placeholder, replace with Isar data
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .blueAccent),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          Container(
                                            width: 100,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Text(
                                              //'${outOfOfficeHours.toStringAsFixed(1)} hrs',
                                              "${calculateCategoryHours1(category)
                                                  .round()} hrs",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Text(
                                              //'${outOfOfficePercentage.toStringAsFixed(1)}%',
                                              '${calculateCategoryPercentage(
                                                  category).round()}%',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    // Attendance Rows
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: const Text(
                                            'Total',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        ...List.generate(
                                            daysInRange.length, (index) {
                                          return Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: const Text(
                                              '', // Placeholder for out-of-office data, can be replaced later
                                            ),
                                          );
                                        }).toList(),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: Text(
                                            // '$totalGrandHours hrs',
                                            "${calculateGrandTotalHours1()
                                                .toStringAsFixed(0)} hrs",
                                            // Or .round().toString() if grand total should also be rounded.
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: Text(
                                            //'${grandPercentageWorked.toStringAsFixed(2)}%',
                                            '${calculateGrandPercentageWorked()
                                                .round()}%',
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),


                              ],
                            ),
                            //),
                          ),
                          SizedBox(height: MediaQuery
                              .of(context)
                              .size
                              .width * (MediaQuery
                              .of(context)
                              .size
                              .shortestSide < 600 ? 0.07 : 0.05)),
                          //Signature and Detials

                          const Divider(),
                          Text('Signature & Date', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * (MediaQuery
                              .of(context)
                              .size
                              .shortestSide < 600 ? 0.050 : 0.030),)),
                          const Divider(),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.02 : 0.02),),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.25 : 0.25),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        // Vertically center the content
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Text('Name of Staff',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * (MediaQuery
                                                    .of(context)
                                                    .size
                                                    .shortestSide < 600
                                                    ? 0.040
                                                    : 0.020),)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),
                                          Text(
                                            '${selectedBioFirstName.toString()
                                                .toUpperCase()} ${selectedBioLastName
                                                .toString().toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .shortestSide < 600
                                                  ? 0.035
                                                  : 0.015),
                                              // fontWeight: FontWeight.bold,
                                              fontFamily: "NexaLight",
                                            ),
                                          ),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.13
                                              : 0.10)),
                                          // Adjust path and size accordingly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    // Signature of Staff
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.35 : 0.35),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //  color: Colors.grey.shade200,
                                      child: Column(
                                        children: [
                                          Text('Signature', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery
                                                .of(context)
                                                .size
                                                .width * (MediaQuery
                                                .of(context)
                                                .size
                                                .shortestSide < 600
                                                ? 0.040
                                                : 0.020),)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.01
                                              : 0.009)),


                                          // StreamBuilder<DocumentSnapshot>(
                                          //   // Stream the supervisor signature
                                          //   stream: FirebaseFirestore.instance
                                          //       .collection("Staff")
                                          //       .doc(selectedFirebaseId) // Replace with how you get the staff document ID
                                          //   .collection("TimeSheets")
                                          //   .doc(DateFormat('MMMM_yyyy').format(DateTime(selectedYear, selectedMonth + 1))) // Replace monthYear with the timesheet document ID
                                          //       .snapshots(),
                                          //   builder: (context, snapshot) {
                                          //     if (snapshot.hasData && snapshot.data!.exists) {
                                          //       final data = snapshot.data!.data() as Map<String, dynamic>;
                                          //       final signatureLink = data['staffSignature']; // Assuming this stores the image URL
                                          //       //final caritasSupervisorDate = data['date']; // Assuming you store the date
                                          //
                                          //       if (signatureLink != null) {
                                          //         // setState((){
                                          //         //   _signatureLink = signatureLink;
                                          //         // });
                                          //         // caritasSupervisorSignature is a URL/path to the image
                                          //         return Container(
                                          //           margin: const EdgeInsets.only(
                                          //             top: 20,
                                          //             bottom: 24,
                                          //           ),
                                          //           height: MediaQuery.of(context).size.width *
                                          //               (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          //           width: MediaQuery.of(context).size.width *
                                          //               (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          //           alignment: Alignment.center,
                                          //           decoration: BoxDecoration(
                                          //             borderRadius: BorderRadius.circular(20),
                                          //             //color: Colors.grey.shade300,
                                          //           ),
                                          //           child: Image.network(signatureLink!),
                                          //         );
                                          //       } else {
                                          //         return Text("Awaiting Facility Supervisor Signature");
                                          //
                                          //       }
                                          //     } else {
                                          //       return Text("No timesheet data found.");
                                          //     }
                                          //   },
                                          // ),

                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final staffSignature = data['staffSignature']; // Assuming this stores the image URL
                                                //final facilitySupervisorSignatureStatus = data['staffSignature']; // Assuming you store the date

                                                if (staffSignature != null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .only(
                                                      top: 20,
                                                      bottom: 24,
                                                    ),
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        (MediaQuery
                                                            .of(context)
                                                            .size
                                                            .shortestSide < 600
                                                            ? 0.30
                                                            : 0.15),
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        (MediaQuery
                                                            .of(context)
                                                            .size
                                                            .shortestSide < 600
                                                            ? 0.30
                                                            : 0.30),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                      //color: Colors.grey.shade300,
                                                    ),
                                                    child: Image.network(
                                                        staffSignature!),
                                                  );
                                                }
                                                else
                                                if (staffSignature == null &&
                                                    staffSignatureLink ==
                                                        null) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _pickImage();
                                                    },

                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                        top: 20,
                                                        bottom: 24,
                                                      ),
                                                      height: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          (MediaQuery
                                                              .of(context)
                                                              .size
                                                              .shortestSide <
                                                              600
                                                              ? 0.30
                                                              : 0.15),
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          (MediaQuery
                                                              .of(context)
                                                              .size
                                                              .shortestSide <
                                                              600
                                                              ? 0.30
                                                              : 0.30),
                                                      alignment: Alignment
                                                          .center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                        //color: Colors.grey.shade300,
                                                      ),
                                                      child: RefreshableWidget<
                                                          List<Uint8List>?>(
                                                        refreshCall: () async {
                                                          return await _readImagesFromDatabase();
                                                        },
                                                        refreshRate: const Duration(
                                                            seconds: 1),
                                                        errorWidget: Icon(
                                                          Icons.upload_file,
                                                          size: 80,
                                                          color: Colors.grey
                                                              .shade300,
                                                        ),
                                                        loadingWidget: Icon(
                                                          Icons.upload_file,
                                                          size: 80,
                                                          color: Colors.grey
                                                              .shade300,
                                                        ),
                                                        builder: (context,
                                                            value) {
                                                          if (value != null &&
                                                              value
                                                                  .isNotEmpty) {
                                                            return ListView
                                                                .builder(
                                                              itemCount: value
                                                                  .length,
                                                              itemBuilder: (
                                                                  context,
                                                                  index) =>
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                      top: 20,
                                                                      bottom: 24,
                                                                    ),
                                                                    height: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        (MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .shortestSide <
                                                                            600
                                                                            ? 0.30
                                                                            : 0.15),
                                                                    width: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        (MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .shortestSide <
                                                                            600
                                                                            ? 0.30
                                                                            : 0.30),
                                                                    alignment: Alignment
                                                                        .center,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          20),
                                                                      //color: Colors.grey.shade300,
                                                                    ),
                                                                    child: Image
                                                                        .memory(
                                                                        value
                                                                            .first),
                                                                  ),


                                                            );
                                                          } else {
                                                            return Column(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .upload_file,
                                                                  size: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width *
                                                                      (MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .shortestSide <
                                                                          600
                                                                          ? 0.075
                                                                          : 0.05),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                const Text(
                                                                  "Click to Upload Signature Image Here",
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                } else
                                                if (staffSignature == null &&
                                                    staffSignatureLink !=
                                                        null) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 20,
                                                          bottom: 24,
                                                        ),
                                                        height: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.15),
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.30),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(20),
                                                          //color: Colors.grey.shade300,
                                                        ),
                                                        child: Image.network(
                                                            staffSignatureLink!),
                                                      ),


                                                    ],
                                                  );
                                                } else
                                                if (staffSignature != null &&
                                                    staffSignatureLink !=
                                                        null) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 20,
                                                          bottom: 24,
                                                        ),
                                                        height: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.15),
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.30),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(20),
                                                          //color: Colors.grey.shade300,
                                                        ),
                                                        child: Image.network(
                                                            staffSignatureLink!),
                                                      ),

                                                    ],
                                                  );
                                                }
                                                else {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 20,
                                                          bottom: 24,
                                                        ),
                                                        height: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.15),
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.30),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(20),
                                                          //color: Colors.grey.shade300,
                                                        ),
                                                        child: Image.network(
                                                            staffSignatureLink!),
                                                      ),


                                                    ],
                                                  );
                                                }
                                              }
                                              else {
                                                if (staffSignatureLink ==
                                                    null) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _pickImage();
                                                    },

                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                        top: 20,
                                                        bottom: 24,
                                                      ),
                                                      height: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          (MediaQuery
                                                              .of(context)
                                                              .size
                                                              .shortestSide <
                                                              600
                                                              ? 0.30
                                                              : 0.15),
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          (MediaQuery
                                                              .of(context)
                                                              .size
                                                              .shortestSide <
                                                              600
                                                              ? 0.30
                                                              : 0.30),
                                                      alignment: Alignment
                                                          .center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(20),
                                                        //color: Colors.grey.shade300,
                                                      ),
                                                      child: RefreshableWidget<
                                                          List<Uint8List>?>(
                                                        refreshCall: () async {
                                                          return await _readImagesFromDatabase();
                                                        },
                                                        refreshRate: const Duration(
                                                            seconds: 1),
                                                        errorWidget: Icon(
                                                          Icons.upload_file,
                                                          size: 80,
                                                          color: Colors.grey
                                                              .shade300,
                                                        ),
                                                        loadingWidget: Icon(
                                                          Icons.upload_file,
                                                          size: 80,
                                                          color: Colors.grey
                                                              .shade300,
                                                        ),
                                                        builder: (context,
                                                            value) {
                                                          if (value != null &&
                                                              value
                                                                  .isNotEmpty) {
                                                            return ListView
                                                                .builder(
                                                              itemCount: value
                                                                  .length,
                                                              itemBuilder: (
                                                                  context,
                                                                  index) =>
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                      top: 20,
                                                                      bottom: 24,
                                                                    ),
                                                                    height: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        (MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .shortestSide <
                                                                            600
                                                                            ? 0.30
                                                                            : 0.15),
                                                                    width: MediaQuery
                                                                        .of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        (MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .shortestSide <
                                                                            600
                                                                            ? 0.30
                                                                            : 0.30),
                                                                    alignment: Alignment
                                                                        .center,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          20),
                                                                      //color: Colors.grey.shade300,
                                                                    ),
                                                                    child: Image
                                                                        .memory(
                                                                        value
                                                                            .first),
                                                                  ),


                                                            );
                                                          } else {
                                                            return Column(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .upload_file,
                                                                  size: MediaQuery
                                                                      .of(
                                                                      context)
                                                                      .size
                                                                      .width *
                                                                      (MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .shortestSide <
                                                                          600
                                                                          ? 0.075
                                                                          : 0.05),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                const Text(
                                                                  "Click to Upload Signature Image Here",
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                  ),
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                } else if (staffSignatureLink !=
                                                    null) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 20,
                                                          bottom: 24,
                                                        ),
                                                        height: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.15),
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .shortestSide <
                                                                600
                                                                ? 0.30
                                                                : 0.30),
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(20),
                                                          //color: Colors.grey.shade300,
                                                        ),
                                                        child: Image.network(
                                                            staffSignatureLink!),
                                                      ),


                                                    ],
                                                  );
                                                }
                                              }
                                              return const Text(
                                                  "Loading Signature...");
                                            },
                                          ),

                                          // Adjust path and size accordingly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    // Date of Signature of Staff

                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.30 : 0.30),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Date', style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),

                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final staffSignatureDate = data['staffSignatureDate']; // Assuming this stores the image URL
                                                //  final caritasSupervisorDate = data['date']; // Assuming you store the date

                                                if (staffSignatureDate !=
                                                    null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return Column(
                                                    children: [
                                                      //Image.network(facilitySupervisorSignature!), // Load the image from the cloud URL
                                                      Text(staffSignatureDate
                                                          .toString()),
                                                    ],
                                                  );
                                                } else {
                                                  return Text(
                                                      formattedDate,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold));
                                                }
                                              } else {
                                                return Text(formattedDate,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold));
                                              }
                                            },
                                          ),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.13
                                              : 0.10)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.02 : 0.02),),


                                  ],
                                ),
                                SizedBox(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * (MediaQuery
                                    .of(context)
                                    .size
                                    .shortestSide < 600 ? 0.005 : 0.005)),
                                const Divider(),
                                //Second - Project Coordinator Section
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.02 : 0.02),),
                                    //Name of Project Cordinator
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.30
                                              : 0.25),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //  color: Colors.grey.shade200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          // Email of Project Cordinator
                                          Text(
                                            'Name of Facility Supervisor',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width *
                                                  (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .shortestSide < 600
                                                      ? 0.040
                                                      : 0.020),
                                            ),
                                          ),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),
                                          // facilitySupervisor!=null?
                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final facilitySupervisor = data['facilitySupervisor']; // Assuming this stores the image URL
                                                final caritasSupervisorDate = data['date']; // Assuming you store the date

                                                if (facilitySupervisor ==
                                                    null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return StreamBuilder<List<
                                                      Map<String, dynamic>>>(
                                                    stream: Stream.value(
                                                        facilitySupervisorsList),
                                                    builder: (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                            child: CircularProgressIndicator());
                                                      } else
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot
                                                                .error}');
                                                      } else {
                                                        // Extract the supervisors list or provide an empty list
                                                        List<Map<String,
                                                            dynamic>> supervisors = snapshot
                                                            .data ?? [];

                                                        // Map the data into dropdown items
                                                        List<DropdownMenuItem<
                                                            Map<String,
                                                                dynamic>>> dropdownItems =
                                                        supervisors.map((
                                                            supervisor) {
                                                          // Concatenate first name and last name
                                                          String fullName = "${supervisor['lastName']} ${supervisor['firstName']}";
                                                          return DropdownMenuItem<
                                                              Map<
                                                                  String,
                                                                  dynamic>>(
                                                            value: supervisor,
                                                            child: Text(
                                                                fullName),
                                                          );
                                                        }).toList();

                                                        return Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              // Ensures the dropdown fits the container
                                                              child: DropdownButton<
                                                                  Map<
                                                                      String,
                                                                      dynamic>>(
                                                                isExpanded: true,
                                                                // Allows the dropdown to fit the available width
                                                                value: _selectedFacilitySupervisor,
                                                                // Use the state variable here
                                                                items: dropdownItems,
                                                                onChanged: (Map<
                                                                    String,
                                                                    dynamic>? newValue) {
                                                                  if (newValue !=
                                                                      null) {
                                                                    setState(() {
                                                                      _selectedFacilitySupervisor =
                                                                          newValue;
                                                                      // Save the concatenated name and email address
                                                                      _selectedFacilitySupervisorFullName =
                                                                      "${newValue['lastName']} ${newValue['firstName']}";
                                                                      _selectedFacilitySupervisorEmail =
                                                                      newValue['emailAddress'];
                                                                      _selectedFacilitySupervisorSignatureLink =
                                                                      newValue['signatureLink'];
                                                                    });
                                                                    print(
                                                                        "Selected Supervisor: $_selectedFacilitySupervisorFullName");
                                                                    print(
                                                                        "Supervisor Email: $_selectedFacilitySupervisorEmail");
                                                                  }
                                                                },
                                                                hint: const Text(
                                                                    'Select Supervisor'),
                                                              ),
                                                            ),

                                                          ],
                                                        );
                                                      }
                                                    },
                                                  );
                                                } else {
                                                  return Text(
                                                      "$facilitySupervisor");
                                                }
                                              } else {
                                                return StreamBuilder<
                                                    List<Map<String, dynamic>>>(
                                                  stream: Stream.value(
                                                      facilitySupervisorsList),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                        .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child: CircularProgressIndicator());
                                                    } else
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Error: ${snapshot
                                                              .error}');
                                                    } else {
                                                      // Extract the supervisors list or provide an empty list
                                                      List<Map<String,
                                                          dynamic>> supervisors = snapshot
                                                          .data ?? [];

                                                      // Map the data into dropdown items
                                                      List<DropdownMenuItem<Map<
                                                          String,
                                                          dynamic>>> dropdownItems =
                                                      supervisors.map((
                                                          supervisor) {
                                                        // Concatenate first name and last name
                                                        String fullName = "${supervisor['lastName']} ${supervisor['firstName']}";
                                                        return DropdownMenuItem<
                                                            Map<
                                                                String,
                                                                dynamic>>(
                                                          value: supervisor,
                                                          child: Text(fullName),
                                                        );
                                                      }).toList();

                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            width: double
                                                                .infinity,
                                                            // Ensures the dropdown fits the container
                                                            child: DropdownButton<
                                                                Map<
                                                                    String,
                                                                    dynamic>>(
                                                              isExpanded: true,
                                                              // Allows the dropdown to fit the available width
                                                              value: _selectedFacilitySupervisor,
                                                              // Use the state variable here
                                                              items: dropdownItems,
                                                              onChanged: (Map<
                                                                  String,
                                                                  dynamic>? newValue) {
                                                                if (newValue !=
                                                                    null) {
                                                                  setState(() {
                                                                    _selectedFacilitySupervisor =
                                                                        newValue;
                                                                    // Save the concatenated name and email address
                                                                    _selectedFacilitySupervisorFullName =
                                                                    "${newValue['lastName']} ${newValue['firstName']}";
                                                                    _selectedFacilitySupervisorEmail =
                                                                    newValue['emailAddress'];
                                                                    _selectedFacilitySupervisorSignatureLink =
                                                                    newValue['signatureLink'];
                                                                  });
                                                                  print(
                                                                      "Selected Supervisor: $_selectedFacilitySupervisorFullName");
                                                                  print(
                                                                      "Supervisor Email: $_selectedFacilitySupervisorEmail");
                                                                }
                                                              },
                                                              hint: const Text(
                                                                  'Select Supervisor'),
                                                            ),
                                                          ),
                                                          // const SizedBox(height: 16),
                                                          // ElevatedButton(
                                                          //   onPressed: () {
                                                          //     if (_selectedFacilitySupervisorFullName != null &&
                                                          //         _selectedFacilitySupervisorEmail != null) {
                                                          //       print("Submitting:");
                                                          //       print("Full Name: $_selectedFacilitySupervisorFullName");
                                                          //       print("Email Address: $_selectedFacilitySupervisorEmail");
                                                          //     } else {
                                                          //       print("Please select a supervisor first.");
                                                          //     }
                                                          //   },
                                                          //   child: const Text("Submit"),
                                                          // ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          ),


                                          SizedBox(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                (MediaQuery
                                                    .of(context)
                                                    .size
                                                    .shortestSide < 600
                                                    ? 0.005
                                                    : 0.005),
                                          ),
                                        ],
                                      ),
                                    ),


                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    //Signature of Project Cordinator
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.35 : 0.35),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //color: Colors.grey.shade200,
                                      child: Column(
                                        children: [
                                          Text('Signature', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery
                                                .of(context)
                                                .size
                                                .width * (MediaQuery
                                                .of(context)
                                                .size
                                                .shortestSide < 600
                                                ? 0.040
                                                : 0.020),)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.01
                                              : 0.009)),
                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final facilitySupervisorSignature = data['facilitySupervisorSignature']; // Assuming this stores the image URL
                                                final facilitySupervisorSignatureStatus = data['facilitySupervisorSignatureStatus']; // Assuming you store the date
                                                final facilitySupervisorRejectionReason = data['facilitySupervisorRejectionReason']; // Assuming you store the date

                                                if (facilitySupervisorSignature != null && facilitySupervisorSignatureStatus == "Approved") {
                                                  return Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 20,
                                                      bottom: 24,
                                                    ),
                                                    constraints: BoxConstraints(
                                                      maxHeight: MediaQuery.of(context).size.width *
                                                          (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                                      maxWidth: MediaQuery.of(context).size.width *
                                                          (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                                    ),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      // color: Colors.grey.shade300, // Uncomment if needed
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min, // Prevents expanding to fill space
                                                      children: [
                                                        Flexible(
                                                          child: Image.network(
                                                            facilitySupervisorSignature!,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(Icons.check_circle, color: Colors.green),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                                else if(facilitySupervisorSignature !=
                                                    null && facilitySupervisorSignatureStatus == "Rejected"){
                                                  return Column(
                                                    children: [
                                                      const Text("Awaiting Facility Supervisor Signature"),
                                                      const SizedBox(height: 8),
                                                      if (facilitySupervisorSignatureStatus == "Rejected")
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.cancel, color: Colors.red),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(width: 15),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      title: const Text("Reason for Rejection"),
                                                                      content: Text(facilitySupervisorRejectionReason ?? "No reason provided."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text("Close"),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.info_outline,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      else
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.check_circle, color: Colors.green),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  );
                                                }
                                                else {
                                                  return Column(
                                                    children: [
                                                      const Text("Awaiting Facility Supervisor Signature"),
                                                      const SizedBox(height: 8),
                                                      if (facilitySupervisorSignatureStatus == "Pending")
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.access_time, color: Colors.orange),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        )
                                                      else if (facilitySupervisorSignatureStatus == "Rejected")
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.cancel, color: Colors.red),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            const SizedBox(width: 15),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      title: const Text("Reason for Rejection"),
                                                                      content: Text(facilitySupervisorRejectionReason ?? "No reason provided."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text("Close"),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.info_outline,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      else
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.check_circle, color: Colors.green),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$facilitySupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  );

                                                }
                                              } else {
                                                return const Text(
                                                    "Timesheet Yet to be submitted for Project Cordinator's Signature");
                                              }
                                            },
                                          ), // Adjust path and size accordingly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    //Date of Project Signature Date

                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.30 : 0.30),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Date', style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),
                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final facilitySupervisorDate = data['facilitySupervisorSignatureDate']; // Assuming this stores the image URL
                                                //  final caritasSupervisorDate = data['date']; // Assuming you store the date

                                                if (facilitySupervisorDate !=
                                                    null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return Column(
                                                    children: [
                                                      //Image.network(facilitySupervisorSignature!), // Load the image from the cloud URL
                                                      Text(
                                                          facilitySupervisorDate
                                                              .toString()),
                                                    ],
                                                  );
                                                } else {
                                                  return const Text(
                                                      "Awaiting Facility Supervisor Date");
                                                }
                                              } else {
                                                return const Text(
                                                    "Timesheet Yet to be submitted for Project Cordinator's Signature Date");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    //SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),
                                  ],
                                ),
                                SizedBox(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * (MediaQuery
                                    .of(context)
                                    .size
                                    .shortestSide < 600 ? 0.005 : 0.005)),
                                const Divider(),
                                // Third - CARITAS Supervisor Section
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.02 : 0.02),),
                                    // Name of CARITAS Supervisor
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.30
                                              : 0.25),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //color: Colors.grey.shade200,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            'Name of CARITAS Supervisor',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width *
                                                  (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .shortestSide < 600
                                                      ? 0.040
                                                      : 0.020),
                                            ),
                                          ),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),
                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final caritasSupervisor = data['caritasSupervisor']; // Assuming this stores the image URL
                                                //final caritasSupervisorDate = data['date']; // Assuming you store the date

                                                if (caritasSupervisor == null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return StreamBuilder<
                                                      List<String?>>(
                                                    stream: bioData != null &&
                                                        bioData!.department !=
                                                            null &&
                                                        bioData!.state != null
                                                        ? IsarService()
                                                        .getSupervisorStream(
                                                      bioData!.department!,
                                                      bioData!.state!,
                                                    )
                                                        : Stream.value([]),
                                                    builder: (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                            child: CircularProgressIndicator());
                                                      } else
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot
                                                                .error}');
                                                      } else {
                                                        List<
                                                            String?> supervisorNames = snapshot
                                                            .data ?? [];

                                                        return SizedBox(
                                                          width: double
                                                              .infinity,
                                                          // Ensures the dropdown fits the container
                                                          child: DropdownButton<
                                                              String?>(
                                                            isExpanded: true,
                                                            // Allows the dropdown to fit the available width
                                                            value: selectedSupervisor,
                                                            // Use the state variable here!!!
                                                            items: supervisorNames
                                                                .map((
                                                                supervisorName) {
                                                              return DropdownMenuItem<
                                                                  String?>(
                                                                value: supervisorName,
                                                                child: Text(
                                                                    supervisorName ??
                                                                        'No Supervisor',
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold)),
                                                              );
                                                            }).toList(),
                                                            onChanged: (
                                                                String? newValue) async {
                                                              setState(() {
                                                                selectedSupervisor =
                                                                    newValue;
                                                              });
                                                              print(
                                                                  "Selected Supervisor: $newValue");

                                                              List<
                                                                  String?> supervisorsemail = await IsarService()
                                                                  .getSupervisorEmailFromIsar(
                                                                  bioData!
                                                                      .department!,
                                                                  newValue);


                                                              setState(() {
                                                                _selectedSupervisorEmail =
                                                                supervisorsemail[0];
                                                              });
                                                              print(
                                                                  _selectedSupervisorEmail);
                                                            },
                                                            hint: const Text(
                                                                'Select Supervisor'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                } else {
                                                  return Text(
                                                      "$caritasSupervisor");
                                                }
                                              } else {
                                                return StreamBuilder<
                                                    List<String?>>(
                                                  stream: bioData != null &&
                                                      bioData!.department !=
                                                          null &&
                                                      bioData!.state != null
                                                      ? IsarService()
                                                      .getSupervisorStream(
                                                    bioData!.department!,
                                                    bioData!.state!,
                                                  )
                                                      : Stream.value([]),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                        .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child: CircularProgressIndicator());
                                                    } else
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Error: ${snapshot
                                                              .error}');
                                                    } else {
                                                      List<
                                                          String?> supervisorNames = snapshot
                                                          .data ?? [];

                                                      return SizedBox(
                                                        width: double.infinity,
                                                        // Ensures the dropdown fits the container
                                                        child: DropdownButton<
                                                            String?>(
                                                          isExpanded: true,
                                                          // Allows the dropdown to fit the available width
                                                          value: selectedSupervisor,
                                                          // Use the state variable here!!!
                                                          items: supervisorNames
                                                              .map((
                                                              supervisorName) {
                                                            return DropdownMenuItem<
                                                                String?>(
                                                              value: supervisorName,
                                                              child: Text(
                                                                  supervisorName ??
                                                                      'No Supervisor'),
                                                            );
                                                          }).toList(),
                                                          onChanged: (
                                                              String? newValue) async {
                                                            setState(() {
                                                              selectedSupervisor =
                                                                  newValue;
                                                            });
                                                            print(
                                                                "Selected Supervisor: $newValue");

                                                            List<
                                                                String?> supervisorsemail = await IsarService()
                                                                .getSupervisorEmailFromIsar(
                                                                bioData!
                                                                    .department!,
                                                                newValue);


                                                            setState(() {
                                                              _selectedSupervisorEmail =
                                                              supervisorsemail[0];
                                                            });
                                                            print(
                                                                _selectedSupervisorEmail);
                                                          },
                                                          hint: const Text(
                                                              'Select Supervisor'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                (MediaQuery
                                                    .of(context)
                                                    .size
                                                    .shortestSide < 600
                                                    ? 0.005
                                                    : 0.005),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    //Signature of CARITAS Supervisor
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.35 : 0.35),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      //color: Colors.grey.shade200,
                                      child: Column(
                                        children: [
                                          Text('Signature', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery
                                                .of(context)
                                                .size
                                                .width * (MediaQuery
                                                .of(context)
                                                .size
                                                .shortestSide < 600
                                                ? 0.040
                                                : 0.020),)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.02
                                              : 0.02)),
                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;
                                                final caritasSupervisorSignature = data['caritasSupervisorSignature']; // Assuming this stores the image URL
                                                final caritasSupervisorSignatureStatus = data['caritasSupervisorSignatureStatus']; // Assuming you store the date
                                                final caritasSupervisorRejectionReason = data['caritasSupervisorRejectionReason'];
                                                final facilitySupervisorSignatureStatus = data['facilitySupervisorSignatureStatus'];

                                                // if (caritasSupervisorSignature !=
                                                //     null) {
                                                //   // caritasSupervisorSignature is a URL/path to the image
                                                //   return Container(
                                                //     margin: const EdgeInsets
                                                //         .only(
                                                //       top: 20,
                                                //       bottom: 24,
                                                //     ),
                                                //     height: MediaQuery
                                                //         .of(context)
                                                //         .size
                                                //         .width *
                                                //         (MediaQuery
                                                //             .of(context)
                                                //             .size
                                                //             .shortestSide < 600
                                                //             ? 0.30
                                                //             : 0.15),
                                                //     width: MediaQuery
                                                //         .of(context)
                                                //         .size
                                                //         .width *
                                                //         (MediaQuery
                                                //             .of(context)
                                                //             .size
                                                //             .shortestSide < 600
                                                //             ? 0.30
                                                //             : 0.30),
                                                //     alignment: Alignment.center,
                                                //     decoration: BoxDecoration(
                                                //       borderRadius: BorderRadius
                                                //           .circular(20),
                                                //       //color: Colors.grey.shade300,
                                                //     ),
                                                //     child: Image.network(
                                                //         caritasSupervisorSignature!),
                                                //   );
                                                // }

                                                if (caritasSupervisorSignature != null && caritasSupervisorSignatureStatus == "Approved") {
                                                  return Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 20,
                                                      bottom: 24,
                                                    ),
                                                    constraints: BoxConstraints(
                                                      maxHeight: MediaQuery.of(context).size.width *
                                                          (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                                      maxWidth: MediaQuery.of(context).size.width *
                                                          (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                                    ),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      // color: Colors.grey.shade300, // Uncomment if needed
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min, // Prevents expanding to fill space
                                                      children: [
                                                        Flexible(
                                                          child: Image.network(
                                                            caritasSupervisorSignature!,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(Icons.check_circle, color: Colors.green),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              "$caritasSupervisorSignatureStatus",
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }



                                                else if (caritasSupervisorSignatureStatus == "Pending" && facilitySupervisorSignatureStatus == "Pending") {
                                                  return Column(
                                                    children: [
                                                      const Text(
                                                        "Awaiting Approved Signature from Facility Supervisor before signature from CARITAS Supervisor ",
                                                       // style: TextStyle(fontWeight: FontWeight.bold),
                                                        softWrap: true,
                                                        overflow: TextOverflow.visible,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      facilitySupervisorSignatureStatus == "Pending"
                                                          ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.only(top: 0.0),
                                                            child: Icon(Icons.access_time, color: Colors.orange),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 0.0),
                                                              child: Text(
                                                                "$facilitySupervisorSignatureStatus (Awaiting Approval from Facility Supervisor)",
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          : facilitySupervisorSignatureStatus == "Rejected"
                                                          ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.only(top: 0.0),
                                                            child: Icon(Icons.cancel, color: Colors.red),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 0.0),
                                                              child: Text(
                                                                "$facilitySupervisorSignatureStatus (Approval Rejected by Facility Supervisor)",
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: const Text("Reason for Rejection"),
                                                                    content: Text(
                                                                      facilitySupervisorSignatureStatus ?? "No reason provided.",
                                                                      softWrap: true,
                                                                      overflow: TextOverflow.visible,
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: const Text("Close"),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.info_outline,
                                                              color: Colors.blue,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.only(top: 0.0),
                                                            child: Icon(Icons.check_circle, color: Colors.green),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 0.0),
                                                              child: Text(
                                                                "$facilitySupervisorSignatureStatus",
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }
                                                else if (caritasSupervisorSignatureStatus == "Pending" && facilitySupervisorSignatureStatus == "Rejected") {
                                                  return Column(
                                                    children: [
                                                      const Text(
                                                        "Awaiting Approved Signature from Facility Supervisor before signature from CARITAS Supervisor ",
                                                       // style: TextStyle(fontWeight: FontWeight.w100),
                                                        softWrap: true,
                                                        overflow: TextOverflow.visible,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      facilitySupervisorSignatureStatus == "Rejected"
                                                          ? const Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 0.0),
                                                            child: Icon(Icons.cancel, color: Colors.red),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(bottom: 0.0),
                                                              child: Text(
                                                                "(Approval Rejected by Facility Supervisor)",
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),

                                                        ],
                                                      )
                                                          : Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets.only(top: 0.0),
                                                            child: Icon(Icons.check_circle, color: Colors.green),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 0.0),
                                                              child: Text(
                                                                "$facilitySupervisorSignatureStatus",
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                softWrap: true,
                                                                overflow: TextOverflow.visible,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }


                                                else {
                                                  return Column(
                                                    children: [
                                                      const Text(
                                                          "Awaiting Caritas Supervisor Signature"),
                                                      const SizedBox(height: 8),
                                                      caritasSupervisorSignatureStatus ==
                                                          "Pending"
                                                          ?
                                                      Row(
                                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 0.0),
                                                              child:
                                                              Icon(Icons
                                                                  .access_time,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top: 0.0),
                                                              child: Text(
                                                                "$caritasSupervisorSignatureStatus",
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                          : caritasSupervisorSignatureStatus ==
                                                          "Rejected" ?
                                                      Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 0.0),
                                                              child:
                                                              Icon(Icons.cancel,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  bottom: 0.0),
                                                              child: Text(
                                                                "$caritasSupervisorSignatureStatus",
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                            const SizedBox(width:8),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return AlertDialog(
                                                                      title: const Text("Reason for Rejection"),
                                                                      content: Text(caritasSupervisorRejectionReason ?? "No reason provided."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text("Close"),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.info_outline,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ]
                                                      )
                                                          : Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 0.0),
                                                              child:
                                                              Icon(Icons
                                                                  .check_circle,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  bottom: 0.0),
                                                              child: Text(
                                                                "$caritasSupervisorSignatureStatus",
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold),
                                                              ),
                                                            ),
                                                          ]
                                                      ),


                                                    ],
                                                  );
                                                }


                                              } else {
                                                return const Text(
                                                    "Timesheet Yet to be submitted for Caritas Supervisor's Signature");
                                              }
                                            },
                                          ), // Adjust path and size accordingly
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * (MediaQuery
                                        .of(context)
                                        .size
                                        .shortestSide < 600 ? 0.01 : 0.009)),
                                    //Date of CARITAS Staff Signature Date

                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * (MediaQuery
                                          .of(context)
                                          .size
                                          .shortestSide < 600 ? 0.30 : 0.30),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const Text('Date', style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                          SizedBox(height: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (MediaQuery
                                              .of(context)
                                              .size
                                              .shortestSide < 600
                                              ? 0.07
                                              : 0.05)),

                                          StreamBuilder<DocumentSnapshot>(
                                            // Stream the supervisor signature
                                            stream: FirebaseFirestore.instance
                                                .collection("Staff")
                                                .doc(
                                                selectedFirebaseId) // Replace with how you get the staff document ID
                                                .collection("TimeSheets")
                                                .doc(
                                                DateFormat('MMMM_yyyy').format(
                                                    DateTime(selectedYear,
                                                        selectedMonth +
                                                            1))) // Replace monthYear with the timesheet document ID
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  snapshot.data!.exists) {
                                                final data = snapshot.data!
                                                    .data() as Map<
                                                    String,
                                                    dynamic>;

                                                final caritasSupervisorDate = data['caritasSupervisorSignatureDate']; // Assuming this stores the image URL
                                                //  final caritasSupervisorDate = data['date']; // Assuming you store the date

                                                if (caritasSupervisorDate !=
                                                    null) {
                                                  // caritasSupervisorSignature is a URL/path to the image
                                                  return Column(
                                                    children: [
                                                      //Image.network(facilitySupervisorSignature!), // Load the image from the cloud URL
                                                      Text(
                                                          caritasSupervisorDate
                                                              .toString()),
                                                    ],
                                                  );
                                                } else {
                                                  return const Text(
                                                      "Awaiting CARITAS Supervisor Date");
                                                }
                                              } else {
                                                return const Text(
                                                    "Timesheet Yet to be submitted for CARITAS Supervisor's Signature Date");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * (MediaQuery
                                    .of(context)
                                    .size
                                    .shortestSide < 600 ? 0.005 : 0.005)),
                                const Divider(),
                                StreamBuilder<DocumentSnapshot>(
                                  // Stream the supervisor signature
                                  stream: FirebaseFirestore.instance
                                      .collection("Staff")
                                      .doc(
                                      selectedFirebaseId) // Replace with how you get the staff document ID
                                      .collection("TimeSheets")
                                      .doc(DateFormat('MMMM_yyyy').format(
                                      DateTime(selectedYear, selectedMonth +
                                          1))) // Replace monthYear with the timesheet document ID
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.exists) {
                                      final data = snapshot.data!.data() as Map<
                                          String,
                                          dynamic>;

                                      final caritasSupervisorSignature = data['caritasSupervisorSignature']; // Assuming this stores the image URL
                                      final facilitySupervisorSignature = data['facilitySupervisorSignature'];
                                      final staffSignature = data['staffSignature']; // Assuming you store the date

                                      if (caritasSupervisorSignature != null &&
                                          facilitySupervisorSignature != null &&
                                          staffSignature != null) {
                                        // caritasSupervisorSignature is a URL/path to the image
                                        return
                                          ElevatedButton(
                                            onPressed: sendEmailToSelf,
                                            // Call the save function
                                            child: const Text(
                                                'Email Signed Timesheet to Self'),
                                          );
                                      } else {
                                        return ElevatedButton(
                                          onPressed: _saveTimesheetToFirestore,
                                          // Call the save function
                                          child: const Text('Submit Timesheet'),
                                        );
                                      }
                                    } else {
                                      return ElevatedButton(
                                        onPressed: _saveTimesheetToFirestore,
                                        // Call the save function
                                        child: const Text('Submit Timesheet'),
                                      );
                                    }
                                  },
                                ),

                                SizedBox(height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * (MediaQuery
                                    .of(context)
                                    .size
                                    .shortestSide < 600 ? 0.020 : 0.020)),
                              ]
                          ),
                        ]
                    )


                )

            ),


          ],
        ),
      ),
    );
  }

  Future<void> _fetchFacilitySupervisor() async {
    print("_fetchPendingApprovals");

    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      final user = await IsarService().getBioInfoForUser();
      // Fetch pending leaves
      final leavesSnapshot = await FirebaseFirestore.instance
          .collectionGroup('Staff')
          .where('state', isEqualTo: user[0].state)
          .where('location', isEqualTo: user[0].location)
          .where('staffCategory', isEqualTo: 'Facility Supervisor')
          .get();


      setState(() {
        facilitySupervisorsList =
            leavesSnapshot.docs.map((doc) => doc.data()).toList();
        _isLoading = false; // Hide loading indicator after data is fetched
      });
      print("facilitySupervisorsList == $facilitySupervisorsList");
    } catch (e) {
      print('Error fetching Facility supervisors: $e');
      Fluttertoast.showToast(
        msg: "'Error fetching Facility supervisors: $e'",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    DatabaseAdapter adapter = HiveService();
    return adapter.getSignatureImages();
  }

  Future<void> _pickImage() async {
    DatabaseAdapter adapter = HiveService();
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );
      if (image == null) return;

      Uint8List imageBytes = await image.readAsBytes();
      adapter.storeSignatureImage(imageBytes);
      setState(() {
        staffSignature = imageBytes; // Update staffSignature variable
      });
      _saveTimesheetToFirestore(); // Save after signature is selected


    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error:${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _saveTimesheetToFirestore() async {
    bioData = await IsarService().getBioData();
    print("Step One");

    if (bioData!.signatureLink == null) {
      // Handle case where signature is not present (e.g., show a message)

      if (checkSignatureImage
          .isNotEmpty) { // Check if signature image exists in Hive
        try {
          // 1. Upload image to Cloud Storage
          final storageRef = FirebaseStorage.instance.ref().child(
              'signatures/${selectedFirebaseId}_signature.jpg'); // Create unique filename
          final uploadTask = storageRef.putData(
              checkSignatureImage.first); // Upload the image data
          final snapshot = await uploadTask;
          final downloadURL = await snapshot.ref.getDownloadURL();

          // 2. Update Isar and timesheet data with download URL
          bioData = await IsarService().getBioData();
          bioData?.signatureLink = downloadURL;
          await IsarService().updateBioSignatureLink(
              bioData!.id, bioData!, false);
          staffSignatureLink = downloadURL; // Update the local variable as well


        } catch (e) {
          print('Error uploading signature or updating database: $e');
          // Handle error, e.g., show a dialog
        }
      }
      else {
        Fluttertoast.showToast(
          msg: "Cannot send timesheet without staff signature.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Cannot send timesheet without staff signature.");
        return;
      }
      print("selectedSupervisor ===$selectedSupervisor");
      print(
          "_selectedFacilitySupervisorFullName ==$_selectedFacilitySupervisorFullName");
    }
      if (selectedSupervisor == null ||
          _selectedFacilitySupervisorFullName == null) {
        // Handle case where signature is not present (e.g., show a message)

        Fluttertoast.showToast(
          msg: "Cannot send timesheet without Selecting Project Coordinator Name or CARITAS Supervisor.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        log("Cannot send timesheet without staff signature.");
        return;
      }
      log("selectedSupervisor ===$selectedSupervisor");
      log("_selectedFacilitySupervisorFullName ==$_selectedFacilitySupervisorFullName");

      String monthYear = DateFormat('MMMM_yyyy').format(
          DateTime(selectedYear, selectedMonth + 1));

      try {
        log("Start Pushing timesheet");
        // Construct the timesheet data to be saved
        List<BioModel> getAttendanceForBio =
        await IsarService().getBioInfoWithUserBio();


        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Staff")
            .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
            .get();

        List<Map<String, dynamic>> timesheetEntries = [];

        for (var date in daysInRange) {
          Map<String,
              dynamic>? entryForDate; // Store the entry for the current date

          for (var attendance in attendanceData) {
            try {
              DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(
                  attendance.date!);
              if (attendanceDate.year == date.year &&
                  attendanceDate.month == date.month &&
                  attendanceDate.day == date.day) {
                entryForDate = {
                  // Create or update the entry for this date
                  'date': DateFormat('yyyy-MM-dd').format(date),
                  'noOfHours': attendance.noOfHours,
                  // Use noOfHours directly from attendance
                  'projectName': selectedProjectName,
                  'offDay': attendance.offDay,
                  // Use offDay directly
                  'durationWorked': attendance.durationWorked,
                  // Use durationWorked directly
                };
                break; // Exit inner loop once an entry is found for the date
              }
            } catch (e) {
              log("Error parsing date: $e");
            }
          }

          if (entryForDate !=
              null) { // Add the entry if it exists for this date
            timesheetEntries.add(entryForDate);
          }
        }

        Map<String, dynamic> timesheetData = {
          'projectName': selectedProjectName,
          'staffName': '$selectedBioFirstName $selectedBioLastName',
          'staffSignature': staffSignatureLink,
          // 'staffSignatureDate': DateFormat('MMMM dd, yyyy').format(
          //     createCustomDate(selectedMonth + 1, selectedYear)),
          'staffSignatureDate': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
          'facilitySupervisorSignatureDate': null,
          'caritasSupervisorSignatureDate': null,
          'department': selectedBioDepartment,
          'state': selectedBioState,
          'facilitySupervisorSignatureStatus': 'Pending',
          'caritasSupervisorSignatureStatus': 'Pending',
          'timesheetEntries': timesheetEntries,
          //<<< The list of date/hour entries
          'facilitySupervisor': _selectedFacilitySupervisorFullName,
          'facilitySupervisorEmail': _selectedFacilitySupervisorEmail,
          'facilitySupervisorSignature': facilitySupervisorSignature,
          'caritasSupervisor': selectedSupervisor,
          'caritasSupervisorSignature': caritasSupervisorSignature,
          'caritasSupervisorEmail': _selectedSupervisorEmail,
          'staffId': selectedFirebaseId,
          'designation': selectedBioDesignation,
          'location': selectedBioLocation,
          'staffCategory': selectedBioStaffCategory,
          'staffEmail': selectedBioEmail,
          'staffPhone': selectedBioPhone,

        };


        await FirebaseFirestore.instance
            .collection("Staff")
            .doc(snap.docs[0].id)
            .collection("TimeSheets")
            .doc(monthYear)
            .set(timesheetData, SetOptions(merge: true));


        print('Timesheet saved to Firestore');
        Fluttertoast.showToast(
          msg: "Timesheet sent to supervisor",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        print('Error saving timesheet: $e');
        // Handle error (e.g., show a dialog)
      }
    }

    // Function to load and append coordinator signature

    Future<void> _loadAndAppendCoordinatorSignature(String monthYear) async {
      try {
        List<BioModel> getAttendanceForBio =
        await IsarService().getBioInfoWithUserBio();


        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Staff")
            .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
            .get();

        DocumentSnapshot timesheetDoc = await FirebaseFirestore.instance
            .collection("Staff")
            .doc(snap.docs[0].id)
            .collection("TimeSheets")
            .doc(monthYear) // Assuming monthYear is the document ID
            .get();


        if (timesheetDoc.exists) {
          Map<String, dynamic> data = timesheetDoc.data() as Map<String,
              dynamic>;
          Uint8List coordinatorSignature = data['facilitySupervisorSignature']; // Get coordinator signature


          // Update the timesheet with the coordinator's signature

        } else {
          log('Timesheet document not found.');
        }
      } catch (e) {
        log("Error loading coordinator signature $e");
      }
    }
  }