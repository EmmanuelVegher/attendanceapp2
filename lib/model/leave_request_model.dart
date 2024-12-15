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
  String? firstName;
  String? lastName;
  String? staffCategory;
  String? staffState;
  String? staffLocation;
  String? staffEmail;
  String? staffPhone;
  String? staffDepartment;
  String? staffDesignation;
  String? reasonsForRejectedLeave;




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
      'firstName':firstName,
      'lastName':lastName,
      'staffCategory':staffCategory,
      'staffState':staffState,
      'staffLocation':staffLocation,
      'staffEmail':staffEmail,
      'staffPhone':staffPhone,
      'staffDepartment':staffDepartment,
      'staffDesignation':staffDesignation,
      'reasonsForRejectedLeave':reasonsForRejectedLeave





    };
  }


}