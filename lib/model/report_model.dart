import 'package:isar/isar.dart';
import 'dart:convert';

part 'report_model.g.dart';

@embedded
class ReportEntry {
  String key;
  String value;
  String? enteredBy; // Added enteredBy field
  String? editedBy;  // Added editedBy field

  ReportEntry({this.key = "", this.value = "",this.enteredBy, this.editedBy}); // Updated constructor
}

@collection
class Report {
  Id? id;
  DateTime? date;
  String? reportType;
  String? reportingWeek;
  String? reportingMonth;
  List<ReportEntry>? reportEntries;

  Report({
    this.id,
    this.date,
    this.reportType,
    this.reportingWeek,
    this.reportingMonth,
    this.reportEntries,
  });
}