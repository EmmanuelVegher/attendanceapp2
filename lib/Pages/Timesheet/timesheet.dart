import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:attendanceapp/services/database_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import 'package:attendanceapp/services/hive_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../model/attendancemodel.dart';
import '../../model/bio_model.dart';
import '../../services/database_adapter.dart';
import '../../services/hive_service.dart';
import '../../services/isar_service.dart';
import '../../widgets/drawer.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Alignment,Border; // Import and hide conflicting classes


class TimesheetScreen extends StatefulWidget {
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
  BioModel? bioData; // Make bioData nullable// Currently selected project
  String? selectedSupervisor; // State variable to store the selected supervisor

  Uint8List? staffSignature; // Store staff signature as Uint8List
  Uint8List? facilitySupervisorSignature; // Array field for facility supervisor signature
  Uint8List? caritasSupervisorSignature;   // Array field for Caritas supervisor signature

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey(); // Initialize the GlobalKe
    DateTime now = DateTime.now();
    selectedMonth = now.month - 1;
    selectedYear = now.year;
    initializeDateRange(selectedMonth,selectedYear);
    _loadProjectNames(); // Load project names from Isar
    _loadAttendanceData();
    _scrollController = ScrollController(); // Initialize the scroll controller
    _loadBioData().then((_) {
      if (bioData != null && bioData!.department != null && bioData!.state != null) { //  Check if bioData and its properties are not null
        _loadSupervisorNames(bioData!.department!, bioData!.state!);
      } else {
        // Handle the case where bioData or its properties are null
        print("Bio data or department/state is missing!");
        // Perhaps set default values or show an error message
      }
    });
  }

  DateTime createCustomDate(int selectedMonth, int selectedYear) {
    return DateTime(selectedYear, selectedMonth, 20); // Directly create the DateTime object
  }


  Future<void> _createAndExportExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Add header row
    sheet.getRangeByName('A1').setText('Project Name');
    for (int i = 0; i < daysInRange.length; i++) {
      sheet.getRangeByIndex(1, i + 2).setText(DateFormat('dd MMM').format(daysInRange[i]));
    }
    sheet.getRangeByName('A${daysInRange.length+2}').setText('Total Hours');
    // Add data rows (similar to how you build the UI table)
    // Example:
    sheet.getRangeByName('A2').setText(selectedProjectName ?? '');


    for (var i = 0; i < daysInRange.length; i++) {

      bool weekend = isWeekend(daysInRange[i]);
      String hours = _getDurationForDate(daysInRange[i], selectedProjectName, selectedProjectName!);

      sheet.getRangeByIndex(2, i + 2).setText(weekend? '' : hours);

    }

    sheet.getRangeByName('A${daysInRange.length+2}').setText('${calculateTotalHours()}');



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



  Future<void> _createAndExportPDF() async {
    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final context = _globalKey.currentContext!;

      // Get dimensions
      final totalWidth = context.size!.width; // Use context.size for visible width
      final totalHeight = boundary.size.height;

      final pdf = pw.Document();
      List<ui.Image> images = [];
      double currentScrollOffset = 0;


      while (currentScrollOffset < calculateScrollableWidth(context)) { // corrected condition
        // Scroll
        await _scrollController.animateTo(
          currentScrollOffset,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        await Future.delayed(Duration(milliseconds: 200)); // short delay

        // Capture image
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        images.add(image);

        currentScrollOffset += context.size!.width;
      }

      for (var image in images) {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        pdf.addPage(pw.Page(
            build: (pw.Context context) => pw.Center(child: pw.FittedBox(
              fit: pw.BoxFit.contain,
              child: pw.Image(pw.MemoryImage(pngBytes)),
            ))
        ));
      }

      final output = await getExternalStorageDirectory();
      final file = File("${output?.path}/timesheet.pdf");
      await file.writeAsBytes(await pdf.save()); // Corrected line
      // Open the PDF file
      await OpenFilex.open(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to: ${file.path}')),
      );

    } catch (e) {
      print("Error generating PDF: $e");
      // Handle error (e.g., show a dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF')),
      );
    }
  }


  Future<void> _loadAttendanceData() async {
    attendanceData = await IsarService().getAllAttendance();
    setState(() {}); // Rebuild the UI after fetching data
  }


  String _getDurationForDate(DateTime date, String? projectName, String category) {
    double totalHoursForDate = 0;

    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);

        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName) {
            if (!attendance.offDay!) {
              totalHoursForDate += attendance.noOfHours!;
            }
          } else {
            if (attendance.offDay! &&
                attendance.durationWorked?.toLowerCase() == category.toLowerCase()) {
              totalHoursForDate += attendance.noOfHours!;
            }
          }
        }
      } catch (e) {
        print("Error parsing date: $e");
      }
    }
    return "${totalHoursForDate.toStringAsFixed(2)} hrs";
  }

  double _getDurationForDate1(DateTime date, String? projectName, String category) {
    double totalHoursForDate = 0;

    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);

        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName) {
            if (!attendance.offDay!) {
              totalHoursForDate += attendance.noOfHours!;
            }
          } else {
            if (attendance.offDay! && attendance.durationWorked?.toLowerCase() == category.toLowerCase()) {
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
    supervisorNames = await IsarService().getSupervisorEmailFromIsar(department, state);
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
        selectedProjectName = projectNames[0]; // Select the first project initially
      });
    }
  }

  Future<void> _loadBioData() async {
    bioData = await IsarService().getBioData();
    if (bioData != null) { // Check if bioData is not null before accessing its properties
      setState(() {
        selectedBioFirstName = bioData!.firstName;  // Use the null-aware operator (!)
        selectedBioLastName = bioData!.lastName;    // Use the null-aware operator (!)
        selectedBioDepartment = bioData!.department; // Initialize selectedBioDepartment
        selectedBioState = bioData!.state;           // Initialize selectedBioState
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
  }




  void initializeDateRange(int month, int year) {
    DateTime selectedMonthDate = DateTime(year, month + 1, 1);
    startDate = DateTime(selectedMonthDate.year, selectedMonthDate.month - 1, 19); //Start from the 19th of previous month
    endDate = DateTime(selectedMonthDate.year, selectedMonthDate.month, 20);    //End on the 20th of current month


    daysInRange = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      daysInRange.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  // Dummy data for supervisors
  List<String> facilitySupervisors = ['Supervisor A', 'Supervisor B', 'Supervisor C'];
  List<String> caritasSupervisors = ['Caritas A', 'Caritas B', 'Caritas C'];

  bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  int calculateTotalHours() {
    double totalHours = 0;

    for (var date in daysInRange) {
      if (!isWeekend(date)) { // Skip weekends
        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
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
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day ) {
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
    int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.

    int totalHours = calculateTotalHours();

    if (workingDays * 8 == 0) {
      return 0;
    }

    return (totalHours / (workingDays * 8)) * 100;
  }

  double calculateGrandPercentageWorked() {
    int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.

    int totalHours = calculateGrandTotalHours();

    if (workingDays * 8 == 0) {
      return 0;
    }

    return (totalHours / (workingDays * 8)) * 100;
  }

  // double calculateGrandPercentageWorked() {
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
  //               attendanceDate.day == date.day) { // Include all entries for the day, offDay or not.
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

  // Calculate total hours for a specific category
  double calculateCategoryHours(String category) {
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day &&
                attendance.offDay! && //Check for offDay for these categories
                attendance.durationWorked?.toLowerCase() == category.toLowerCase()) {
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

  double calculateCategoryPercentage(String category) {
    int workingDays = daysInRange.where((date) => !isWeekend(date)).length; // Correctly calculates working days in the selected month's date range.

    double totalHours = calculateCategoryHours(category);

    if (workingDays * 8 == 0) {
      return 0;
    }

    return (totalHours / (workingDays * 8)) * 100;
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
        title: Text('Timesheet'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _createAndExportPDF,
          ),
          IconButton(
            icon: const Icon(Icons.save_alt), // Use a suitable icon for Excel
            onPressed: _createAndExportExcel,
          ),
        ],
      ),
      drawer:
      // role == "User"
      //     ?
      drawer(this.context, IsarService()),
         // : drawer2(this.context, IsarService()),
      body: SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
        child: Column(
          children: [
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
                      int year = DateTime.now().year - index;
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
            // Attendance Sheet in a Container with 50% screen height
            Container(
              //height: MediaQuery.of(context).size.height * 0.5, // Adjusted height for better visibility
              child:RepaintBoundary(
                key: _globalKey,
                child:

                  SingleChildScrollView(
                    controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child:
                // SizedBox( // <-- Use SizedBox to constrain the width
                //     width: totalContentWidth(), // Calculate this dynamically
                //     child:
                Column(
                  children:[
                Column(
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          width: 150, // Set a width for the "Project Name" header
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blue.shade100,
                          child: Text(
                            'Project Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...daysInRange.map((date) {
                          return Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: isWeekend(date) ? Colors.grey.shade300 : Colors.blue.shade100,
                            child: Text(
                              DateFormat('dd MMM').format(date),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blue.shade100,
                          child: Text(
                            'Total Hours',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blue.shade100,
                          child: Text(
                            'Percentage',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Container(
                          width: 150, // Keep the fixed width if you need it
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: projectNames.isEmpty
                              ? Text('No projects found')
                              : DropdownButton<String>(
                            value: selectedProjectName,
                            isExpanded: true, // This will expand the dropdown to the Container's width
                            items: projectNames.map((projectName) {
                              return DropdownMenuItem<String>(
                                value: projectName,
                                child: FittedBox( // Use FittedBox to wrap the Text
                                  fit: BoxFit.scaleDown, // Scales down text to fit
                                  alignment: Alignment.centerLeft, // Align text to the left
                                  child: Text(projectName ?? 'No Project Name'),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedProjectName = newValue;
                              });
                            },
                            hint: Text('Select Project'),
                          ),
                        ),
                        ...daysInRange.map((date) {
                          bool weekend = isWeekend(date);
                          String hours = _getDurationForDate(date, selectedProjectName, selectedProjectName!);
                          return Container(
                            width: 100, // Set a fixed width for each day
                            decoration: BoxDecoration(
                              color: weekend ? Colors.grey.shade300 : Colors.white,
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                weekend
                                    ? SizedBox.shrink() // No hours on weekends
                                    : Text(
                                  '${hours}', // Placeholder, replace with Isar data
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '$totalHours hrs',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '${percentageWorked.toStringAsFixed(2)}%',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    // "Out-of-office" Header Row
                    Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            'Out-of-office',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),
                          ),
                        ),
                        ...List.generate(daysInRange.length, (index) {
                          return Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Text(
                              '', // Placeholder for out-of-office data, can be replaced later
                            ),
                          );
                        }).toList(),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '', // Placeholder for total hours
                          ),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '', // Placeholder for percentage
                          ),
                        ),
                      ],
                    ),
                    // Rows for out-of-office categories
                    ...['Absent', 'Annual leave', 'Holiday', 'Other Leaves', 'Security Crisis', 'Sick leave', 'Remote working', 'Sit at home', 'Trainings', 'Travel'].map((category) {
                      double outOfOfficeHours = calculateCategoryHours(category);
                      double outOfOfficePercentage = calculateCategoryPercentage(category);
                      return Row(
                        children: [
                          Container(
                            width: 150,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Text(
                              category,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...daysInRange.map((date) {
                            bool weekend = isWeekend(date);
                            String offDayHours = _getDurationForDate(date, selectedProjectName, category);


                            return Container(
                              width: 100, // Set a fixed width for each day
                              decoration: BoxDecoration(
                                color: weekend ? Colors.grey.shade300 : Colors.white,
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  weekend
                                      ? SizedBox.shrink() // No hours on weekends
                                      : Text(
                                    offDayHours, // Placeholder, replace with Isar data
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                            );

                          }).toList(),
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Text(
                              '${outOfOfficeHours.toStringAsFixed(2)} hrs',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Text(
                              '${outOfOfficePercentage.toStringAsFixed(2)}%',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),
                          ),
                        ),
                        ...List.generate(daysInRange.length, (index) {
                          return Container(
                            width: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Text(
                              '', // Placeholder for out-of-office data, can be replaced later
                            ),
                          );
                        }).toList(),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '$totalGrandHours hrs',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Text(
                            '${grandPercentageWorked.toStringAsFixed(2)}%',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),



                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Text('Name of Staff', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              Text(
                                '${selectedBioFirstName.toString().toUpperCase()} ${selectedBioLastName.toString().toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "NexaLight",
                                ),
                              ), // Adjust path and size accordingly
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Text('Signature of Employee', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 24,
                                  ),
                                  height: 100,
                                  width: 220,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.red,
                                  ),
                                  child: RefreshableWidget<List<Uint8List>?>(
                                    refreshCall: () async {
                                      return await _readImagesFromDatabase();
                                    },
                                    refreshRate: const Duration(seconds: 1),
                                    errorWidget: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey.shade300,
                                    ),
                                    loadingWidget: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey.shade300,
                                    ),
                                    builder: ((context, value) {
                                      return ListView.builder(
                                        itemCount: value!.length,
                                        itemBuilder: (context, index) =>
                                            Image.memory(value.first),
                                      );
                                    }),
                                  ),
                                ),
                              ),// Adjust path and size accordingly
                            ],
                          ),
                        ),

                        Container(
                          width: 300,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              Text("${formattedDate}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: _saveTimesheetToFirestore, // Call the save function
                          child: Text('Send Timesheet to Supervisor'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    //Second
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Text('Name of Project Coordinator', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              DropdownButton<String>(
                                items: facilitySupervisors.map((String supervisor) {
                                  return DropdownMenuItem<String>(
                                    value: supervisor,
                                    child: Text(supervisor),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    facilitySupervisorController.text = newValue ?? '';
                                  });
                                },
                                hint: Text('Select Supervisor'),
                              ),// Adjust path and size accordingly
                            ],
                          ),
                        ),

                        SizedBox(width: 20.0),
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: const Column(
                            children: [
                              Text('Signature of Project Cordinator', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              TextField(
                               // controller: facilitySupervisorController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '',
                                ),
                              ),// Adjust path and size accordingly
                            ],
                          ),
                        ),

                        Container(
                          width: 300,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              Text("${formattedDate}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){}, // Call the save function
                          child: Text('Recieve Signed Timesheet From Supervisor'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: Column(
                            children: [
                              Text('Name of Supervisor', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),

                              StreamBuilder<List<String?>>(
                                stream: bioData != null && bioData!.department != null && bioData!.state != null
                                    ? IsarService().getSupervisorStream(bioData!.department!, bioData!.state!)
                                    : Stream.value([]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<String?> supervisorNames = snapshot.data ?? [];

                                    return DropdownButton<String?>(
                                      value: selectedSupervisor, // Use the state variable here!!!
                                      items: supervisorNames.map((supervisorName) {
                                        return DropdownMenuItem<String?>(
                                          value: supervisorName,
                                          child: Text(supervisorName ?? 'No Supervisor'),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {  // Important: Wrap the assignment in setState
                                          selectedSupervisor = newValue;
                                        });
                                        print("Selected Supervisor: $newValue");
                                      },
                                      hint: Text('Select Supervisor'),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          width: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: const Column(
                            children: [
                              Text('Signature of Supervisor', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              TextField(
                                //controller: facilitySupervisorController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '',
                                ),
                              ),// Adjust path and size accordingly
                            ],
                          ),
                        ),

                        Container(
                          width: 300,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 20.0),
                              Text("${formattedDate}", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){}, // Call the save function
                          child: Text('Recieve Signed Timesheet From Supervisor'),
                        ),
                      ],
                    ),
                  ]
                ) ,

                ],
                ),
                //),
              ),)

            ),




          ],
        ),
      ),
    );
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
    if (staffSignature == null) {
      // Handle case where signature is not present (e.g., show a message)
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

    String monthYear = DateFormat('MMMM_yyyy').format(DateTime(selectedYear, selectedMonth + 1));

    try {
      // Construct the timesheet data to be saved
      List<BioModel> getAttendanceForBio =
      await IsarService().getBioInfoWithUserBio();


      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: getAttendanceForBio[0].firebaseAuthId)
          .get();

      List<Map<String, dynamic>> timesheetEntries = [];

      for (var date in daysInRange) {
        Map<String, dynamic>? entryForDate; // Store the entry for the current date

        for (var attendance in attendanceData) {
          try {
            DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(attendance.date!);
            if (attendanceDate.year == date.year &&
                attendanceDate.month == date.month &&
                attendanceDate.day == date.day) {

              entryForDate = { // Create or update the entry for this date
                'date': DateFormat('yyyy-MM-dd').format(date),
                'noOfHours': attendance.noOfHours,  // Use noOfHours directly from attendance
                'projectName': selectedProjectName,
                'offDay': attendance.offDay, // Use offDay directly
                'durationWorked': attendance.durationWorked, // Use durationWorked directly
              };
              break; // Exit inner loop once an entry is found for the date
            }
          } catch (e) {
            print("Error parsing date: $e");
          }
        }

        if (entryForDate != null) { // Add the entry if it exists for this date
          timesheetEntries.add(entryForDate);
        }
      }


      Map<String, dynamic> timesheetData = {
        'projectName': selectedProjectName,
        'staffName': '${selectedBioFirstName} ${selectedBioLastName}',
        'staffSignature': staffSignature,
        'date': DateFormat('MMMM dd, yyyy').format(createCustomDate(selectedMonth + 1, selectedYear)),
        'department': selectedBioDepartment,
        'state': selectedBioState,
        'facilitySupervisorSignatureStatus': 'Pending',
        'caritasSupervisorSignatureStatus': 'Pending',
        'timesheetEntries': timesheetEntries, //<<< The list of date/hour entries
        'facilitySupervisor': facilitySupervisorController.text,
        'facilitySupervisorSignature': facilitySupervisorSignature,
        'caritasSupervisor': selectedSupervisor,
        'caritasSupervisorSignature': caritasSupervisorSignature,

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
        Map<String, dynamic> data = timesheetDoc.data() as Map<String, dynamic>;
        Uint8List coordinatorSignature = data['facilitySupervisorSignature']; // Get coordinator signature


        // Update the timesheet with the coordinator's signature

      } else {
        print('Timesheet document not found.');
      }
    } catch (e) {
      print("Error loading coordinator signature $e");
    }
  }

}
