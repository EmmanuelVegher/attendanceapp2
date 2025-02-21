import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../model/bio_model.dart';
import '../../services/database_adapter.dart';
import '../../services/hive_service.dart';
import '../../services/isar_service.dart';
import '../Leave_Request/Pending_Approvals.dart';

class TimesheetDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> timesheetData;
  //final String timesheetId;
  final String staffId;

  const TimesheetDetailsScreen({super.key, 
    required this.timesheetData,
    //required this.timesheetId,
    required this.staffId,
  });

  @override
  State<TimesheetDetailsScreen> createState() => _TimesheetDetailsScreenState();
}

class _TimesheetDetailsScreenState extends State<TimesheetDetailsScreen> {
  DatabaseAdapter adapter = HiveService();
  String? selectedProjectName;
  String? selectedBioFirstName;
  String? selectedBioLastName;
  String? selectedBioDepartment;
  String? selectedBioState;
  String? selectedBioDesignation;
  String? selectedBioLocation;
  String? selectedBioStaffCategory;
  String? selectedSignatureLink;
  String? selectedBioEmail;
  String? selectedBioPhone;
  String? selectedFirebaseId;
  BioModel? bioData; // Make bioData nullable// Currently selected project
  String? selectedSupervisor; // State variable to store the selected supervisor
  String? facilitySupervisorSignatureDate;
  String? caritasSupervisorSignatureDate;
  String? _caritasSupervisorSignatureLink;
  String? _selectedSupervisorEmail;
  Uint8List? staffSignature1; // Store staff signature as Uint8List
  String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
  var facilitySupervisorSignature;
  var caritasSupervisorSignature;
  String? _facilitySupervisorSignatureLink;
  List<Map<String, dynamic>> pendingTimesheetsFacilitySupervisor = [];
  List<Map<String, dynamic>> pendingTimesheetsCaritasSupervisor = [];
  bool isLoading = true;
  List<Uint8List> checkSignatureImage = []; // Initialize as empty list
  List<String> attachments = [];
  //List<AttendanceModel> attendanceData = [];

  @override
  void initState() {
    super.initState();
    _readImagesFromDatabase().then((images) {
      setState(() {
        checkSignatureImage =
            images ?? []; // Assign fetched images or empty list
      });
    });

    _loadBioData().then((_){
      _fetchPendingApprovals();
    });
  }


