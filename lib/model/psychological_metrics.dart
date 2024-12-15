import 'package:isar/isar.dart';
import 'dart:convert';

part 'psychological_metrics.g.dart';

@collection
class PsychologicalMetricsModel {
  Id id = Isar.autoIncrement;


  late String sectionsJson;

  @ignore
  List<Map<String, List<Map<String, String>>>> get sections {
    if (sectionsJson.isNotEmpty) {
      return (jsonDecode(sectionsJson) as List)
          .map((section) => Map<String, List<Map<String, String>>>.from(section as Map))
          .toList();
    }
    return [];
  }

  set sections(List<Map<String, List<Map<String, String>>>> value) {
    sectionsJson = jsonEncode(value);
  }
}
