import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:isar/isar.dart';
import '../model/bio_model.dart';
import '../model/facility_staff_model.dart';
import '../model/survey_result_model.dart';
import '../services/isar_service.dart';

class TeamSurveyPage extends StatefulWidget {
  const TeamSurveyPage({Key? key}) : super(key: key);

  @override
  _TeamSurveyPageState createState() => _TeamSurveyPageState();
}

class _TeamSurveyPageState extends State<TeamSurveyPage> {
  List<FacilityStaffModel> staffList = [];
  bool isLoading = true;
  String? BioState;
  String? BioLocation;
  BioModel? bioData;

  @override
  void initState() {
    super.initState();
    _loadBioData();
    _loadStaffList();
  }

  Future<void> _loadBioData() async {
    bioData = await IsarService().getBioData();
    if (bioData !=
        null) { // Check if bioData is not null before accessing its properties
      setState(() {
 // Initialize selectedBioDepartment
        BioState = bioData!.state;
        BioLocation = bioData!.location;
      });
    } else {
      // Handle case where no bio data is found
      print("No bio data found!");
    }
  }

  Future<void> _loadStaffList() async {
    try {
      final List<FacilityStaffModel> staff =
      await IsarService().getFacilityListForSpecificFacility();
      setState(() {
        staffList = staff;
        staffList.shuffle();
        isLoading = false;
      });
    } catch (error) {
      print('Error loading staff list: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _saveSurveyResults1() async {
    try {
      for (int i = 0; i < staffList.length; i++) {
        print("Rank ${i + 1}: ${staffList[i].name}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      print('Error saving survey results: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting survey, please try again.')),
      );
    }
  }

  void _saveSurveyResults() async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        throw Exception("Isar instance is null! Ensure Isar is opened.");
      }

      final now = DateTime.now();
      final dateOnly = DateTime(now.year, now.month, now.day); // Date only

      // Check if a survey with the same date already exists
      final existingSurvey = await isar.surveyResultModels.filter()
          .dateEqualTo(dateOnly) // Use filter
          .findFirst();

      if (existingSurvey != null) {
        // Show a toast message or a dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A survey already exists for this date.'),
            duration: Duration(seconds: 3), // Adjust duration as needed
          ),
        );
        return; // Stop further execution
      }

      final surveyResult = SurveyResultModel()
        ..date = dateOnly //  Store the dateOnly DateTime
        ..state = BioState
        ..facilityName = BioLocation
        ..staff = staffList;


      await isar.writeTxn(() async {
        await isar.surveyResultModels.put(surveyResult);
      });

      // Success handling:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted successfully!')),
      );
      print("Survey saved successfully. ID: ${surveyResult.id}");
      Navigator.pop(context);

    } catch (error) {
      // ... (error handling)
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
              'Press,Hold and Drag up or down to Rearrange',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Player Survey'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 20.0, color: Colors.black87),
                children: [
                  TextSpan(
                    text: 'For the week, who is the best team player in your facility?\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0,),
                  ),
                  TextSpan(
                    text: 'Press, Hold and Drag the cards vertically Upward or Downward ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'to re-arrange the ranking hierarchy.',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AnimatedReorderableListView(
              items: staffList,
              // Compare items based on their unique identifier.
              isSameItem: (oldItem, newItem) => oldItem.id == newItem.id,
              itemBuilder: (context, index) {
                return _buildCard(index, staffList[index]);
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  final FacilityStaffModel staff = staffList.removeAt(oldIndex);
                  staffList.insert(newIndex, staff);
                });
              },
              proxyDecorator: (Widget child, int index, Animation<double> animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Material(
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveSurveyResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Submit Survey',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