  Future<void> _fetchPendingApprovals() async {
    setState(() {
      isLoading = true; // Show loading indicator

    });

    try {
      final user = await IsarService().getBioInfoForUser();
      // Fetch pending leaves
      // final leavesSnapshot = await FirebaseFirestore.instance
      //     .collectionGroup('Leave Request')
      //     .where('selectedSupervisorEmail', isEqualTo: user[0].emailAddress)
      //     .where('status', isEqualTo: 'Pending')
      //     .get();
      //
      // // Fetch pending timesheets (replace with your actual timesheet query)
      // final timesheetsSnapshot = await FirebaseFirestore.instance
      //     .collectionGroup('TimeSheets') // Replace with your timesheet collection/subcollection
      //
      //     .where('caritasSupervisorSignatureStatus', isEqualTo: 'Pending')
      //     .get();

      // Fetch pending timesheets (replace with your actual timesheet query)
      final caritasSupervisorTimesheetsSnapshot = await FirebaseFirestore.instance
          .collectionGroup('TimeSheets') // Replace with your timesheet collection/subcollection
          .where('caritasSupervisorEmail', isEqualTo: user[0].emailAddress)
          .where('caritasSupervisorSignatureStatus', isEqualTo: 'Pending')
          .where('facilitySupervisorSignatureStatus', isEqualTo: 'Approved')
          .get();

      final facilitySupervisorTimesheetsSnapshot = await FirebaseFirestore.instance
          .collectionGroup('TimeSheets') // Replace with your timesheet collection/subcollection
          .where('facilitySupervisorEmail', isEqualTo: user[0].emailAddress)
          .where('facilitySupervisorSignatureStatus', isEqualTo: 'Pending')
          .get();


      setState(() {

        pendingTimesheetsFacilitySupervisor = facilitySupervisorTimesheetsSnapshot.docs.map((doc) => doc.data()).toList();
        pendingTimesheetsCaritasSupervisor = caritasSupervisorTimesheetsSnapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false; // Hide loading indicator after data is fetched
      });
    } catch (e) {
      print('Error fetching pending approvals: $e');
      Fluttertoast.showToast(
        msg: "'Error fetching pending approvals: $e'",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadSignatureAndSync() async {

    bioData = await IsarService().getBioData();

    if (bioData!.signatureLink == null) {
      if (checkSignatureImage
          .isNotEmpty) { // Check if signature image exists in Hive
        try {

          // 1. Upload image to Cloud Storage
                String bucketName = "attendanceapp-a6853.appspot.com";
                String storagePath =
                'signatures/${selectedFirebaseId}_signature.jpg';
          final storageRef = FirebaseStorage.instance.ref('$bucketName/$storagePath'); // Create unique filename
          final uploadTask = storageRef.putData(
              checkSignatureImage.first); // Upload the image data
          final snapshot = await uploadTask;
          final downloadURL = await snapshot.ref.getDownloadURL();

          // 2. Update Isar and timesheet data with download URL
          bioData = await IsarService().getBioData();
          bioData?.signatureLink = downloadURL;
          await IsarService().updateBioSignatureLink(
              bioData!.id, bioData!, false);
         // staffSignatureLink = downloadURL; // Update the local variable as well


        } catch (e) {
          print('Error uploading signature or updating database: $e');
          // Handle error, e.g., show a dialog
        }
      }
      else {
        if (selectedBioStaffCategory == "Facility Supervisor"){
          Fluttertoast.showToast(
            msg: "Cannot send timesheet without Facility Supervisor's signature.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        else{
          Fluttertoast.showToast(
            msg: "Cannot send timesheet without Facility Supervisor's signature.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }

      }
    }

    if (bioData!.signatureLink != null ) {
      DateTime timesheetDate1;
      try {
        timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
      } catch (e) {
        print("Error parsing date: $e");
        timesheetDate1 = DateTime.now();
      }

      final staffId = widget.timesheetData['staffId'] ?? 'N/A';

      String monthYear = DateFormat('MMMM_yyyy').format(timesheetDate1);

      try {

        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection("Staff")
            .where("id", isEqualTo: staffId)
            .get();

        if (selectedBioStaffCategory == "Facility Supervisor"){
          Map<String, dynamic> timesheetData = {

            'facilitySupervisorSignature': bioData!.signatureLink,
            'facilitySupervisorSignatureDate':DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            'facilitySupervisorSignatureStatus':"Approved",

          };


          await FirebaseFirestore.instance
              .collection("Staff")
              .doc(snap.docs[0].id)
              .collection("TimeSheets")
              .doc(monthYear)
              .set(timesheetData, SetOptions(merge: true));



          print('Timesheet saved to Firestore');
          Fluttertoast.showToast(
            msg: "Timesheet Signed",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PendingApprovalsPage(service: IsarService(),), // Replace with your target page widget
          //   ),
          // );

        }
        else{
          Map<String, dynamic> timesheetData = {

            'caritasSupervisorSignature': bioData!.signatureLink,
            'caritasSupervisorSignatureDate':DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            'caritasSupervisorSignatureStatus':"Approved",

          };


          await FirebaseFirestore.instance
              .collection("Staff")
              .doc(snap.docs[0].id)
              .collection("TimeSheets")
              .doc(monthYear)
              .set(timesheetData, SetOptions(merge: true));



          print('Timesheet saved to Firestore');
          Fluttertoast.showToast(
            msg: "Timesheet Signed",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.black54,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => PendingApprovalsPage(service: IsarService(),), // Replace with your target page widget
          //   ),
          // );
        }


      } catch (e) {
        print('Error saving timesheet: $e');
        // Handle error (e.g., show a dialog)
      }
    }


  }

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



      DateTime timesheetDate1;
      try {
        timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
      } catch (e) {
        print("Error parsing date: $e");
        timesheetDate1 = DateTime.now();
      }

      //final daysInRange = getDaysInRange(timesheetDate);
      final staffName = widget.timesheetData['staffName'] ?? 'N/A';
      final staffId = widget.timesheetData['staffId'] ?? 'N/A';

      final monthYear = DateFormat('MMMM, yyyy').format(timesheetDate1);


    final pdf = pw.Document(pageMode: PdfPageMode.outlines);

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

  Future<void> sendEmailToProjectManagementTeam() async {


    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    //final daysInRange = getDaysInRange(timesheetDate);
    final staffName = widget.timesheetData['staffName'] ?? 'N/A';
    final staffId = widget.timesheetData['staffId'] ?? 'N/A';

    final monthYear = DateFormat('MMMM, yyyy').format(timesheetDate1);
    final monthYear1 = DateFormat('MMMM_yyyy').format(timesheetDate1);


    final pdf = pw.Document(pageMode: PdfPageMode.outlines);

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



    } catch (e) {
      print("Error generating PDF: $e");
      // Handle the error, e.g., show a dialog to the user
    }
    // Clear the attachments list before adding new attachments
    attachments.clear();

    // 2. Save the PDF to a temporary file
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir
        .path}/Timesheet_${monthYear1}_$staffName.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // 3. Add the PDF file path to attachments
    attachments.add(pdfFile.path);


    final Email email = Email(
      body: '''
Greetings !!!,

Please find attached the completely signed timesheet for $staffName for $monthYear.

Best regards,
$selectedBioFirstName $selectedBioLastName

''',
      subject: 'Timesheet for $staffName for $monthYear',
      recipients: [selectedBioEmail!],
      attachmentPaths: attachments,
      isHTML: false,
    );
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PendingApprovalsPage(service: IsarService(),)),
      );
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

    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    //final daysInRange = getDaysInRange(timesheetDate);
    final staffName = widget.timesheetData['staffName'] ?? 'N/A';
    final staffId = widget.timesheetData['staffId'] ?? 'N/A';

    final monthYear = DateFormat('MMMM, yyyy').format(timesheetDate1);
    final monthYear1 = DateFormat('MMMM_yyyy').format(timesheetDate1);

    try {

      final timesheetDoc = await FirebaseFirestore.instance
          .collection("Staff")
          .doc(staffId)
          .collection("TimeSheets")
          .doc(monthYear1)
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
    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    //final daysInRange = getDaysInRange(timesheetDate);
    // final daysInRange = getDaysInRange(timesheetDate);
    final staffName = widget.timesheetData['staffName'] ?? 'N/A';
    final department = widget.timesheetData['department'] ?? 'N/A';
    final designation = widget.timesheetData['designation'] ?? 'N/A';
    final location = widget.timesheetData['location'] ?? 'N/A';

    final state = widget.timesheetData['state'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);


    final monthYear = DateFormat('MMMM, yyyy').format(timesheetDate1);
    final monthYear1 = DateFormat('MMMM_yyyy').format(timesheetDate1);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Name: $staffName'),
        pw.Text('Department: $department'),
        pw.Text('Designation: $designation'),
        pw.Text('Location: $location'),
        pw.Text('State: $state'),
        pw.SizedBox(height: 20), // Add some spacing

      ],
    );
  }

  double _getCappedHoursForDate(DateTime date, String? projectName, String category) {
    double totalHoursForDate = 0;

    final attendanceData = widget.timesheetData['timesheetEntries'] as List?;

    if (attendanceData != null) {
      for (var attendance in attendanceData.cast<Map<String, dynamic>>()) {
        try {
          DateTime attendanceDate = DateFormat('yyyy-MM-dd').parse(attendance['date']);

          if (attendanceDate.year == date.year &&
              attendanceDate.month == date.month &&
              attendanceDate.day == date.day) {
            if (category == projectName && !attendance['offDay']) {
              double hours = attendance['noOfHours'];
              totalHoursForDate += hours > 8 ? 8 : hours;

            } else if (attendance['offDay'] && attendance['durationWorked']?.toLowerCase() == category.toLowerCase()) {
              double hours = attendance['noOfHours'];
              totalHoursForDate += hours > 8 ? 8 : hours;
            }
          }
        } catch (e) {
          print("Error parsing date or calculating hours: $e");
        }
      }
    }

    return totalHoursForDate;
  }


// Updated function to calculate total hours for a project (with capping)
  double calculateTotalHours1() {
    double totalHours = 0;
      DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
      try {
        timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
      } catch (e) {
        print("Error parsing date: $e");
      }

      //final daysInRange = getDaysInRange(timesheetDate1);
      final projectName = widget.timesheetData['projectName'] ?? 'N/A';
      final month = DateFormat('MM').format(timesheetDate1);
      final year = DateFormat('yyyy').format(timesheetDate1);
      final daysInRange = initializeDateRange(int.parse(month),int.parse(year));
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        totalHours += _getCappedHoursForDate(
            date, projectName, projectName!); // Use helper function
      }
    }
    return totalHours;
  }

  double calculateGrandTotalHours1() {
    DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
    }

    //final daysInRange = getDaysInRange(timesheetDate1);
    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange = initializeDateRange(int.parse(month),int.parse(year));
    double projectTotal = calculateTotalHours1();

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

  // Updated function to calculate total hours for a category (with capping)
  double calculateCategoryHours1(String category) {
    DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
    }

    //final daysInRange = getDaysInRange(timesheetDate1);
    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange = initializeDateRange(int.parse(month),int.parse(year));
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        totalHours += _getCappedHoursForDate(
            date, projectName, category); // Use helper function
      }
    }
    return totalHours;
  }

  // Corrected grand percentage calculation (using capped grand total)
  double calculateGrandPercentageWorked() {
    DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
    }

    //final daysInRange = getDaysInRange(timesheetDate1);
    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange = initializeDateRange(int.parse(month),int.parse(year));
    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double cappedGrandTotalHours = calculateGrandTotalHours1();
    return (workingDays * 8) > 0 ? (cappedGrandTotalHours / (workingDays * 8)) *
        100 : 0; // Correct denominator

  }

  double calculateCategoryPercentage(String category) {
    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing timesheet date: $e");
      timesheetDate1 = DateTime.now(); // Fallback to current date if parsing fails
    }

    final month = timesheetDate1.month;
    final year = timesheetDate1.year;
    final daysInRange = initializeDateRange(month, year);

    int workingDays = daysInRange.where((date) => !isWeekend(date)).length;

    // Use calculateCategoryHours1 which already handles capping
    double cappedCategoryHours = calculateCategoryHours1(category);

    // Check for division by zero
    return (workingDays * 8) > 0 ? (cappedCategoryHours / (workingDays * 8)) * 100 : 0;
  }


  double calculateCategoryHours(String category) {
    // Parse the timesheet date
    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing timesheet date: $e");
      timesheetDate1 = DateTime.now(); // Fallback to current date if parsing fails
    }

    // Extract timesheet entries
    final attendanceData = widget.timesheetData['timesheetEntries'] as List<dynamic>?;

    // Determine the month and year
    final month = timesheetDate1.month;
    final year = timesheetDate1.year;

    // Initialize the date range
    final daysInRange = initializeDateRange(month, year);

    // Calculate total hours
    double totalHours = 0;
    for (var date in daysInRange) {
      if (!isWeekend(date)) {
        for (var entry in attendanceData ?? []) {
          if (entry is Map<String, dynamic>) {
            try {
              DateTime attendanceDate = DateFormat('dd-MMMM-yyyy').parse(entry['date']);
              if (attendanceDate.year == date.year &&
                  attendanceDate.month == date.month &&
                  attendanceDate.day == date.day &&
                  entry['offDay'] == true &&
                  (entry['durationWorked'] as String?)?.toLowerCase() == category.toLowerCase()) {
                double? hours = entry['noOfHours'] as double?;
                if (hours != null) {
                  totalHours += hours;
                }
              }
            } catch (e) {
              print("Error parsing attendance entry or calculating hours: $e");
            }
          }
        }
      }
    }

    return totalHours;
  }




  // pw.Widget _buildTimesheetTable1(pw.Context context) {
  //   DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
  //   try {
  //     timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
  //   } catch (e) {
  //     print("Error parsing date: $e");
  //   }
  //
  //   //final daysInRange = getDaysInRange(timesheetDate1);
  //   final projectName = widget.timesheetData['projectName'] ?? 'N/A';
  //   final month = DateFormat('MM').format(timesheetDate1);
  //   final year = DateFormat('yyyy').format(timesheetDate1);
  //   final daysInRange = initializeDateRange(int.parse(month),int.parse(year));
  //   // Data for the table
  //   final tableHeaders = <String>[
  //     'Project Name',
  //     ...daysInRange.map((date) => DateFormat('dd').format(date)).toList(),
  //     'Total Hours',
  //     '%'
  //   ];
  //
  //
  //   List<List<String>> allRows = [];
  //   final data = (widget.timesheetData['timesheetEntries'] as List).cast<Map<String, dynamic>>();
  //
  //
  //
  //   // Project Data Row
  //   final projectData = [
  //     projectName ?? '',
  //     ...daysInRange.map((date) {
  //       return _getDurationForDate3(
  //           date, projectName, projectName,data)
  //           .round()
  //           .toString(); // No rounding here
  //     }).toList(),
  //
  //     '0',
  //     // Placeholder for Total Hours
  //     '0%'
  //     // Placeholder for Percentage
  //
  //
  //   ];
  //
  //
  //
  //   allRows.add(projectData); // Add project data to allRows
  //
  //   // Out-of-office Rows
  //   final outOfOfficeCategories = [
  //     'Annual leave',
  //     'Holiday',
  //     'Paternity',
  //     'Maternity'
  //   ];
  //   final outOfOfficeData = outOfOfficeCategories.map((category) {
  //     final rowData = [
  //       category,
  //       ...daysInRange.map((date) {
  //         return _getDurationForDate3(date, selectedProjectName, category)
  //             .round()
  //             .toString(); // No rounding here
  //       }).toList(),
  //       // calculateCategoryHours(category).toStringAsFixed(2), // Calculate total for category, 2 decimal places
  //       // '${calculateCategoryPercentage(category).toStringAsFixed(1)}%'
  //       // calculateCategoryHours(category).round().toString(),  // Round category hours
  //       // '${calculateCategoryPercentage(category).round()}%' // Round percentage
  //       '0',
  //       // Placeholder for Total Hours
  //       '0%'
  //       // Placeholder for Percentage
  //     ];
  //     allRows.add(rowData); // Add each category row to allRows
  //     return rowData;
  //   }).toList();
  //
  //   // Now calculate totals AFTER rounding for ALL rows (including project data)
  //   for (List<String> row in allRows) {
  //     double rowTotal = 0;
  //     for (int i = 1; i <=
  //         daysInRange.length; i++) { // Sum the rounded daily hours
  //       rowTotal += double.tryParse(row[i]) ?? 0;
  //     }
  //
  //     row[daysInRange.length + 1] =
  //         rowTotal.round().toString(); // Rounded total hours
  //
  //     int workingDays = daysInRange
  //         .where((date) => !isWeekend(date))
  //         .length;
  //     double percentage = (workingDays * 8) != 0 ? (rowTotal /
  //         (workingDays * 8)) * 100 : 0;
  //     row[daysInRange.length + 2] =
  //         percentage.round().toString() + '%'; // Rounded percentage
  //   }
  //
  //
  //   // Total Row Calculation (rounding to whole numbers)
  //   List<String> totalRow = [
  //     'Total',
  //     ...List.generate(daysInRange.length, (index) => '0'),
  //     '0',
  //     '0%'
  //   ];
  //   for (int i = 1; i <= daysInRange.length; i++) { // Iterate over day columns
  //     double dayTotal = 0; // Use double to accumulate, round later
  //     for (List<String> row in allRows) {
  //       dayTotal += double.tryParse(row[i]) ?? 0.0;
  //     }
  //     totalRow[i] =
  //         dayTotal.round().toString(); // Round day total before storing
  //   }
  //
  //   // Calculate grand total and percentage (using rounded day totals)
  //   int grandTotalHours = 0;
  //   for (int i = 1; i <= daysInRange.length; i++) {
  //     grandTotalHours += int.parse(totalRow[i]);
  //   }
  //   totalRow[daysInRange.length + 1] =
  //       grandTotalHours.toString(); // Grand total
  //
  //   int workingDays = daysInRange
  //       .where((date) => !isWeekend(date))
  //       .length;
  //   double grandPercentage = (workingDays * 8) > 0 ? (grandTotalHours /
  //       (workingDays * 8)) * 100 : 0;
  //   totalRow[daysInRange.length + 2] =
  //       grandPercentage.round().toString() + '%'; // Round percentage
  //
  //
  //   // Build the table
  //   return pw.Table(
  //     border: pw.TableBorder.all(),
  //     columnWidths: {
  //       0: const pw.FixedColumnWidth(250),
  //       for (int i = 1; i <= daysInRange.length; i++) i: const pw
  //           .FixedColumnWidth(80),
  //       // Fixed width for date columns
  //       daysInRange.length + 1: const pw.FixedColumnWidth(200),
  //       // Fixed width for "Total Hours"
  //       daysInRange.length + 2: const pw.FixedColumnWidth(200),
  //       // Fixed width for "Percentage"
  //     },
  //     children: [
  //       // Header row
  //       pw.TableRow(
  //         decoration: pw.BoxDecoration(color: PdfColors.grey300),
  //         children: tableHeaders
  //             .map((header) =>
  //             pw.Center(
  //               child: pw.Padding(
  //                 padding: const pw.EdgeInsets.all(1.0),
  //                 child: pw.Text(
  //                   header,
  //                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //                 ),
  //               ),
  //             ))
  //             .toList(),
  //       ),
  //       // // Project data row
  //       // pw.TableRow(
  //       //   children: projectData
  //       //       .map((data) => pw.Center(
  //       //     child: pw.Padding(
  //       //       padding: const pw.EdgeInsets.all(1.0),
  //       //       child: pw.Text(data),
  //       //     ),
  //       //   ))
  //       //       .toList(),
  //       // ),
  //       // // Out-of-office rows
  //       // ...outOfOfficeData.map(
  //       //       (rowData) => pw.TableRow(
  //       //     children: rowData
  //       //         .map((data) => pw.Center(
  //       //       child: pw.Padding(
  //       //         padding: const pw.EdgeInsets.all(1.0),
  //       //         child: pw.Text(data),
  //       //       ),
  //       //     ))
  //       //         .toList(),
  //       //   ),
  //       // ),
  //
  //       // Total Row
  //
  //       // // Project data row
  //       // pw.TableRow(
  //       //   children: _buildRowChildrenWithWeekendColor(projectData),
  //       // ),
  //       //
  //       // // Out-of-office rows
  //       // ...outOfOfficeData.map(
  //       //       (rowData) => pw.TableRow(
  //       //       children: _buildRowChildrenWithWeekendColor(rowData) //use method to create the cells for the row
  //       //   ),
  //       // ),
  //
  //
  //       // Combined loop for project and out-of-office rows, including Total row:
  //       ...allRows.map((rowData) {
  //         return pw.TableRow(
  //           children: rowData
  //               .asMap()
  //               .entries
  //               .map((entry) { // Use asMap().entries to get index
  //             final i = entry.key;
  //             final data = entry.value;
  //             final isWeekendColumn = i > 0 && i <= daysInRange.length &&
  //                 isWeekend(daysInRange[i - 1]);
  //
  //             return pw.Container(
  //               color: isWeekendColumn ? PdfColors.grey900 : null,
  //               // Grey for weekend cells
  //               padding: const pw.EdgeInsets.all(1.0),
  //               alignment: pw.Alignment.center,
  //               // Center the text
  //               child: pw.Text(data),
  //             );
  //           }).toList(),
  //         );
  //       }).toList(),
  //
  //
  //       // Total Row (updated to use rounded values)
  //       pw.TableRow(
  //         decoration: const pw.BoxDecoration(color: PdfColors.grey300),
  //         children: totalRow.map((data) => pw.Center(child: pw.Padding(
  //             padding: const pw.EdgeInsets.all(1.0),
  //             child: pw.Text(data,
  //                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))))
  //             .toList(),
  //       ),
  //     ],
  //   );
  // }
  pw.Widget _buildTimesheetTable(pw.Context context) {
    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now(); // Use current date as a fallback
    }

    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange = initializeDateRange(int.parse(month), int.parse(year)).cast<DateTime>();
    final data = widget.timesheetData['timesheetEntries'].cast<Map<String, dynamic>>();


    // Store row data and totals
    final rowData = <String, List<double>>{};  // Simplified data structure
    final categories = ['Annual leave', 'Holiday', 'Paternity', 'Maternity'];

    // Helper function to build table cells with weekend styling
    pw.Widget buildTableCell(String text, bool isWeekend) {
      return pw.Container(
        width: 80, // Fixed width for data cells
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.all(1.0),
        color: isWeekend ? PdfColors.grey900 : null,
        child: pw.Text(text),
      );
    }


    // Build Table Rows (including data and totals calculation)
    List<pw.TableRow> tableRows = [];
    for (final category in [projectName, ...categories]) {
      List<pw.Widget> rowChildren = [];
      List<double> rowDataList = []; // Accumulate data for each category

      rowChildren.add(pw.Container(width: 250, alignment: pw.Alignment.centerLeft, padding: const pw.EdgeInsets.all(1.0), child: pw.Text(category)));


      double rowTotal = 0;

      for (var date in daysInRange) {
        double duration = _getDurationForDate3(date, projectName, category, data);
        rowTotal += duration;
        rowDataList.add(duration);
        rowChildren.add(buildTableCell(duration.round().toString(), isWeekend(date)));
      }

      rowData[category] = rowDataList;  // Store data row for totals calculation
      rowChildren.add(pw.Container(width: 200, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text(rowTotal.round().toString())));


      int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
      double percentage = (workingDays * 8) > 0 ? (rowTotal / (workingDays * 8)) * 100 : 0;
      rowChildren.add(pw.Container(width: 200, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('${percentage.round()}%')));
      tableRows.add(pw.TableRow(children: rowChildren));
    }


    // Total Row
    List<pw.Widget> totalRowChildren = [pw.Container(width: 250, alignment: pw.Alignment.centerLeft, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))];
    double grandTotalHours = 0;
    for (int i = 0; i < daysInRange.length; i++) {
      double dayTotal = 0;
      rowData.forEach((_, durations) {
        dayTotal += durations[i]; // Accessing by index is safe now
      });

      totalRowChildren.add(pw.Container(width:80, color: isWeekend(daysInRange[i]) ? PdfColors.grey900 : PdfColors.grey300, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text(dayTotal.round().toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))); // Added bold style and background color
      grandTotalHours += dayTotal;
    }


    int workingDaysTotal = daysInRange.where((date) => !isWeekend(date)).length;
    double grandPercentage = (workingDaysTotal * 8) > 0 ? (grandTotalHours / (workingDaysTotal * 8)) * 100 : 0;


    totalRowChildren.add(pw.Container(width: 200, color: PdfColors.grey300, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text(grandTotalHours.round().toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold))));
    totalRowChildren.add(pw.Container(width: 200, color: PdfColors.grey300, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('${grandPercentage.round()}%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))));
    tableRows.add(pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey300), children: totalRowChildren));




    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FixedColumnWidth(250),
        for (int i = 1; i <= daysInRange.length; i++) i: const pw.FixedColumnWidth(80),
        daysInRange.length + 1: const pw.FixedColumnWidth(200),
        daysInRange.length + 2: const pw.FixedColumnWidth(200),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Container(width: 250, alignment: pw.Alignment.centerLeft, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('Project Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            ...daysInRange.map((date) => pw.Container(width: 80, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), color: isWeekend(date) ? PdfColors.grey900 : PdfColors.grey300,child: pw.Text(DateFormat('dd').format(date), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))).toList(), // Added bold style and background color
            pw.Container(width: 200, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('Total Hours', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Container(width: 200, alignment: pw.Alignment.center, padding: const pw.EdgeInsets.all(1.0), child: pw.Text('%', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),


          ],
        ),


        ...tableRows,
      ],
    );
  }




  List<pw.Widget> _buildRowChildrenWithWeekendColor1(pw.Context context, List<String> rowData,List<DateTime> daysInRange) {

    return rowData.asMap().entries.map((entry) {
      final i = entry.key;
      final data = entry.value;
      final isWeekendColumn = i > 0 && i <= daysInRange.length && isWeekend(daysInRange[i - 1]); // Check for weekend columns

      return pw.Container(
        color: isWeekendColumn ? PdfColors.grey900 : null, // Grey for weekend cells
        padding: const pw.EdgeInsets.all(1.0),
        alignment: pw.Alignment.center, // Center the text
        child: pw.Text(data),
      );

    }).toList();
  }

  List<pw.Widget> _buildRowChildrenWithWeekendColor(pw.Context context, List<String> rowData, List<DateTime> daysInRange) {  // Correct type here
    return rowData.asMap().entries.map((entry) {
      final i = entry.key;
      final data = entry.value;
      final isWeekendColumn = i > 0 && i <= daysInRange.length && isWeekend(daysInRange[i - 1]);

      return pw.Container(
        color: isWeekendColumn ? PdfColors.grey900 : null,
        padding: const pw.EdgeInsets.all(1.0),
        alignment: pw.Alignment.center,
        child: pw.Text(data),
      );
    }).toList();
  }


  // ... (rest of the code)


  //timesheet_details.dart
  double _getDurationForDate3(DateTime date, String? projectName, String category, List<Map<String, dynamic>> attendanceData) {
    double totalHoursForDate = 0;

    for (var attendance in attendanceData) {
      try {
        DateTime attendanceDate = DateFormat('yyyy-MM-dd').parse(attendance['date']);

        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName) {
            if (!attendance['offDay']) {
              double hours = attendance['noOfHours'];
              totalHoursForDate += hours > 8 ? 8 : hours; // Cap at 8

            }
          } else {
            if (attendance['offDay'] &&
                attendance['durationWorked']?.toLowerCase() == category.toLowerCase()) {
              double hours = attendance['noOfHours'];
              totalHoursForDate += hours > 8 ? 8 : hours; // Cap at 8

            }
          }
        }
      } catch (e) {
        print("Error processing attendance data: $e");
      }
    }
    return totalHoursForDate;
  }



  Map<String, double> _calculateRowTotals1(List<String> rowData, List<DateTime> daysInRange) {

    double rowTotal = 0;
    for (int i = 1; i <= daysInRange.length; i++) {
      rowTotal += double.tryParse(rowData[i]) ?? 0;

    }
    int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
    double percentage = (workingDays * 8) != 0 ? (rowTotal / (workingDays * 8)) * 100 : 0;



    return {
      'totalHours': rowTotal.roundToDouble(),
      'percentage': percentage.roundToDouble(),
    };

  }

  Map<String, double> _calculateRowTotals(List<String> rowData, List<DateTime> daysInRange) { // Correct type here
    double rowTotal = 0;
    for (int i = 1; i <= daysInRange.length; i++) {
      rowTotal += double.tryParse(rowData[i]) ?? 0;
    }

    int workingDays = daysInRange.where((date) => !isWeekend(date)).length;
    double percentage = (workingDays * 8) != 0 ? (rowTotal / (workingDays * 8)) * 100 : 0;


    return {
      'totalHours': rowTotal,
      'percentage': percentage,
    };
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

    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    //final daysInRange = getDaysInRange(timesheetDate);
    // final daysInRange = getDaysInRange(timesheetDate);
    final staffName1 = widget.timesheetData['staffName'] ?? 'N/A';

    final staffSignature = widget.timesheetData['staffSignature']??'N/A';
    print("StaffSignature ===${supervisorData['staffSignature']!}");

    final staffSig = (supervisorData['staffSignature'] != null && supervisorData['staffSignature']!.isNotEmpty) ? await networkImageToByte(supervisorData['staffSignature']!) : null;

    final coordSig = (supervisorData['projectCoordinatorSignature'] != null && supervisorData['projectCoordinatorSignature']!.isNotEmpty) ? await networkImageToByte(supervisorData['projectCoordinatorSignature']!) : null;


    final caritasSig = (supervisorData['caritasSupervisorSignature'] != null && supervisorData['caritasSupervisorSignature']!.isNotEmpty) ? await networkImageToByte(supervisorData['caritasSupervisorSignature']!) : null;


    // Fetch names, providing fallbacks for potentially missing values
    final staffName = supervisorData['staffName']?.toUpperCase() ?? 'UNKNOWN';
    final projectCoordinatorName = supervisorData['projectCoordinatorName']?.toUpperCase() ?? 'UNKNOWN';
    final caritasSupervisorName = supervisorData['caritasSupervisorName']?.toUpperCase() ?? 'UNKNOWN';



    final staffSignatureDate = supervisorData['staffSignatureDate'] ?? formattedDate;
    final facilitySupervisorSignatureDate = supervisorData['facilitySupervisorSignatureDate'] ?? 'UNKNOWN';
    final caritasSupervisorSignatureDate = supervisorData['caritasSupervisorSignatureDate'] ?? 'UNKNOWN';



    // Return the list of signature columns
    return [
      _buildSingleSignatureColumn('Name of Staff', staffName, staffSig, staffSignatureDate),
      _buildSingleSignatureColumn('Name of Project Coordinator', projectCoordinatorName, coordSig,facilitySupervisorSignatureDate ),
      _buildSingleSignatureColumn('Name of Caritas Supervisor', caritasSupervisorName, caritasSig,caritasSupervisorSignatureDate),

    ];
  }


  pw.Widget _buildSingleSignatureColumn(String title, String name, Uint8List? imageBytes, String date) {

    return  pw.Column(
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
            child: imageBytes != null ? pw.Image(pw.MemoryImage(imageBytes)) : pw.Text("Signature"), // Placeholder if no image
          ),

        ),
        pw.SizedBox(height: 10),
        pw.Text("Date: $date"),

      ],
    );


  }



  pw.Widget _buildSignatureSection(pw.Context context, List<pw.Widget> signatureColumns) {

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Signature & Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: signatureColumns, // Use the pre-built signature columns

          ),
        ]
    );

  }

  Future<void> _uploadCaritasSupervisorSignatureAndSync() async {

    List<Uint8List> images =
        await adapter.getSignatureImages() ?? [];
    String bucketName = "attendanceapp-a6853.appspot.com";
    String storagePath =
        'signatures/${selectedFirebaseId}_signature.jpg';

    if (images.isNotEmpty) {
      await firebase_storage
          .FirebaseStorage.instance
          .ref('$bucketName/$storagePath')
          .putData(images.first)
          .then((value) async {
        String downloadURL =
        await firebase_storage
            .FirebaseStorage.instance
            .ref('$bucketName/$storagePath')
            .getDownloadURL();
        //Save Profile Pic link to firebase
        await FirebaseFirestore.instance
            .collection("Staff")
            .doc("$selectedFirebaseId")
            .update({
          "signatureLink": downloadURL,
        }).then((_) async {
          final bioModel = BioModel()..signatureLink = downloadURL;
          await IsarService().updateBioSignatureLink(2, bioModel, false);
          setState(() {
            _caritasSupervisorSignatureLink = downloadURL;
          });
        });

        final dateFormat = DateFormat('MMMM dd, yyyy');
        DateTime timesheetDate;
        try {
          timesheetDate = dateFormat.parse(widget.timesheetData['date']);
        } catch (e) {
          print("Error parsing date: $e");
          timesheetDate = DateTime.now();
        }


        DateTime timesheetDate1;
        try {
          timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
        } catch (e) {
          print("Error parsing date: $e");
          timesheetDate1 = DateTime.now();
        }

        final staffId = widget.timesheetData['staffId'] ?? 'N/A';

        String monthYear = DateFormat('MMMM_yyyy').format(timesheetDate1);

        try {

          QuerySnapshot snap = await FirebaseFirestore.instance
              .collection("Staff")
              .where("id", isEqualTo: staffId)
              .get();

          Map<String, dynamic> timesheetData = {

            'caritasSupervisorSignature': downloadURL,
            'caritasSupervisorSignatureDate':DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            'caritasSupervisorSignatureStatus':"Approved",

          };


          await FirebaseFirestore.instance
              .collection("Staff")
              .doc(snap.docs[0].id)
              .collection("TimeSheets")
              .doc(monthYear)
              .set(timesheetData, SetOptions(merge: true));



          print('Timesheet saved to Firestore');
          Fluttertoast.showToast(
            msg: "Timesheet Signed",
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


        Fluttertoast.showToast(msg: "Signature Updated successfully!");
      });



    } else{
      // Handle the case where no image is selected (e.g., skip image upload)
      print("No image selected. Skipping image upload.");
      Fluttertoast.showToast(
        msg: "No image selected. Skipping image upload.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black54,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // if (_signatureImage == null) {
    //   Fluttertoast.showToast(msg: "Please select a signature image.");
    //   return;
    // }
    //
    // try {
    //   // Upload image to Firebase Storage
    //   final storageRef = FirebaseStorage.instance.ref().child(
    //       'signatures/${firebaseAuthId}_signature.jpg'); // Use a unique filename
    //   final uploadTask = await storageRef.putFile(_signatureImage!);
    //   final downloadUrl = await uploadTask.ref.getDownloadURL();
    //
    //   // Update signatureLink in Isar and Firebase
    //   final bioModel = BioModel()..signatureLink = downloadUrl;
    //   await IsarService().updateBioSignatureLink(2, bioModel, false);
    //
    //   await FirebaseFirestore.instance
    //       .collection("Staff")
    //       .doc(firebaseAuthId)
    //       .update({'signatureLink': downloadUrl});
    //
    //   setState(() {
    //     _signatureLink = downloadUrl;
    //     _signatureImage = null; // Clear the image after upload
    //     newSynced = true;
    //     isSynced = true;
    //   });
    //
    //   Fluttertoast.showToast(msg: "Signature saved successfully!");
    // } catch (e) {
    //   // Handle error
    //   print('Error uploading signature: $e');
    //   Fluttertoast.showToast(msg: "Error saving signature.");
    // }
  }

  // Helper function to generate the list of days from the 19th of the previous month to the 20th of the current month.
  List<DateTime> getDaysInRange(DateTime timesheetDate) {
    DateTime startDate = DateTime(timesheetDate.year, timesheetDate.month - 1, 19);
    DateTime endDate = DateTime(timesheetDate.year, timesheetDate.month, 20);

    List<DateTime> days = [];
    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      days.add(date);
    }
    return days;
  }

  // Retrieves hours for a specific date, project, and category.
  String getHoursForDate(DateTime date, String projectName, String category) {
    final entries = widget.timesheetData['timesheetEntries'] as List?;
    if (entries != null) {
      for (final entry in entries) {
        final entryDate = DateTime.parse(entry['date']);
        if (entryDate.year == date.year &&
            entryDate.month == date.month &&
            entryDate.day == date.day &&
            entry['projectName'] == projectName &&
            entry['status'] == category) {
          return entry['noOfHours'].toString();
        }
      }
    }
    return "";
  }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    DatabaseAdapter adapter = HiveService();
    return adapter.getSignatureImages();
  }

  Future<void> _rejectTimesheet(String staffId, String monthYear,String selectedBioStaffCategory) async {
    String rejectionReason = "";
    bool isValidReason = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Timesheet'),
          content: TextFormField(
            onChanged: (value) {
              rejectionReason = value;
              isValidReason = value.trim().isNotEmpty; // Basic validation
            },
            decoration: InputDecoration(
              labelText: 'Reason for Rejection',
              hintText: 'Enter reason for rejecting this timesheet',
              border: const OutlineInputBorder(),
              errorText: !isValidReason && rejectionReason.isNotEmpty ? 'Please enter a valid reason' : null,
            ),
            maxLines: 3, // Allow multiple lines for reason
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value == null || value.isEmpty ? 'Please enter a reason' : null,
          ),


          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: !isValidReason // Enable only if reason is valid
                  ? () async {
                try {
                  if(selectedBioStaffCategory == "Facility Supervisor"){
                    await FirebaseFirestore.instance
                        .collection("Staff")
                        .doc(staffId)
                        .collection("TimeSheets")
                        .doc(monthYear)
                        .update({
                      'facilitySupervisorSignatureStatus': 'Rejected',
                      'facilitySupervisorRejectionReason': rejectionReason, // Save reason
                    });
                  }else {
                    await FirebaseFirestore.instance
                        .collection("Staff")
                        .doc(staffId)
                        .collection("TimeSheets")
                        .doc(monthYear)
                        .update({
                      'caritasSupervisorSignatureStatus': 'Rejected',
                      'caritasSupervisorRejectionReason': rejectionReason, // Save reason
                    });
                  }

                  // Optionally update facilitySupervisorSignatureStatus if needed

                  Navigator.of(context).pop(); // Close dialog


                  Fluttertoast.showToast(
                    msg: "Timesheet Rejected",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.black54,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  // Navigate to PendingApproval page *after* successful update
                  Navigator.pushReplacement(  // Use pushReplacement to avoid going back to details
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingApprovalsPage(service: IsarService(),), // Navigate to your PendingApproval page

                    ),
                  ).then((_) => _fetchPendingApprovals()); // Refresh the list after rejection
                } catch (e) {
                  print('Error rejecting timesheet: $e');
                  Fluttertoast.showToast(msg: 'Error rejecting timesheet');
                }
              }
                  : null,
              child: const Text('Save'), // Disable if invalid
            ),
          ],
        );
      },
    );
  }



  Future<void> _loadBioData() async {
    bioData = await IsarService().getBioData();
    if (bioData != null) { // Check if bioData is not null before accessing its properties
      setState(() {
        selectedBioFirstName = bioData!.firstName;  // Use the null-aware operator (!)
        selectedBioLastName = bioData!.lastName;    // Use the null-aware operator (!)
        selectedBioDepartment = bioData!.department; // Initialize selectedBioDepartment
        selectedBioState = bioData!.state;
        selectedBioDesignation = bioData!.designation;
        selectedBioLocation = bioData!.location;
        selectedBioStaffCategory = bioData!.staffCategory;
        selectedSignatureLink = bioData!.signatureLink;
        selectedBioEmail = bioData!.emailAddress;
        selectedBioPhone = bioData!.mobile;

        selectedFirebaseId = bioData!.firebaseAuthId;// Initialize selectedBioState
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
    try{
      facilitySupervisorSignature = widget.timesheetData['facilitySupervisorSignature'];
      caritasSupervisorSignature = widget.timesheetData['caritasSupervisorSignature'];
    }catch(e){}
  }

  Future<void> _facilitySupervisorSignatureToFirestore() async {
    if (selectedSignatureLink == null) {
      // Handle case where signature is not present (e.g., show a message)
      Fluttertoast.showToast(
        msg: "Cannot send timesheet without Project Coordinator Signature.",
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

    final dateFormat = DateFormat('MMMM dd, yyyy');
    DateTime timesheetDate;
    try {
      timesheetDate = dateFormat.parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate = DateTime.now();
    }


    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }
    //
    // final daysInRange = getDaysInRange(timesheetDate);
    // final staffName = widget.timesheetData['staffName'] ?? 'N/A';
    final staffId = widget.timesheetData['staffId'] ?? 'N/A';
    // final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    // final facilitySupervisorName = widget.timesheetData['facilitySupervisor'] ?? 'N/A';
    // final caritasSupervisorName = widget.timesheetData['caritasSupervisor'] ?? 'N/A';
    // final timeSheetDate = widget.timesheetData['date'] ?? 'N/A';
    // final grandTotalHours = calculateGrandTotalHours();
    final staffSignature = widget.timesheetData['staffSignature'] ?? 'N/A';
    final facilitySupervisorSignature = widget.timesheetData['facilitySupervisorSignature'] ?? 'N/A';
    final caritasSupervisorSignature = widget.timesheetData['caritasSupervisorSignature'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    String monthYear = DateFormat('MMMM_yyyy').format(timesheetDate1);

    try {
      // Construct the timesheet data to be saved



      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: staffId)
          .get();

      Map<String, dynamic> timesheetData = {

        'facilitySupervisorSignature': selectedSignatureLink,
        'facilitySupervisorSignatureDate':DateFormat('MMMM dd, yyyy').format(DateTime.now()),
        'facilitySupervisorSignatureStatus':"Approved",

      };


      await FirebaseFirestore.instance
          .collection("Staff")
          .doc(snap.docs[0].id)
          .collection("TimeSheets")
          .doc(monthYear)
          .set(timesheetData, SetOptions(merge: true));



      print('Timesheet saved to Firestore');
      Fluttertoast.showToast(
        msg: "Timesheet Signed",
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

  Future<void> _caritasSupervisorSignatureToFirestore() async {
    if (selectedSignatureLink == null) {
      // Handle case where signature is not present (e.g., show a message)
      Fluttertoast.showToast(
        msg: "Cannot send timesheet without CARITAS Supervisor Signature.",
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

    final dateFormat = DateFormat('MMMM dd, yyyy');
    DateTime timesheetDate;
    try {
      timesheetDate = dateFormat.parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate = DateTime.now();
    }


    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    final staffId = widget.timesheetData['staffId'] ?? 'N/A';

    final staffSignature = widget.timesheetData['staffSignature'] ?? "N/A" ;
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    String monthYear = DateFormat('MMMM_yyyy').format(timesheetDate1);

    try {
      // Construct the timesheet data to be saved



      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Staff")
          .where("id", isEqualTo: staffId)
          .get();

      Map<String, dynamic> timesheetData = {

        'caritasSupervisorSignature': selectedSignatureLink,
        'caritasSupervisorSignatureDate':DateFormat('MMMM dd, yyyy').format(DateTime.now()),
        'facilitySupervisorSignatureStatus':"Approved",

      };


      await FirebaseFirestore.instance
          .collection("Staff")
          .doc(snap.docs[0].id)
          .collection("TimeSheets")
          .doc(monthYear)
          .set(timesheetData, SetOptions(merge: true));



      print('Timesheet saved to Firestore');
      Fluttertoast.showToast(
        msg: "Timesheet Signed",
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

  // Checks if a date falls on a weekend.
  bool isWeekend(DateTime date) => date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

  // Computes total hours worked for a specific category.
  double getCategoryHours(String category) {
    return (widget.timesheetData['timesheetEntries'] as List?)
        ?.where((entry) => entry['status'] == category)
        .fold(0.0, (sum, entry) => sum! + entry['noOfHours']) ??
        0.0;
  }

  // Calculates the percentage of total hours for a specific category.
  double getCategoryPercentage(String category) {
    final grandTotal = calculateGrandTotalHours();
    if (grandTotal == 0) return 0;
    return (getCategoryHours(category) / grandTotal) * 100;
  }

  // Computes the total hours across all categories.
  double calculateGrandTotalHours() {
    return (widget.timesheetData['timesheetEntries'] as List?)
        ?.fold<double>(0.0, (sum, entry) => sum + entry['noOfHours']) ??
        0.0;
  }

  // Calculates hours for a specific project.
  double calculateTotalHours(String projectName) {
    return (widget.timesheetData['timesheetEntries'] as List?)
        ?.where((entry) => entry['status'] == projectName)
        .fold<double>(0, (sum, entry) => sum + entry['noOfHours']) ??
        0.0;
  }

  // Computes the percentage worked for a specific project.
  double calculatePercentageWorked(String projectName) {
    final grandTotal = calculateGrandTotalHours();
    if (grandTotal == 0) return 0;
    return (calculateTotalHours(projectName) / grandTotal) * 100;
  }

  double calculatePercentageWorked1() {
    DateTime timesheetDate1 = DateTime.now(); // Initialize with a default value
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
    }

    //final daysInRange = getDaysInRange(timesheetDate1);
    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange = initializeDateRange(int.parse(month), int.parse(year)).cast<DateTime>();


    int workingDays = daysInRange
        .where((date) => !isWeekend(date))
        .length;
    double cappedTotalHours = calculateTotalHours1(); // Use capped total hours
    return (workingDays * 8) > 0
        ? (cappedTotalHours / (workingDays * 8)) * 100
        : 0;
  }

  // Creates the table header row.
  Widget buildTableHeader(List<DateTime> daysInRange) {
    return Row(
      children: [
        _buildTableCell('Project Name', Colors.blue.shade100, fontWeight: FontWeight.bold),
        ...daysInRange.map((date) => _buildTableCell(DateFormat('dd MMM').format(date),
            isWeekend(date) ? Colors.grey.shade300 : Colors.blue.shade100,
            fontWeight: FontWeight.bold)),
        _buildTableCell('Total Hours', Colors.blue.shade100, fontWeight: FontWeight.bold),
        _buildTableCell('Percentage', Colors.blue.shade100, fontWeight: FontWeight.bold),
      ],
    );
  }

  // Builds a row for a project with hours filled in for each day.
  Widget buildProjectRow(String projectName, List<DateTime> daysInRange) {
    final totalHours = calculateTotalHours(projectName);
    final percentageWorked = calculatePercentageWorked(projectName);
    return Row(
      children: [
        _buildTableCell(projectName, Colors.white),
        ...daysInRange.map((date) => _buildTableCell(getHoursForDate(date, projectName, projectName),
            isWeekend(date) ? Colors.grey.shade300 : Colors.white)),
        _buildTableCell('$totalHours hrs', Colors.white, color: Colors.green, fontWeight: FontWeight.bold),
        _buildTableCell('${percentageWorked.toStringAsFixed(2)}%', Colors.white, color: Colors.green, fontWeight: FontWeight.bold),
      ],
    );
  }


  // Helper function to build a table cell.
  Widget _buildTableCell(String text, Color? backgroundColor, {Color? color, FontWeight? fontWeight}) {
    return Container(
      width: 100,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      color: backgroundColor,
      child: Text(text, style: TextStyle(color: color, fontWeight: fontWeight)),
    );
  }

  // Builds rows for each category with their hours and percentage.
  Widget buildCategoryRows(String projectName, List<DateTime> daysInRange) {
    final categories = [
      'Absent', 'Annual leave', 'Holiday', 'Other Leaves', 'Security Crisis',
      'Sick leave', 'Remote working', 'Sit at home', 'Trainings', 'Travel'
    ];
    return Column(
      children: categories.map((category) {
        final categoryHours = getCategoryHours(category);
        final categoryPercentage = getCategoryPercentage(category);

        return Row(
          children: [
            _buildTableCell(category, Colors.white, fontWeight: FontWeight.bold),
            ...daysInRange.map((date) => _buildTableCell(getHoursForDate(date, projectName, category),
                isWeekend(date) ? Colors.grey.shade300 : Colors.white)),
            _buildTableCell('${categoryHours.toStringAsFixed(2)} hrs', Colors.white, color: Colors.green, fontWeight: FontWeight.bold),
            _buildTableCell('${categoryPercentage.toStringAsFixed(2)}%', Colors.white, color: Colors.green, fontWeight: FontWeight.bold),
          ],
        );
      }).toList(),
    );
  }

  String _getDurationForDate(DateTime date, String? projectName, String category, List<Map<String, dynamic>> attendanceData) {
    double totalHoursForDate = 0;
    print("attendanceData === $attendanceData");

    for (var attendance in attendanceData) {
      try {
        // Access the 'date' key from the map.
        String dateString = attendance['date'] as String;  // Type cast to String
        print("dateString === $dateString");

        DateTime attendanceDate = DateFormat('yyyy-MM-dd').parse(dateString);

        if (attendanceDate.year == date.year &&
            attendanceDate.month == date.month &&
            attendanceDate.day == date.day) {
          if (category == projectName) {
            if (!attendance['offDay']) {  // Access 'offDay' from the map
              totalHoursForDate += attendance['noOfHours'] > 8.0 ? 8.0:attendance['noOfHours']  as double; // Access 'noOfHours'
            }

            // if (attendance['offDay'] == null ) {  // Access 'offDay' from the map
            //   totalHoursForDate += attendance['noOfHours'] as double; // Access 'noOfHours'
            // }
          } else {
            if (attendance['offDay'] as bool &&
                (attendance['durationWorked'] as String?)?.toLowerCase() == category.toLowerCase()) {
              totalHoursForDate += attendance['noOfHours'] > 8.0 ? 8.0:attendance['noOfHours']  as double;
            }
          }
        }
      } catch (e) {
        print("Error processing attendance data: $e"); // More general error message
      }
    }
    return totalHoursForDate.toStringAsFixed(2);
  }

  List initializeDateRange(int month, int year) {
    DateTime selectedMonthDate = DateTime(year, month, 1);
    var startDate = DateTime(selectedMonthDate.year, selectedMonthDate.month - 1, 20); //Start from the 19th of previous month
    var endDate = DateTime(selectedMonthDate.year, selectedMonthDate.month, 19);    //End on the 20th of current month


    var daysInRange1 = [];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      daysInRange1.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return daysInRange1;
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
        staffSignature1 = imageBytes; // Update staffSignature variable
      });
      //_saveTimesheetToFirestore(); // Save after signature is selected


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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    DateTime timesheetDate;
    try {
      timesheetDate = dateFormat.parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate = DateTime.now();
    }


    DateTime timesheetDate1;
    try {
      timesheetDate1 = DateFormat('MMMM dd, yyyy').parse(widget.timesheetData['date']);
    } catch (e) {
      print("Error parsing date: $e");
      timesheetDate1 = DateTime.now();
    }

    final daysInRange = getDaysInRange(timesheetDate);
    final staffName = widget.timesheetData['staffName'] ?? 'N/A';
    final staffId = widget.timesheetData['staffId'] ?? 'N/A';
    final projectName = widget.timesheetData['projectName'] ?? 'N/A';
    final facilitySupervisorName = widget.timesheetData['facilitySupervisor'] ?? 'N/A';
    final caritasSupervisorName = widget.timesheetData['caritasSupervisor'] ?? 'N/A';
    final timeSheetDate = widget.timesheetData['staffSignatureDate'] ?? 'N/A';
    final department = widget.timesheetData['department'] ?? 'N/A';
    final designation = widget.timesheetData['designation'] ?? 'N/A';
    final location = widget.timesheetData['location'] ?? 'N/A';
    final state = widget.timesheetData['state'] ?? 'N/A';
    final grandTotalHours = calculateGrandTotalHours();
    // final staffSignature = widget.timesheetData['staffSignature'] != null
    //     ? Uint8List.fromList(List<int>.from(widget.timesheetData['staffSignature']))
    //     : null;
   final staffSignature = widget.timesheetData['staffSignature'] ?? 'N/A';
    final monthYear = DateFormat('MMMM, yyyy').format(timesheetDate1);
    final filteredMonthYear = DateFormat('MMMM_yyyy').format(timesheetDate1);
    final month = DateFormat('MM').format(timesheetDate1);
    final year = DateFormat('yyyy').format(timesheetDate1);
    final daysInRange2 = initializeDateRange(int.parse(month),int.parse(year));




    return Scaffold(
      appBar: AppBar(
        title: const Text('Timesheet Details'),
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
      body: SingleChildScrollView(

        child: Column(
          children:[
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
                    Text('Name: $staffName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Department: $department',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Designation: $designation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * (MediaQuery
                          .of(context)
                          .size
                          .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('Location: $location', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * (MediaQuery
                        .of(context)
                        .size
                        .shortestSide < 600 ? 0.035 : 0.020),),),
                    const SizedBox(height: 5),
                    Text('State: $state', style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Month of Timesheet:',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:12),
                  ),
                  const SizedBox(width: 10),

                  Text(
                    monthYear,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection:Axis.horizontal,
             // padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [

                      //  buildProjectRow(projectName, daysInRange),
                      Column(
                        children: [
                          // Header Row
                          Row(
                            children: [
                              Container(
                                width: 150, // Set a width for the "Project Name" header
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.blue.shade100,
                                child: const Text(
                                  'Project Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...daysInRange2.map((date) {
                                return Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  color: isWeekend(date) ? Colors.grey.shade300 : Colors.blue.shade100,
                                  child: Text(
                                    DateFormat('dd MMM').format(date),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 100,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.blue.shade100,
                                child: const Text(
                                  'Percentage',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Container(
                                width: 150, // Keep the fixed width if you need it
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Text(projectName),
                              ),
                              ...daysInRange2.map((date) {
                                bool weekend = isWeekend(date);
                                String hours = _getDurationForDate(date, projectName, projectName!,widget.timesheetData['timesheetEntries'].cast<Map<String, dynamic>>() );
                                return Container(
                                  width: 50, // Set a fixed width for each day
                                  decoration: BoxDecoration(
                                    color: weekend ? Colors.grey.shade300 : Colors.white,
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      weekend
                                          ? const SizedBox.shrink() // No hours on weekends
                                          : Text(
                                        hours, // Placeholder, replace with Isar data
                                        style: const TextStyle(color: Colors.blueAccent),
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
                                  "${calculateTotalHours1()
                                      .round()} hrs",
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 100,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Text(
                                  '${calculatePercentageWorked1(
                                      ).round()}%',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),
                                ),
                              ),
                              ...List.generate(daysInRange2.length, (index) {
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
                          ...['Annual leave', 'Holiday', 'Paternity', 'Maternity'].map((category) {
                            // double outOfOfficeHours = calculateCategoryHours(category);
                            //double outOfOfficePercentage = calculateCategoryPercentage(category);
                            return Row(
                              children: [
                                Container(
                                  width: 150,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.white,
                                  child: Text(
                                    category,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...daysInRange2.map((date) {
                                  bool weekend = isWeekend(date);
                                  String offDayHours = _getDurationForDate(date, projectName, category,widget.timesheetData['timesheetEntries'].cast<Map<String, dynamic>>() );


                                  return Container(
                                    width: 50, // Set a fixed width for each day
                                    decoration: BoxDecoration(
                                      color: weekend ? Colors.grey.shade300 : Colors.white,
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        weekend
                                            ? const SizedBox.shrink() // No hours on weekends
                                            : Text(
                                          offDayHours, // Placeholder, replace with Isar data
                                          style: const TextStyle(color: Colors.blueAccent),
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
                                    //'${outOfOfficeHours.toStringAsFixed(2)} hrs',
                                    "${calculateCategoryHours1(category)
                                        .round()} hrs",
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.white,
                                  child: Text(
                                    //'${outOfOfficePercentage.toStringAsFixed(2)}%',
                                    '${calculateCategoryPercentage(category
                                    ).round()}%',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          // // Attendance Rows
                          //
                          Row(
                            children: [
                              Container(
                                width: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: const Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),
                                ),
                              ),
                              ...List.generate(daysInRange2.length, (index) {
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
                                  "${calculateGrandTotalHours1()
                                      .toStringAsFixed(0)} hrs",
                                  //'$totalGrandHours hrs',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 100,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Text(
                                  '${calculateGrandPercentageWorked()
                                      .round()}%',

                                  // '${grandPercentageWorked.toStringAsFixed(2)}%',

                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),



                        ],
                      ),
                      const Divider(),
                      // buildCategoryRows(projectName, daysInRange),
                      // Row(
                      //   children: [
                      //     _buildTableCell('Grand Total', Colors.grey, fontWeight: FontWeight.bold),
                      //     ...List.generate(daysInRange.length, (_) => SizedBox(width: 100)),
                      //     _buildTableCell('$grandTotalHours hrs', Colors.grey, fontWeight: FontWeight.bold),
                      //     _buildTableCell('100%', Colors.grey, fontWeight: FontWeight.bold),
                      //   ],
                      // ),

                    ],
                  ),
                ],
              ),
            ),

            //Signature and Details
            const Divider(),
            Text('Signature & Date', style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.050 : 0.030),)),
            const Divider(),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),
                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.25 : 0.25),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Name of Staff', style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.07 : 0.05)),
                            Text(
                              '${staffName.toUpperCase()}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.035 : 0.015),
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaLight",
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.13 : 0.10)),// Adjust path and size accordingly
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      // Signature of Staff
                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.35 : 0.35),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //  color: Colors.grey.shade200,
                        child: Column(
                          children: [
                            Text('Signature', style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                                bottom: 24,
                              ),
                              height: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                              width: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //color: Colors.grey.shade300,
                              ),
                              child: staffSignature != null? Image.network(staffSignature) :const Text('No signature available.'),
                            ),// Adjust path and size accordingly
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      // Date of Signature of Staff

                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.07 : 0.05)),
                            Text("$timeSheetDate", style: const TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.13 : 0.10)),
                          ],
                        ),
                      ),
                      SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),


                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.005 : 0.005)),
                  const Divider(),
                  //Second - Project Coordinator Section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),
                      //Name of Project Cordinator
                      Container(
                        width: MediaQuery.of(context).size.width *
                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.25),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //  color: Colors.grey.shade200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email of Project Cordinator
                            Text(
                              'Name of Project Coordinator',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width *
                                    (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.03 : 0.01),
                            ),

                            Text(
                              '${facilitySupervisorName.toUpperCase()}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.035 : 0.015),
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaLight",
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.005 : 0.005),
                            ),
                          ],
                        ),
                      ),


                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      //Signature of Project Cordinator
                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.35 : 0.35),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.grey.shade200,
                        child: Column(
                          children: [
                            Text('Signature', style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                            StreamBuilder<DocumentSnapshot>(
                              // Stream the supervisor signature
                              stream: FirebaseFirestore.instance
                                  .collection("Staff")
                                  .doc(staffId) // Replace with how you get the staff document ID
                                  .collection("TimeSheets")
                                  .doc(filteredMonthYear) // Replace monthYear with the timesheet document ID
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data() as Map<String, dynamic>;

                                  final facilitySupervisorSignature = data['facilitySupervisorSignature']; // Assuming this stores the image URL
                                  final facilitySupervisorSignatureStatus = data['facilitySupervisorSignatureStatus']; // Assuming you store the date



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


                                  else if(facilitySupervisorSignature == null && selectedSignatureLink ==null && selectedBioStaffCategory == "Facility Supervisor"){
                                    return GestureDetector(
                                      onTap: () {
                                        _pickImage();
                                      },

                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 24,
                                        ),
                                        height: MediaQuery.of(context).size.width *
                                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                        width: MediaQuery.of(context).size.width *
                                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          //color: Colors.grey.shade300,
                                        ),
                                        child: RefreshableWidget<List<Uint8List>?>(
                                          refreshCall: () async {
                                            return await _readImagesFromDatabase();
                                          },
                                          refreshRate: const Duration(seconds: 1),
                                          errorWidget: Icon(
                                            Icons.upload_file,
                                            size: 80,
                                            color: Colors.grey.shade300,
                                          ),
                                          loadingWidget: Icon(
                                            Icons.upload_file,
                                            size: 80,
                                            color: Colors.grey.shade300,
                                          ),
                                          builder: (context, value) {
                                            if (value != null && value.isNotEmpty) {
                                              return ListView.builder(
                                                itemCount: value.length,
                                                itemBuilder: (context, index) => Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 24,
                                                  ),
                                                  height: MediaQuery.of(context).size.width *
                                                      (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                                  width: MediaQuery.of(context).size.width *
                                                      (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    //color: Colors.grey.shade300,
                                                  ),
                                                  child: Image.memory(value.first),
                                                ),


                                              );
                                            } else {
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.upload_file,
                                                    size: MediaQuery.of(context).size.width *
                                                        (MediaQuery.of(context).size.shortestSide < 600 ? 0.075 : 0.05),
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    "Click to Upload Signature Image Here",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  else if(facilitySupervisorSignature == null && selectedSignatureLink !=null && selectedBioStaffCategory == "Facility Supervisor"){
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
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
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus (Awaiting Approval)",
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
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
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
                                                  "$facilitySupervisorSignatureStatus (Approved)",
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
                                  else if(facilitySupervisorSignature != null && selectedSignatureLink !=null && selectedBioStaffCategory == "Facility Supervisor" ){
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
                                        ),
                                        const SizedBox(height:8),
                                        facilitySupervisorSignatureStatus == "Pending"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.access_time, color: Colors.orange),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus (Awaiting Approval)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ):
                                        facilitySupervisorSignatureStatus == "Rejected"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.cancel, color: Colors.red),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        )
                                            :Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.check_circle, color: Colors.green),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus (Approved)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ),

                                      ],
                                    );
                                  }
                                  else if(facilitySupervisorSignature == null && facilitySupervisorSignatureStatus =="Pending" && selectedBioStaffCategory == "Facility Supervisor" ){
                                    return Column(
                                      children: [
                                        const Text("Awaiting Facility Supervisor Signature"),
                                        const SizedBox(height:8),
                                        facilitySupervisorSignatureStatus == "Pending"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.access_time, color: Colors.orange),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ):facilitySupervisorSignatureStatus == "Rejected"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.cancel, color: Colors.red),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        )
                                            :Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.check_circle, color: Colors.green),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ),


                                      ],
                                    );
                                  }
                                  else if (selectedBioStaffCategory == "Facility Supervisor") {
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
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
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$facilitySupervisorSignatureStatus (Awaiting Approval)",
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
                                                  "$facilitySupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : facilitySupervisorSignatureStatus == "Approved"
                                            ? Row(
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
                                                  "$facilitySupervisorSignatureStatus (Approved)",
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
                                  return const SizedBox.shrink();

                                }
                                } else {
                                  return const Text("Timesheet Yet to be submitted for Project Cordinator's Signature");
                                }
                              },
                            ),



                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      //Date of Project Signature Date

                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20.0),
                            StreamBuilder<DocumentSnapshot>(
                              // Stream the supervisor signature
                              stream: FirebaseFirestore.instance
                                  .collection("Staff")
                                  .doc(staffId) // Replace with how you get the staff document ID
                                  .collection("TimeSheets")
                                  .doc(filteredMonthYear) // Replace monthYear with the timesheet document ID
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data() as Map<String, dynamic>;

                                  final facilitySupervisorSignatureDate = data['facilitySupervisorSignatureDate']; // Assuming this stores the image URL
                                  final facilitySupervisorSignatureStatus = data['facilitySupervisorSignatureStatus']; // Assuming you store the date

                                  if (facilitySupervisorSignatureDate != null) {
                                    // caritasSupervisorSignature is a URL/path to the image
                                    return Text("$facilitySupervisorSignatureDate", style: const TextStyle(fontWeight: FontWeight.bold));

                                  }

                                  else {
                                    return Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold));

                                  }
                                } else {
                                  return const Text("Timesheet Yet to be submitted for Project Cordinator's Signature");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.005 : 0.005)),
                  const Divider(),
                  // Third - CARITAS Supervisor Section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width:MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02),),
                      // Name of CARITAS Supervisor
                      Container(
                        width: MediaQuery.of(context).size.width *
                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.25),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.grey.shade200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name of CARITAS Supervisor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width *
                                    (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.03 : 0.01),
                            ),
                            Text(
                              '${caritasSupervisorName.toUpperCase()}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.035 : 0.015),
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaLight",
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width *
                                  (MediaQuery.of(context).size.shortestSide < 600 ? 0.005 : 0.005),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      //Signature of CARITAS Supervisor
                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.35 : 0.35),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.grey.shade200,
                        child: Column(
                          children: [
                            Text('Signature', style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.040 : 0.020),)),
                            SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.02 : 0.02)),
                            StreamBuilder<DocumentSnapshot>(
                              // Stream the supervisor signature
                              stream: FirebaseFirestore.instance
                                  .collection("Staff")
                                  .doc(staffId) // Replace with how you get the staff document ID
                                  .collection("TimeSheets")
                                  .doc(filteredMonthYear) // Replace monthYear with the timesheet document ID
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data = snapshot.data!.data() as Map<String, dynamic>;

                                  final caritasSupervisorSignature = data['caritasSupervisorSignature']; // Assuming this stores the image URL
                                  final caritasSupervisorSignatureStatus = data['caritasSupervisorSignatureStatus']; // Assuming you store the date

                                  // if (caritasSupervisorSignature != null) {
                                  //   // caritasSupervisorSignature is a URL/path to the image
                                  //   return Container(
                                  //     margin: const EdgeInsets.only(
                                  //       top: 20,
                                  //       bottom: 24,
                                  //     ),
                                  //     height: MediaQuery.of(context).size.width *
                                  //         (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                  //     width: MediaQuery.of(context).size.width *
                                  //         (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                  //     alignment: Alignment.center,
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //       //color: Colors.grey.shade300,
                                  //     ),
                                  //     child: Image.network(caritasSupervisorSignature!),
                                  //   );
                                  //
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
                                  else if(caritasSupervisorSignature == null && selectedSignatureLink ==null && selectedBioStaffCategory != "Facility Supervisor" ){
                                    return GestureDetector(
                                      onTap: () {
                                        _pickImage();
                                      },

                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 24,
                                        ),
                                        height: MediaQuery.of(context).size.width *
                                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                        width: MediaQuery.of(context).size.width *
                                            (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          //color: Colors.grey.shade300,
                                        ),
                                        child: RefreshableWidget<List<Uint8List>?>(
                                          refreshCall: () async {
                                            return await _readImagesFromDatabase();
                                          },
                                          refreshRate: const Duration(seconds: 1),
                                          errorWidget: Icon(
                                            Icons.upload_file,
                                            size: 80,
                                            color: Colors.grey.shade300,
                                          ),
                                          loadingWidget: Icon(
                                            Icons.upload_file,
                                            size: 80,
                                            color: Colors.grey.shade300,
                                          ),
                                          builder: (context, value) {
                                            if (value != null && value.isNotEmpty) {
                                              return ListView.builder(
                                                itemCount: value.length,
                                                itemBuilder: (context, index) => Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 24,
                                                  ),
                                                  height: MediaQuery.of(context).size.width *
                                                      (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                                  width: MediaQuery.of(context).size.width *
                                                      (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    //color: Colors.grey.shade300,
                                                  ),
                                                  child: Image.memory(value.first),
                                                ),


                                              );
                                            } else {
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.upload_file,
                                                    size: MediaQuery.of(context).size.width *
                                                        (MediaQuery.of(context).size.shortestSide < 600 ? 0.075 : 0.05),
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    "Click to Upload Signature Image Here",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  else if(caritasSupervisorSignature == null && selectedSignatureLink !=null && selectedBioStaffCategory != "Facility Supervisor"   ){
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
                                        ),
                                        const SizedBox(height: 8),
                                        caritasSupervisorSignatureStatus == "Pending"
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
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus (Awaiting Approval)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : caritasSupervisorSignatureStatus == "Rejected"
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
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
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
                                                  "$caritasSupervisorSignatureStatus (Approved)",
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
                                  else if(caritasSupervisorSignature != null && selectedSignatureLink !=null && selectedBioStaffCategory != "Facility Supervisor" ){
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
                                        ),
                                        const SizedBox(height:8),
                                        caritasSupervisorSignatureStatus == "Pending"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.access_time, color: Colors.orange),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus (Awaiting Approval)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ):
                                        caritasSupervisorSignatureStatus == "Rejected"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.cancel, color: Colors.red),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        )
                                            :Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.check_circle, color: Colors.green),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus (Approved)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ),

                                      ],
                                    );
                                  }
                                  else if(caritasSupervisorSignature == null && caritasSupervisorSignatureStatus =="Pending" && selectedBioStaffCategory != "Facility Supervisor"  ){
                                    return Column(
                                      children: [
                                        const Text("Awaiting Facility Supervisor Signature"),
                                        const SizedBox(height:8),
                                        caritasSupervisorSignatureStatus == "Pending"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.access_time, color: Colors.orange),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ):caritasSupervisorSignatureStatus == "Rejected"?
                                        Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.cancel, color: Colors.red),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        )
                                            :Row(
                                            children:[
                                              const Padding(
                                                padding: EdgeInsets.only(top: 0.0),
                                                child:
                                                Icon(Icons.check_circle, color: Colors.green),
                                              ),
                                              const SizedBox(width:8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]
                                        ),


                                      ],
                                    );
                                  }
                                  else if(selectedBioStaffCategory != "Facility Supervisor"  ) {
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 24,
                                          ),
                                          height: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.15),
                                          width: MediaQuery.of(context).size.width *
                                              (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            //color: Colors.grey.shade300,
                                          ),
                                          child: Image.network(selectedSignatureLink!),
                                        ),
                                        const SizedBox(height: 8),
                                        caritasSupervisorSignatureStatus == "Pending"
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
                                                padding: const EdgeInsets.only(bottom: 0.0),
                                                child: Text(
                                                  "$caritasSupervisorSignatureStatus (Awaiting Approval)",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : caritasSupervisorSignatureStatus == "Rejected"
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
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : caritasSupervisorSignatureStatus == "Approved"
                                            ? Row(
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
                                                  "$caritasSupervisorSignatureStatus",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
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
                                                  "$caritasSupervisorSignatureStatus (Approved)",
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
                                  return const Text("Awaiting Signature from Facility Supervisor");

                                }
                                } else {
                                  return const Text("Timesheet Yet to be submitted for Project Cordinator's Signature");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.01 : 0.009)),
                      //Date of CARITAS Staff Signature Date

                      Container(
                        width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.30 : 0.30),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20.0),
                            Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.005 : 0.005)),
                  const Divider(),
                  SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.020 : 0.020)),

                  StreamBuilder<DocumentSnapshot>(
                    // Stream the supervisor signature
                    stream: FirebaseFirestore.instance
                        .collection("Staff")
                        .doc(staffId) // Replace with how you get the staff document ID
                        .collection("TimeSheets")
                        .doc(filteredMonthYear) // Replace monthYear with the timesheet document ID
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
                            
                            ElevatedButton.icon(
                              onPressed: () {
                                sendEmailToProjectManagementTeam();
                              },
                              icon: const Icon(
                                Icons.email, // Add an appropriate icon
                                color: Colors.white, // Icon color
                                size: 16, // Reduce the size of the icon
                              ),
                              label: const Flexible(
                                child: Text(
                                  'Email Signed Timesheet to Project Managament Team',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 12, // Reduce font size
                                  ),
                                  textAlign: TextAlign.center, // Center-align text
                                  overflow: TextOverflow.clip, // Ensure text wraps instead of overflowing
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button background color
                                foregroundColor: Colors.white, // Text and icon color
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduce button padding
                                minimumSize: const Size(100, 30), // Set minimum size for the button
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize touch target size
                              ),
                            );
                        } else {
                          return Row(
                              crossAxisAlignment : CrossAxisAlignment.center,
                              mainAxisAlignment : MainAxisAlignment.center,
                              children:[
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _uploadSignatureAndSync();
                                  },
                                  icon: const Icon(
                                    Icons.credit_score, // Add an appropriate icon
                                    color: Colors.white, // Icon color
                                    size: 16, // Reduce the size of the icon
                                  ),
                                  label: const Flexible(
                                    child: Text(
                                      'Approve Timesheet',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 12, // Reduce font size
                                      ),
                                      textAlign: TextAlign.center, // Center-align text
                                      overflow: TextOverflow.clip, // Ensure text wraps instead of overflowing
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Button background color
                                    foregroundColor: Colors.white, // Text and icon color
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduce button padding
                                    minimumSize: const Size(100, 30), // Set minimum size for the button
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize touch target size
                                  ),
                                ),

                                const SizedBox(width:8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _rejectTimesheet(staffId, filteredMonthYear,selectedBioStaffCategory!);
                                  },
                                  icon: const Icon(
                                    Icons.cancel, // Add an appropriate icon
                                    color: Colors.white, // Icon color
                                    size: 16, // Reduce the size of the icon
                                  ),
                                  label: const Flexible(
                                    child: Text(
                                      'Reject Timesheet',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 12, // Reduce font size
                                      ),
                                      textAlign: TextAlign.center, // Center-align text
                                      overflow: TextOverflow.clip, // Ensure text wraps instead of overflowing
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // Button background color
                                    foregroundColor: Colors.white, // Text and icon color
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduce button padding
                                    minimumSize: const Size(100, 30), // Set minimum size for the button
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize touch target size
                                  ),
                                ),



                              ]
                          );
                        }
                      } else {
                        return Row(
                            crossAxisAlignment : CrossAxisAlignment.center,
                            mainAxisAlignment : MainAxisAlignment.center,
                            children:[
                              ElevatedButton.icon(
                                onPressed: () {
                                  _uploadSignatureAndSync();
                                },
                                icon: const Icon(
                                  Icons.credit_score, // Add an appropriate icon
                                  color: Colors.white, // Icon color
                                  size: 16, // Reduce the size of the icon
                                ),
                                label: const Flexible(
                                  child: Text(
                                    'Approve Timesheet',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 12, // Reduce font size
                                    ),
                                    textAlign: TextAlign.center, // Center-align text
                                    overflow: TextOverflow.clip, // Ensure text wraps instead of overflowing
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Button background color
                                  foregroundColor: Colors.white, // Text and icon color
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduce button padding
                                  minimumSize: const Size(100, 30), // Set minimum size for the button
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize touch target size
                                ),
                              ),

                              const SizedBox(width:8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _rejectTimesheet(staffId, filteredMonthYear,selectedBioStaffCategory!);
                                },
                                icon: const Icon(
                                  Icons.cancel, // Add an appropriate icon
                                  color: Colors.white, // Icon color
                                  size: 16, // Reduce the size of the icon
                                ),
                                label: const Flexible(
                                  child: Text(
                                    'Reject Timesheet',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 12, // Reduce font size
                                    ),
                                    textAlign: TextAlign.center, // Center-align text
                                    overflow: TextOverflow.clip, // Ensure text wraps instead of overflowing
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Button background color
                                  foregroundColor: Colors.white, // Text and icon color
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduce button padding
                                  minimumSize: const Size(100, 30), // Set minimum size for the button
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize touch target size
                                ),
                              ),



                            ]
                        );
                      }
                    },
                  ),



                  SizedBox(height: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.shortestSide < 600 ? 0.090 : 0.020)),
                ]
            ) ,

          ]
        ),
        //  caritasSupervisorSignature

      ),
    );
  }
}


