
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../model/bio_model.dart';
import '../../services/isar_service.dart'; // For date range picker


import '../../widgets/drawer.dart';
import '../Timesheet/timesheet_details.dart';

class PendingApprovalsPage extends StatefulWidget {
  final IsarService service;

  const PendingApprovalsPage({Key? key, required this.service}) : super(key: key);

  @override
  _PendingApprovalsPageState createState() => _PendingApprovalsPageState();
}

class _PendingApprovalsPageState extends State<PendingApprovalsPage> with SingleTickerProviderStateMixin {
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
  BioModel? bioData; // Make bioData nullable// Currently selected project
  String? selectedSupervisor; // State variable to store the selected supervisor
  List<Map<String, dynamic>> pendingLeaves = [];
  List<Map<String, dynamic>> pendingTimesheets = []; // Placeholder for timesheet data
  List<Map<String, dynamic>> pendingTimesheetsFacilitySupervisor = [];
  List<Map<String, dynamic>> pendingTimesheetsCaritasSupervisor = [];
  bool isLoading = true;
  final TextEditingController _rejectReasonController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBioData().then((_){
      _fetchPendingApprovals();
    });

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
        selectedBioEmail = bioData!.emailAddress;
        selectedBioPhone = bioData!.mobile;
        selectedFirebaseId = bioData!.firebaseAuthId;// Initialize selectedBioState
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
  }

  Future<void> _fetchPendingApprovals() async {
    print("_fetchPendingApprovals");

    setState(() {
      isLoading = true; // Show loading indicator

    });
    try {
      final user = await IsarService().getBioInfoForUser();
      // Fetch pending leaves
      final leavesSnapshot = await FirebaseFirestore.instance
          .collectionGroup('Leave Request')
          .where('selectedSupervisorEmail', isEqualTo: user[0].emailAddress)
         .where('status', isEqualTo: 'Pending')
          .get();

      // Fetch pending timesheets (replace with your actual timesheet query)
      final timesheetsSnapshot = await FirebaseFirestore.instance
          .collectionGroup('TimeSheets') // Replace with your timesheet collection/subcollection

          .where('caritasSupervisorSignatureStatus', isEqualTo: 'Pending')
          .get();

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
        pendingLeaves = leavesSnapshot.docs.map((doc) => doc.data()).toList();
        pendingTimesheets = timesheetsSnapshot.docs.map((doc) => doc.data()).toList();
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

  Future<void> _fetchPendingLeaves() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('Leave Request')
          .where('status', isEqualTo: 'Pending')
          .get();

      setState(() {
        pendingLeaves = querySnapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pending leaves: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _approveLeave(Map<String, dynamic> leave) async {
    try {
      final leaveRequestId = leave['leaveRequestId'] as String?;
      final staffId = leave['staffId'] as String?; // Get staffId
      final startDate = (leave['startDate'] as Timestamp).toDate(); // Convert Timestamp to DateTime
      final endDate = (leave['endDate'] as Timestamp).toDate(); // Convert Timestamp to DateTime
      if (leaveRequestId != null  && staffId != null) {
        // Update the status in Firestore
        await FirebaseFirestore.instance
            .collection('Staff')
            .doc(staffId)
            .collection('Leave Request')
            .doc(leaveRequestId)
            .update({'status': 'Approved'});


      }


        setState(() {
          pendingLeaves.remove(leave);
        });

        if (pendingLeaves.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No pending approvals')),
          );
        }

    } catch (e) {
      print('Error approving leave: $e');
    }
  }

  Future<void> _rejectLeave(Map<String, dynamic> leave) async {
    TextEditingController rejectionReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Leave Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please provide a reason for rejection:"),
              TextField(
                controller: rejectionReasonController,
                decoration: const InputDecoration(
                  labelText: "Reason for Rejection",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _rejectReasonController.clear(); // Clear the text field
              },

              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final leaveRequestId = leave['leaveRequestId'] as String?;
                  if (leaveRequestId != null) {
                    await FirebaseFirestore.instance
                        .collection('Staff') // Correct path to leave request documents
                        .doc(leave['staffId'])
                        .collection('Leave Request')
                        .doc(leaveRequestId).update({
                      'status': 'Rejected',
                      'reasonsForRejectedLeave': rejectionReasonController.text, // Add rejection reason to Firestore
                    });

                    setState(() {
                      pendingLeaves.remove(leave);
                    });

                    Navigator.pop(context);

                    if (pendingLeaves.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No pending approvals')),
                      );
                    }
                  }
                  Navigator.of(context).pop(); // Close the dialog
                  _rejectReasonController.clear(); // Clear the text field
                  _fetchPendingApprovals();
                } catch (e) {
                  print('Error rejecting leave: $e');
                }
              },
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeaveCard(Map<String, dynamic> leave) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${leave['firstName']} ${leave['lastName']}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Leave Type: ${leave['type']}",
              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
            ),
            const SizedBox(height: 8),
            Text(
              "Duration: ${DateFormat('yyyy-MM-dd').format(leave['startDate'].toDate())} - ${DateFormat('yyyy-MM-dd').format(leave['endDate'].toDate())}",style: const TextStyle( fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text(
              "Department: ${leave['staffDepartment']}, ",style: const TextStyle(fontSize: 16,),
            ),
            const SizedBox(height: 8),
            Text(
              "Designation: ${leave['staffDesignation']}",style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Location Name: ${leave['staffLocation']}",style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Staff Category: ${leave['staffCategory']}",style: const TextStyle(fontSize: 16,)
            ),
            const SizedBox(height: 8),
            Text(
              "State: ${leave['staffState']}",style: const TextStyle(fontSize: 16,)
            ),


            const SizedBox(height: 8),
            Text(
              "Email Address: ${leave['staffEmail']},",style: const TextStyle(fontSize: 16,)
            ),

            const SizedBox(height: 8),
            Text(
              " PhoneNumber: ${leave['staffPhone']}",style: const TextStyle(fontSize: 16,)
            ),


            const SizedBox(height: 8),
            Text(
              "Reason: ${leave['reason'] ?? 'No reason provided'}",
              style: TextStyle(color: Colors.grey[900],fontSize: 16,),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Approve"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => _approveLeave(leave),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("Reject"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => _rejectLeave(leave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: drawer(context, IsarService()),
        appBar: AppBar(
          title: const Text('Pending Approvals'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Leaves"),
              Tab(text: "Timesheet"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            // Leaves Tab
            RefreshIndicator(
              onRefresh: _fetchPendingApprovals,
              child: pendingLeaves.isNotEmpty
                  ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingLeaves.length,
                itemBuilder: (context, index) {
                  return _buildLeaveCard(pendingLeaves[index]);
                 // return _buildLeaveRequestCard(pendingLeaves[index], index);
                },
              )
                  : const Center(
                child: Text("No pending leave approvals",
                    style: TextStyle(fontSize: 18)),
              ),
            ),
            // Timesheet Tab
            RefreshIndicator( // Added RefreshIndicator
              onRefresh: _fetchPendingApprovals, // Refresh both leaves and timesheets
              child: selectedBioStaffCategory == "Facility Supervisor" && pendingTimesheetsFacilitySupervisor.isNotEmpty
                  ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingTimesheetsFacilitySupervisor.length,
                itemBuilder: (context, index) {
                  final doc = pendingTimesheetsFacilitySupervisor[index];
                  final staffName = doc['staffName'] ?? 'N/A';
                  final projectName = doc['projectName'] ?? 'N/A';
                  final date = doc['staffSignatureDate'] ?? 'N/A';
                  final department = doc['department'] ?? 'N/A';
                  final caritasSupervisor = doc['caritasSupervisor'] ?? 'N/A';
                  final designation = doc['designation'] ?? 'N/A';
                  final location = doc['location'] ?? 'N/A';
                  final state = doc['state'] ?? 'N/A';
                  final staffCategory = doc['staffCategory'] ?? 'N/A';
                  final staffEmail = doc['staffEmail'] ?? 'N/A';
                  final staffPhone = doc['staffPhone'] ?? 'N/A';


                  // Add other fields as needed

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$staffName",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Location Name: $location",
                            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: $date",style: const TextStyle( fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            "Department: $department, ",style: const TextStyle(fontSize: 16,),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Designation: $designation",style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Project Name: $projectName",style: const TextStyle(fontSize: 16),
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Staff Category: $staffCategory",style: const TextStyle(fontSize: 16,)
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "State: $state",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Email Address: $staffEmail",style: const TextStyle(fontSize: 16,)
                          ),

                          const SizedBox(height: 8),
                          Text(
                              "PhoneNumber: $staffPhone",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                            "Name of CARITAS Supervisor: $caritasSupervisor",
                            style: TextStyle(color: Colors.grey[900],fontSize: 16,),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(

                                label: const Text("Navigate to Approve Timesheet"),
                                icon: const Icon(Icons.forward, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TimesheetDetailsScreen(
                                        timesheetData: doc,  // Pass the entire document data
                                        // timesheetId: doc['timesheetId'], // Assuming you have a 'timesheetId' field
                                        staffId: doc['staffId'], // Assuming you have a 'staffId' field
                                        // staffName :staffName,
                                        // projectName : projectName,
                                        // date :date,
                                        // department:department,
                                        // facilitySupervisor: facilitySupervisor,
                                        // designation : designation,
                                        // location : location,
                                        // state : state,
                                        // staffCategory :staffCategory,
                                        // staffEmail : staffEmail,
                                        // staffPhone : staffPhone,
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ):
              selectedBioStaffCategory == "State Office Staff" && pendingTimesheetsCaritasSupervisor.isNotEmpty
                  ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingTimesheetsCaritasSupervisor.length,
                itemBuilder: (context, index) {
                  final doc = pendingTimesheetsCaritasSupervisor[index];
                  final staffName = doc['staffName'] ?? 'N/A';
                  final projectName = doc['projectName'] ?? 'N/A';
                  final date = doc['staffSignatureDate'] ?? 'N/A';
                  final department = doc['department'] ?? 'N/A';
                  final facilitySupervisor = doc['facilitySupervisor'] ?? 'N/A';
                  final designation = doc['designation'] ?? 'N/A';
                  final location = doc['location'] ?? 'N/A';
                  final state = doc['state'] ?? 'N/A';
                  final staffCategory = doc['staffCategory'] ?? 'N/A';
                  final staffEmail = doc['staffEmail'] ?? 'N/A';
                  final staffPhone = doc['staffPhone'] ?? 'N/A';


                  // Add other fields as needed

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$staffName",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Location Name: $location",
                            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: $date",style: const TextStyle( fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            "Department: $department, ",style: const TextStyle(fontSize: 16,),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Designation: $designation",style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Project Name: $projectName",style: const TextStyle(fontSize: 16),
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Staff Category: $staffCategory",style: const TextStyle(fontSize: 16,)
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "State: $state",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Email Address: $staffEmail",style: const TextStyle(fontSize: 16,)
                          ),

                          const SizedBox(height: 8),
                          Text(
                              "PhoneNumber: $staffPhone",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                            "Name of Facility Supervisor: $facilitySupervisor",
                            style: TextStyle(color: Colors.grey[900],fontSize: 16,),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(

                                label: const Text("Pending"),
                                icon: const Icon(Icons.access_time, color: Colors.orange),
                                style: ElevatedButton.styleFrom(
                                  //backgroundColor: Colors.green,
                                ),
                                onPressed: () {

                                },
                              ),
                              ElevatedButton.icon(

                                label: const Text("Navigate to Approve Timesheet"),
                                icon: const Icon(Icons.forward, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TimesheetDetailsScreen(
                                        timesheetData: doc,  // Pass the entire document data
                                        // timesheetId: doc['timesheetId'], // Assuming you have a 'timesheetId' field
                                        staffId: doc['staffId'], // Assuming you have a 'staffId' field
                                        // staffName :staffName,
                                        // projectName : projectName,
                                        // date :date,
                                        // department:department,
                                        // facilitySupervisor: facilitySupervisor,
                                        // designation : designation,
                                        // location : location,
                                        // state : state,
                                        // staffCategory :staffCategory,
                                        // staffEmail : staffEmail,
                                        // staffPhone : staffPhone,
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );


                },
              ):
              selectedBioStaffCategory == "HQ Staff" && pendingTimesheetsCaritasSupervisor.isNotEmpty
                  ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingTimesheetsCaritasSupervisor.length,
                itemBuilder: (context, index) {
                  final doc = pendingTimesheetsCaritasSupervisor[index];
                  final staffName = doc['staffName'] ?? 'N/A';
                  final projectName = doc['projectName'] ?? 'N/A';
                  final date = doc['staffSignatureDate'] ?? 'N/A';
                  final department = doc['department'] ?? 'N/A';
                  final facilitySupervisor = doc['facilitySupervisor'] ?? 'N/A';
                  final designation = doc['designation'] ?? 'N/A';
                  final location = doc['location'] ?? 'N/A';
                  final state = doc['state'] ?? 'N/A';
                  final staffCategory = doc['staffCategory'] ?? 'N/A';
                  final staffEmail = doc['staffEmail'] ?? 'N/A';
                  final staffPhone = doc['staffPhone'] ?? 'N/A';


                  // Add other fields as needed

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$staffName",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Location Name: $location",
                            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: $date",style: const TextStyle( fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            "Department: $department, ",style: const TextStyle(fontSize: 16,),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Designation: $designation",style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Project Name: $projectName",style: const TextStyle(fontSize: 16),
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Staff Category: $staffCategory",style: const TextStyle(fontSize: 16,)
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "State: $state",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                              "Email Address: $staffEmail",style: const TextStyle(fontSize: 16,)
                          ),

                          const SizedBox(height: 8),
                          Text(
                              "PhoneNumber: $staffPhone",style: const TextStyle(fontSize: 16,)
                          ),


                          const SizedBox(height: 8),
                          Text(
                            "Name of Facility Supervisor: $facilitySupervisor",
                            style: TextStyle(color: Colors.grey[900],fontSize: 16,),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(

                                label: const Text("Navigate to Approve Timesheet"),
                                icon: const Icon(Icons.forward, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TimesheetDetailsScreen(
                                        timesheetData: doc,  // Pass the entire document data
                                        // timesheetId: doc['timesheetId'], // Assuming you have a 'timesheetId' field
                                        staffId: doc['staffId'], // Assuming you have a 'staffId' field
                                        // staffName :staffName,
                                        // projectName : projectName,
                                        // date :date,
                                        // department:department,
                                        // facilitySupervisor: facilitySupervisor,
                                        // designation : designation,
                                        // location : location,
                                        // state : state,
                                        // staffCategory :staffCategory,
                                        // staffEmail : staffEmail,
                                        // staffPhone : staffPhone,
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                },
              )
                  : const Center(
                child: Text("No pending timesheet approvals",
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }


}



