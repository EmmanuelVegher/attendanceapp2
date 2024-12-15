import 'package:isar/isar.dart';
import 'dart:convert';
import 'facility_staff_model.dart';

part 'survey_result_model.g.dart';

@collection
class SurveyResultModel {
  Id? id;

  @Index()
  DateTime? date;
  String? name;
  String? uuid;
  String? emailAddress;
  String? phoneNumber;
  String? staffCategory;
  String? state;
  String? facilityName;
  bool? isSynced;

  // JSON-encoded string to store staff list
  late String staffJson;

  @ignore // Tell Isar to ignore this computed property
  List<FacilityStaffModel>? get staff {
    if (staffJson.isNotEmpty) {
      return (jsonDecode(staffJson) as List)
          .map((data) => FacilityStaffModel.fromJson(data))
          .toList();
    }
    return null;
  }

  //@ignore // Ignore the setter too
  set staff(List<FacilityStaffModel>? value) {
    staffJson = jsonEncode(value?.map((e) => e.toJson()).toList() ?? []);
  }
}
