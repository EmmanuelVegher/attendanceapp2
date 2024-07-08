import 'package:attendanceapp/model/locationmodel.dart';
import 'package:isar/isar.dart';

part 'statemodel.g.dart';

@Collection()
class StateModel {
  Id id = Isar.autoIncrement;
  @Index(unique: true) // you can also use id = null to auto increment
  late String stateName;
  final locationpage = IsarLinks<LocationModel>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateModel &&
          runtimeType == other.runtimeType &&
          stateName == other.stateName;

  @override
  int get hashCode => stateName.hashCode;
}
