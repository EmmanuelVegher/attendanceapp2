import 'package:attendanceapp/Pages/Timesheet/timesheet_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingTimesheetsScreen extends StatefulWidget {
  const PendingTimesheetsScreen({super.key});

  @override
  _PendingTimesheetsScreenState createState() => _PendingTimesheetsScreenState();
}

class _PendingTimesheetsScreenState extends State<PendingTimesheetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Timesheets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup("TimeSheets")
            .where('facilitySupervisorSignatureStatus', isEqualTo: 'Pending')
            .where('caritasSupervisorSignatureStatus', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending timesheets.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                String staffName = data['staffName'] ?? 'N/A';
                String projectName = data['projectName'] ?? 'N/A';
                String date = data['date'] ?? 'N/A';

                String staffId = doc.reference.parent.parent!.id;

                return ListTile(
                  title: Text(staffName),
                  subtitle: Text('$projectName - $date'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimesheetDetailsScreen(
                          timesheetData: data,
                         // timesheetId: doc.id,
                          staffId: staffId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// class TimesheetDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> timesheetData;
//   final String timesheetId;
//   final String staffId;
//
//   TimesheetDetailsScreen({
//     required this.timesheetData,
//     required this.timesheetId,
//     required this.staffId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Uint8List? staffSignature = timesheetData['staffSignature'] != null
//         ? Uint8List.fromList(List<int>.from(timesheetData['staffSignature']))
//         : null;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Timesheet Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Staff Name: ${timesheetData['staffName'] ?? 'N/A'}'),
//             Text('Project Name: ${timesheetData['projectName'] ?? 'N/A'}'),
//             Text('Date: ${timesheetData['date'] ?? 'N/A'}'),
//             Text('Department: ${timesheetData['department'] ?? 'N/A'}'),
//             Text('State: ${timesheetData['state'] ?? 'N/A'}'),
//             Text('Caritas Supervisor: ${timesheetData['caritasSupervisor'] ?? 'N/A'}'),
//             Text('Facility Supervisor: ${timesheetData['facilitySupervisor'] ?? 'N/A'}'),
//             Text('Caritas Supervisor Signature Status: ${timesheetData['caritasSupervisorSignatureStatus'] ?? 'N/A'}'),
//             Text('Facility Supervisor Signature Status: ${timesheetData['facilitySupervisorSignatureStatus'] ?? 'N/A'}'),
//
//             SizedBox(height: 20),
//             Text('Timesheet Entries:', style: TextStyle(fontWeight: FontWeight.bold)),
//             ...(timesheetData['timesheetEntries'] as List<dynamic>?)
//                 ?.map((entry) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Date: ${entry['date'] ?? 'N/A'}'),
//                   Text('Hours: ${entry['noOfHours'] ?? 'N/A'}'),
//                   Text('Project: ${entry['projectName'] ?? 'N/A'}'),
//                 ],
//               ),
//             ))
//                 .toList() ??
//                 [Text('No timesheet entries available.')],
//
//             SizedBox(height: 20),
//             Text('Staff Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
//             staffSignature != null
//                 ? Image.memory(staffSignature)
//                 : Text('No signature available.'),
//           ],
//         ),
//       ),
//     );
//   }
// }




