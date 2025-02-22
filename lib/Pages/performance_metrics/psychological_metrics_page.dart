import 'dart:convert';
import 'dart:math';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:attendanceapp/model/psychological_metrics.dart';
import 'package:flutter/foundation.dart';

import '../../model/bio_model.dart';
import '../../model/facility_staff_model.dart';
import '../../model/survey_result_model.dart';
import '../../services/isar_service.dart';
import 'best_player_page.dart';

class PsychologicalMetricsPage extends StatefulWidget {
  final Isar isar;

  const PsychologicalMetricsPage({super.key, required this.isar});

  @override
  _PsychologicalMetricsPageState createState() =>
      _PsychologicalMetricsPageState();
}

class _PsychologicalMetricsPageState extends State<PsychologicalMetricsPage> {
  Map<String, List<Map<String, String>>> _sections = {};
  final Map<String, dynamic> _responses = {};
  List<FacilityStaffModel> _reorderableItems = []; // For storing shuffled staff list
  List<FacilityStaffModel> _staffList = []; // Use your FacilityStaffModel
  bool _isLoadingStaffList = true; // Track loading state
  bool isLoading = true;
  String? BioState;
  String? BioName;
  String? BioUUID;
  String? BioEmailAddress;
  String? BioPhoneNumber;
  String? BioStaffCategory;
  String? BioLocation;
  BioModel? bioData;

  @override
  void initState() {
    super.initState();
    _loadPsychologicalMetricsData();
    _loadBioData();
    _loadStaffList(); // Load the staff list when the page initializes
  }

  Future<void> _loadBioData() async {
    bioData = await IsarService().getBioData();
    if (bioData !=
        null) {
      String fullName = "${bioData!.firstName!} ${bioData!.lastName!}"; // Check if bioData is not null before accessing its properties
      setState(() {
        // Initialize selectedBioDepartment
        BioState = bioData!.state;
        BioLocation = bioData!.location;
        BioName = fullName;
        BioUUID = bioData!.firebaseAuthId ;
        BioEmailAddress= bioData!.emailAddress ;
        BioPhoneNumber= bioData!.mobile;
        BioStaffCategory= bioData!.staffCategory;
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
  }

  Future<void> _loadStaffList() async {
    try {
      final List<FacilityStaffModel> staff =
      await IsarService().getFacilityListForSpecificFacility(); // Replace with your IsarService method
      setState(() {
        _staffList = staff;
        _staffList.shuffle();
        _reorderableItems = List.from(_staffList); // Store shuffled list
        _isLoadingStaffList = false;
      });
    } catch (error) {
      print('Error loading staff list: $error');
      setState(() {
        _isLoadingStaffList = false;
      });
    }
  }

  Future<void> _loadPsychologicalMetricsData() async {
    try {
      final psychologicalMetrics =
      await widget.isar.psychologicalMetricsModels.get(1);

      if (psychologicalMetrics != null) {
        final decodedSections = (jsonDecode(psychologicalMetrics.sectionsJson)
        as List<dynamic>)
            .fold<Map<String, List<Map<String, String>>>>({}, (map, section) {
          final entry = section as Map<String, dynamic>;
          entry.forEach((key, value) {
            var questions = List<Map<String, String>>.from(
                (value as List<dynamic>).map((item) =>
                Map<String, String>.from(item as Map<String, dynamic>)));

            map[key] = questions;
          });
          return map;
        });

        setState(() {
          _sections = decodedSections;
        });
      }
    } catch (e) {
      print('Error fetching data from Isar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Weekly Review'),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: _sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(  // Use a Column for the main layout
        children: [
          Expanded( // Make the scrollable content take up the available space
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _sections.entries
                    .map((entry) => _buildSection(
                  title: _capitalize(entry.key.replaceAll('_', ' ')),
                  questions: entry.value,
                ))
                    .toList(),
              ),
            ),
          ),

          // Sync Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0), // Add padding as needed
            child: ElevatedButton(
              onPressed: _submitAndSyncOrNavigate,
              child: const Text('Submit Weekly Survey Review'),
            ),
          ),
        ],
      ),

    );
  }

