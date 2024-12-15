import 'dart:convert';
import 'package:attendanceapp/model/survey_result_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../model/facility_staff_model.dart';

class BestPlayerChartPage extends StatefulWidget {
  @override
  _BestPlayerChartPageState createState() => _BestPlayerChartPageState();
}

class _BestPlayerChartPageState extends State<BestPlayerChartPage> {
  List<FacilityStaffModel> _isarBestPlayers = [];
  Map<String, int> _firestoreBestPlayerCounts = {};
  bool _isLoadingIsar = true;
  bool _isLoadingFirestore = true;
  FacilityStaffModel? _bestPlayerOfWeek;

  @override
  void initState() {
    super.initState();
    _loadIsarData();
    _loadFirestoreData();
  }

  Future<void> _loadIsarData() async {
    final isar = Isar.getInstance();
    if (isar != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final surveyResult =
      await isar.surveyResultModels.filter().dateEqualTo(today).findFirst();

      if (surveyResult != null) {
        final data = jsonDecode(surveyResult.staffJson) as Map<String, dynamic>;
        final staffData = data['staff'] as List;
        for (var section in staffData) {
          for (var key in section.keys) {
            final sectionData = section[key] as List;
            for (var questionData in sectionData) {
              if (questionData.containsKey(
                  'For the current week, who is the best team player in your facility')) {
                final bestTeamPlayerList = questionData[
                'For the current week, who is the best team player in your facility'] as List;
                _isarBestPlayers = bestTeamPlayerList
                    .map((staff) => FacilityStaffModel.fromJson(staff))
                    .toList()
                    .cast<FacilityStaffModel>();
                break;
              }
            }
          }
          if (_isarBestPlayers.isNotEmpty) break;
        }
        setState(() {
          _bestPlayerOfWeek = _isarBestPlayers.isNotEmpty
              ? _isarBestPlayers.first
              : null;
          _isLoadingIsar = false;
        });
      } else {
        setState(() => _isLoadingIsar = false);
      }
    }
  }

  Future<void> _loadFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    print("_loadFirestoreData ==$_loadFirestoreData");

    try {
      // Fetch responses for the current date
      final querySnapshot = await firestore
          .collection('PsychologicalMetrics')
          .doc('responses')
          .collection('responses')
          .where('date', isEqualTo: formattedDate)
          .get();

      print("querySnapshot ==$querySnapshot");

      if (querySnapshot.docs.isNotEmpty) {
        final bestPlayerCounts = <String, int>{};

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          print("data ==$data");

          if (data.containsKey('surveyData')) {
            final surveyDataList = data['surveyData'] as List;

            for (var surveyData in surveyDataList) {
              // Check if surveyData is a Map
              if (surveyData is Map<String, dynamic>) {
                print("surveyData ==$surveyData");
                if (surveyData.containsKey(
                    "For the current week, who is the best team player in your facility")) {
                  final bestPlayerString = surveyData[
                  "For the current week, who is the best team player in your facility"];

                  try {
                    // Decode the JSON string into a List
                    final bestPlayerList = json.decode(bestPlayerString) as List;

                    print("bestPlayerList ==$bestPlayerList");
                    for (var player in bestPlayerList) {
                      if (player is Map<String, dynamic> &&
                          player.containsKey('name')) {
                        final playerName = player['name'] as String;
                        bestPlayerCounts[playerName] =
                            (bestPlayerCounts[playerName] ?? 0) + 1;
                      }
                    }
                  } catch (e) {
                    print("Error decoding JSON string: $e");
                  }
                }
              } else {
                print("Unexpected surveyData format: $surveyData");
              }
            }
          }
        }

        // Update state with the retrieved data
        setState(() {
          _firestoreBestPlayerCounts = bestPlayerCounts;
          _isLoadingFirestore = false;
        });
      } else {
        // No data found for the current date
        setState(() => _isLoadingFirestore = false);
      }
    } catch (e) {
      print('Error loading Firestore data: $e');
      setState(() => _isLoadingFirestore = false);
    }
  }


  Widget _buildIsarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What your view is",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            BarSeries<FacilityStaffModel, String>(
              dataSource: _isarBestPlayers,
              xValueMapper: (staff, _) => staff.name ?? 'Unknown',
              yValueMapper: (_, index) => index + 1,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFirestoreChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What the view of everyone is",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            BarSeries<MapEntry<String, int>, String>(
              dataSource: _firestoreBestPlayerCounts.entries.toList(),
              xValueMapper: (entry, _) => entry.key,
              yValueMapper: (entry, _) => entry.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecognitionCard() {
    if (_bestPlayerOfWeek == null) {
      return const SizedBox.shrink();
    }
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 50),
          Text(
            "Best Team Player of the Week",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _bestPlayerOfWeek!.name ?? "Unknown",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRecognitionCard1() {

    if (_bestPlayerOfWeek == null) {
      return const SizedBox.shrink();
    }


    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row( // Star and Name Row
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 32),
                const SizedBox(width: 8),
                Text(
                  _bestPlayerOfWeek!.name!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Best team player from your facility for the week!',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),

            // ... (Add more recognition elements as needed)
          ],
        ),
      ),
    );


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Player Charts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _isLoadingIsar ? const CircularProgressIndicator() : _buildRecognitionCard(),
            const SizedBox(height: 20),
            _isLoadingIsar ? const CircularProgressIndicator() : _buildIsarChart(),
            const SizedBox(height: 20),
            _isLoadingFirestore
                ? const CircularProgressIndicator()
                : _buildFirestoreChart(),
          ],
        ),
      ),
    );
  }
}
