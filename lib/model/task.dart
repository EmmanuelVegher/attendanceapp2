import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id? id; // Automatically set as the primary key

  late String title;
  String? note;
  late String date;
  late String startTime;
  late String endTime;
  late int remind;
  late String repeat;
  late int color;
  late bool isCompleted;
}