  Future<void> _submitAndSyncOrNavigate() async {
    try {
      await _submitResponses(); // Always submit to Isar first

      // Check for network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // If network is available, sync to Firestore
        try {
          await syncDataToFirestore();
          // Navigate after successful sync
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BestPlayerChartPage()),
          ); // Navigate to next page

        } catch (e) {
          // Handle Firestore sync errors, but still navigate
          //print("Firestore sync error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data saved locally, but Firestore sync failed.  Will sync later.'))
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BestPlayerChartPage()),
          );

        }
      } else {
        // No network, just navigate (data is already in Isar)

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection. Data saved locally.'))
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BestPlayerChartPage()),
        );


      }
    } catch (submissionError) {
      // Handle submission errors
    //  print("Submission error: $submissionError");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit data.')),
      );

    }
  }

  Future<void> syncDataToFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Query data from Isar
      final psychologicalMetrics = await IsarService().getUnsyncedSurveyResults();
      final isar = Isar.getInstance(); // Get the Isar instance
      if (isar == null) {
        throw Exception("Isar instance is null!");
      }

      for (var metric in psychologicalMetrics) {
        final data = jsonDecode(metric.staffJson) as Map<String, dynamic>;
        final staffData = data['staff'] as List;
        List<Map<String, dynamic>> firestoreDataList = []; // List to store maps

        for (var section in staffData) {
          for (var key in section.keys) { // Iterate through section keys
            final sectionData = section[key] as List;

            for (var questionData in sectionData) {
              Map<String, dynamic> firestoreData = {}; // Map for each question

              // Extract question and answer
              for (var questionKey in questionData.keys) {
                firestoreData['section'] = key;  // Add the section name
                if (questionKey == 'For the current week, who is the best team player in your facility') {
                  final bestTeamPlayerList = questionData[questionKey];

                  // ***KEY CHANGE***: Encode the list to a string before saving to Firestore
                  firestoreData[questionKey] = jsonEncode(bestTeamPlayerList); // Encode to string
                } else {
                  firestoreData[questionKey] = questionData[questionKey];
                }
              }
              firestoreDataList.add(firestoreData);
            }
          }
        }


        // Format date as yyyy-MM-dd
        final formattedDate = DateFormat('yyyy-MM-dd').format(metric.date!); // Extract only the date part
        print("BioUUID == $BioUUID");

        // Create a document in Firestore
        final docRef = firestore.collection('Staff').doc(BioUUID);
        // Parse the 'date' string into a DateTime object
        final dateTime = DateFormat('yyyy-MM-dd').parse(data['date']);

        // Format the date into 'MMMM yyyy' format
        final formattedMonthYear = DateFormat('MMMM yyyy').format(dateTime);

        // Add data to the sub-collection
        await docRef.collection('SurveyResponses').doc(formattedDate).set({
          'surveyData': firestoreDataList, // Assuming `responses` is your survey data field
          'syncedAt': DateTime.now(),   // Optional: Record when it was synced
          'SubmittedBy':metric.name,
          'FacilityName':metric.facilityName,
          'State':metric.state,
          'StaffUUID':metric.uuid,
          'StaffEmailAddress':metric.emailAddress,
          'StaffPhoneNumber':metric.phoneNumber,
          'StaffCategory':metric.staffCategory,
          'date': data['date'], // Add the date from the decoded data
          'month_year':formattedMonthYear
        });

        // Update Isar after successful sync
        await isar.writeTxn(() async {
          metric.isSynced = true;
          await isar.surveyResultModels.put(metric);
        });


        print("Data for ${metric.id} synced and updated successfully!");

      }




      print("Data synced successfully!");
    } catch (error) {
      print("Error syncing data: $error");
    }
  }




  Widget _buildCard(int index, FacilityStaffModel staff) {
    Color cardBackgroundColor = (index % 2 == 0) ? Colors.grey[100]! : Colors.white;

    return Card(
      key: ValueKey(staff.id),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: cardBackgroundColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[200],
          child: Text(
            "${index + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              staff.name ?? 'Unnamed Staff',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            if (staff.designation != null)
              Text(
                staff.designation!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: const Column(
          children: [
            Icon(Icons.drag_indicator, color: Colors.grey),
            Text(
              'Press & Hold & Drag up or down to Rearrange',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 8.0),
        ...questions.asMap().entries.map((entry) {
          int index = entry.key + 1;
          return _buildQuestionTile(entry.value, index);
        }).toList(),
        const SizedBox(height: 24.0),

      ],
    );
  }

  Widget _buildQuestionTile(Map<String, String> questionData, int index) {
    final question = questionData['question'] ?? '';
    final type = questionData['type'] ?? '';

    if (type == 'tick_box') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. $question',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Yes'),
                  value: 'Yes',
                  groupValue: _responses[question],
                  onChanged: (value) {
                    setState(() {
                      _responses[question] = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('No'),
                  value: 'No',
                  groupValue: _responses[question],
                  onChanged: (value) {
                    setState(() {
                      _responses[question] = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
    else if (type == 'list') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. $question', style: const TextStyle(fontSize: 16)),
          ExpansionTile(
            title: const Text("Instructions: Click HERE to expand the list of all staff member in your facility (Excluding yourself).From the list, Press and Hold and Drag the cards either Upward or Downward to re-arrange the Best team player from top to down", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              _isLoadingStaffList // Show loading indicator while fetching staff list
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                items: _staffList,
                // Compare items based on their unique id.
                isSameItem: (oldItem, newItem) => oldItem.id == newItem.id,
                itemBuilder: (context, index) => _buildCard(index, _staffList[index]),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    final staffMember = _staffList.removeAt(oldIndex);
                    _staffList.insert(newIndex, staffMember);
                    _responses[question] = _staffList; // Store the reordered list
                  });
                },
                proxyDecorator: (child, index, animation) => Material(
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: child,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }


  // void _submitResponses() {
  //   print('User Responses: $_responses');
  // }

  Future<void> _submitResponses() async {
    try {



      if (listEquals(_staffList, _reorderableItems)) {
        Fluttertoast.showToast(
          msg: 'Hey!!, You forgot to answer the question "For the current week, who is the best team player in your facility". We value your opinion and would love you to re-arrange who you feel has been the best team player from top to bottom. Kindly read the instructions for the question before answering.',
          toastLength: Toast.LENGTH_LONG, // This parameter can stay or be ignored; duration overrides it.
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 8, // Set the duration for the toast.
        );
        return;
      } else{



        // Ensure all sections have responses except for the special question
        for (var entry in _sections.entries) {
          final sectionTitle = entry.key;
          final questions = entry.value;

          for (var questionData in questions) {
            final question = questionData['question'] ?? '';

            // Skip the special question check
            if (question == 'For the current week, who is the best team player in your facility') {
              continue;
            }

            // Check if the response exists for the current question
            if (!_responses.containsKey(question) || _responses[question] == null) {
              Fluttertoast.showToast(
                msg: 'Please answer all questions in the "${_capitalize(sectionTitle.replaceAll('_', ' '))}" section before submitting.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 8,
              );
              return;
            }
          }
        }
      }

      // Check the responses for the "Team Spirit" section questions
      String collaborationResponse = _responses['Is there good collaboration among your team members?'];
      String supportResponse = _responses['Do you get good support from your team members?'];


      // Check the responses for the "Attitude to Work" section questions
      String challengeResponse = _responses['Do you have any challenge carrying out your duties?'];
      String neededMaterialsResponse = _responses['Do you have the needed materials to do your job?'];

      if (collaborationResponse != supportResponse) {
        if (collaborationResponse == "Yes" && supportResponse == "No"){
          Fluttertoast.showToast(
            msg: 'You responded that there is good collaboration among your team members BUT Do you get good support from your team members. Please review your answers.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 8,
          );
          return;
        }else{
          Fluttertoast.showToast(
            msg: 'You responded that there is NO good collaboration among your team members BUT you get good support from your team members. Please review your answers.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 8,
          );
          return;
        }

      }

      if (challengeResponse == neededMaterialsResponse) {
        if (challengeResponse == "No" && neededMaterialsResponse == "No"){
          Fluttertoast.showToast(
            msg: 'You responded that you DO NOT HAVE any challenge carrying out your duties BUT YOU ALSO DO NOT HAVE the needed materials to do your job.Not having the needed materials is also a challenge. Please review your answers.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 8,
          );
          return;
        }
        // else{
        //   Fluttertoast.showToast(
        //     msg: 'You responded that you HAVE any challenges carrying out your duties AND YOU HAVE the needed materials to do your job. Please review your answers.',
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 8,
        //   );
        //   return;
        // }

      }

      final isar = Isar.getInstance();
      if (isar == null) {
        throw Exception("Isar instance is null!");
      }

      final now = DateTime.now();
      final dateOnly = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final dateOnly1 = DateTime(now.year, now.month, now.day);
      // Fetch existing survey data if necessary (example logic)
      final existingSurvey = await isar.surveyResultModels.filter()
          .dateEqualTo(DateTime(now.year, now.month, now.day))
          .findFirst();

      if (existingSurvey != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A survey already exists for this date.')),
        );
        return;
      }

      // Convert responses to the required JSON format
      final formattedResponses = {
        "id": Random().nextInt(1000), // Example ID generation, replace with your logic
        "date": dateOnly,
        "state": BioState, // Replace with actual state data
        "facilityName": BioLocation, // Replace with actual facility name
        "staff": jsonEncode(
          _sections.entries.map((entry) {
            final sectionTitle = entry.key;
            final questions = entry.value;

            return {
              sectionTitle: questions.map((question) {
                final questionId = question['id'] ?? '';
                final questionType = question['type'] ?? '';
                final questionText = question['question'] ?? '';
                final answer = _responses[questionText] ?? [];

                return {
                  questionText: answer,
                  "id": questionId,
                  "type": questionType,
                  if (questionType == 'list')
                    "For the current week, who is the best team player in your facility":
                    jsonEncode((answer as List).map((staff) {
                      return {
                        "id": staff.id,
                        "name": staff.name,
                        "state": staff.state,
                        "facilityName": staff.facilityName,
                        "userId": staff.userId,
                        "designation": staff.designation,
                      };
                    }).toList()),
                };
              }).toList(),
            };
          }).toList(),
        ),
      };

      final formattedResponses1 = {
        "id": Random().nextInt(1000),
        "date": dateOnly,
        "state": BioState,
        "facilityName": BioLocation,
        "staff": _sections.entries.map((entry) {
          final sectionTitle = entry.key;
          final questions = entry.value;

          return {
            sectionTitle: questions.map((question) {
              final questionText = question['question'] ?? '';
              final answer = _responses[questionText]; // No need for ?? [] here

              // Directly encode the list for best team player here
              if (questionText == 'For the current week, who is the best team player in your facility') {
                return {
                  questionText: (answer as List<FacilityStaffModel>).map((staff) => {
                    "id": staff.id,
                    "name": staff.name,
                    "state": staff.state,
                    "facilityName": staff.facilityName,
                    "userId": staff.userId,
                    "designation": staff.designation,
                  }).toList(),
                };
              } else {
                return {questionText: answer};
              }
            }).toList(),
          };
        }).toList(),
      };



      final surveyResult = SurveyResultModel()
        ..date = dateOnly1 // Store formatted date as String
      ..emailAddress = BioEmailAddress
        ..isSynced = false
        ..name = BioName
        ..phoneNumber = BioPhoneNumber
        ..staffCategory = BioStaffCategory
        ..uuid = BioUUID
        ..state = BioState // Replace with actual state retrieval
        ..facilityName = BioLocation // Replace with actual facility name retrieval
        ..staffJson = jsonEncode(formattedResponses1); // Directly encode the formatted responses


      await isar.writeTxn(() async {
        await isar.surveyResultModels.put(surveyResult);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted successfully!')),
      );
    } catch (error) {
      print('Error submitting responses: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit responses.')),
      );
    }
  }



  String _getSectionForQuestion(String question) {  // Helper function to determine the section
    for (var entry in _sections.entries) {
      if (entry.value.any((q) => q['question'] == question)) {
        return _capitalize(entry.key.replaceAll('_', ' '));
      }
    }
    return 'Unknown'; // Or handle the case where the question isn't found
  }





  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
