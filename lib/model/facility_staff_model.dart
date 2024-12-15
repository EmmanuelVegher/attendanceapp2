import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'facility_staff_model.g.dart';

@JsonSerializable() // VERY IMPORTANT! Add this annotation
@collection
class FacilityStaffModel {

  Id id = Isar.autoIncrement;

  String? name;
  String? state;
  String? facilityName;
  String? userId;
  String? designation;


  FacilityStaffModel(
      {
        this.name,
        this.state,
        this.facilityName,
        this.userId,
        this.designation

      });

  factory FacilityStaffModel.fromJson(Map<String, dynamic> json) {
    return FacilityStaffModel(
        name: json['name'] as String?,
      state: json['state'] as String?,
      facilityName: json['facilityName'] as String?,
      userId: json['userId'] as String?,
      designation: json['designation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'name': name,
      'state': state,
      'facilityName': facilityName,
      'userId': userId,
      'designation': designation,
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
