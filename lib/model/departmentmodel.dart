import 'package:attendanceapp/model/designationmodel.dart';
import 'package:isar/isar.dart';


part 'departmentmodel.g.dart';

@Collection()
class DepartmentModel {
  Id id = Isar.autoIncrement;
  @Index(unique: true) // you can also use id = null to auto increment
  late String departmentName;
  final designationpage = IsarLinks<DesignationModel>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DepartmentModel &&
              runtimeType == other.runtimeType &&
              departmentName == other.departmentName;

  @override
  int get hashCode => departmentName.hashCode;
}
