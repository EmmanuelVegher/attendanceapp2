import 'package:attendanceapp/model/leave_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
//import 'package:percent_indicator/circular_percent_indicator.dart'; // For doughnut chart
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../model/attendancemodel.dart';
import '../../model/bio_model.dart';
import '../../services/isar_service.dart'; // For date range picker

// ... other imports

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Timesheet/timesheet_details.dart';

class PendingApprovalsPage extends StatefulWidget {
  final IsarService service;

  const PendingApprovalsPage({Key? key, required this.service}) : super(key: key);

  @override
  _PendingApprovalsPageState createState() => _PendingApprovalsPageState();
}

class _PendingApprovalsPageState extends State<PendingApprovalsPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> pendingLeaves = [];
  List<Map<String, dynamic>> pendingTimesheets = []; // Placeholder for timesheet data
  bool isLoading = true;
  final TextEditingController _rejectReasonController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPendingApprovals();
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


      setState(() {
        pendingLeaves = leavesSnapshot.docs.map((doc) => doc.data()).toList();
        pendingTimesheets = timesheetsSnapshot.docs.map((doc) => doc.data()).toList();
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
                      'rejectionReason': rejectionReasonController.text, // Add rejection reason to Firestore
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
              "Leave Type: ${leave['type']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Duration: ${DateFormat('yyyy-MM-dd').format(leave['startDate'].toDate())} - ${DateFormat('yyyy-MM-dd').format(leave['endDate'].toDate())}",
            ),
            const SizedBox(height: 8),
            Text(
              "Reason: ${leave['reason'] ?? 'No reason provided'}",
              style: const TextStyle(color: Colors.grey),
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
              child: pendingTimesheets.isNotEmpty
                  ? ListView.builder(
                itemCount: pendingTimesheets.length,
                itemBuilder: (context, index) {
                  final doc = pendingTimesheets[index];
                  final staffName = doc['staffName'] ?? 'N/A';
                  final projectName = doc['projectName'] ?? 'N/A';
                  final date = doc['date'] ?? 'N/A';

                  // Add other fields as needed

                  return ListTile(
                    title: Text(staffName),
                    subtitle: Text('$projectName - $date'),
                    // ... (Add onTap navigation if needed)
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimesheetDetailsScreen(
                            timesheetData: doc,  // Pass the entire document data
                            //timesheetId: doc['timesheetId'], // Assuming you have a 'timesheetId' field
                            staffId: doc['staffId'], // Assuming you have a 'staffId' field
                          ),
                        ),
                      );
                    },
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



