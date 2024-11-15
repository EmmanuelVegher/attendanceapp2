import 'package:isar/isar.dart';
part 'leave_request_model.g.dart';

@collection
class LeaveRequestModel {
  Id id = Isar.autoIncrement;
  String? type;
  String? status = "Pending";
  DateTime? startDate;
  DateTime? endDate;
  String? reason;
  bool isSynced = false;
  String? staffId;
  String? leaveRequestId;
  String? selectedSupervisor;
  String? selectedSupervisorEmail;
  int? leaveDuration;



  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'staffId': staffId,
      'selectedSupervisor': selectedSupervisor,
      'selectedSupervisorEmail': selectedSupervisorEmail,
      'leaveDuration':leaveDuration,


    };
  }


}