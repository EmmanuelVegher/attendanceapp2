import 'package:isar/isar.dart';

part 'task.g.dart'; // Ensure to run `flutter pub run build_runner build` after creating this file

@collection
class Task {
  Id? id; // Isar auto-incrementing id

  DateTime? date;

  String? taskTitle;
  String? taskStatus;
  String? taskDescription;
  String? taskFeedbackComment;
  bool? isSynced; // Default value for isSynced is false

  Task({
    this.date,
    this.taskTitle,
    this.taskStatus,
    this.taskDescription,
    this.taskFeedbackComment,
    this.isSynced,
  });
}