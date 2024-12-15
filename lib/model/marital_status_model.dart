import 'package:attendanceapp/model/departmentmodel.dart';
import 'package:isar/isar.dart';
part 'marital_status_model.g.dart';

@Collection()
class MaritalStatusModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? maritalStatus;


  MaritalStatusModel(
      {this.maritalStatus});

  factory MaritalStatusModel.fromJson(json) {
    return MaritalStatusModel(
        maritalStatus: json['maritalStatus']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'maritalStatus': maritalStatus
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
