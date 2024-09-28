import 'package:attendanceapp/model/statemodel.dart';
import 'package:isar/isar.dart';
part 'supervisor_model.g.dart';

@Collection()
class SupervisorModel {

  Id id = Isar.autoIncrement;
  String? supervisor;
  @Index(unique: true) // you can also use id = null to auto increment
  String? email;
  String? department;
  String? state;

  SupervisorModel(
      {this.supervisor,
        this.email,
        this.department,
        this.state

      });

  factory SupervisorModel.fromJson(json) {
    return SupervisorModel(
        supervisor: json['supervisor'],
        email: json['email'],
        department: json['department'],
        state: json['state'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'supervisor': supervisor,
      'email': email,
      'department':department,
      'state': state

    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
