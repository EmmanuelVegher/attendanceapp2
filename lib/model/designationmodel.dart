import 'package:attendanceapp/model/departmentmodel.dart';
import 'package:isar/isar.dart';
part 'designationmodel.g.dart';

@Collection()
class DesignationModel {

  Id id = Isar.autoIncrement;
  String? departmentName;
  @Index(unique: true) // you can also use id = null to auto increment
  String? designationName;
  String? category;
  final statepage = IsarLink<DepartmentModel>();

  DesignationModel(
      {this.departmentName,
        this.designationName,
        this.category,

      });

  factory DesignationModel.fromJson(json) {
    return DesignationModel(
        departmentName: json['departmentName'],
        designationName: json['designationName'],
        category: json['category']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'departmentName': departmentName,
      'designationName': designationName
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
