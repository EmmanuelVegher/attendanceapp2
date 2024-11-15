import 'package:isar/isar.dart';
part 'remaining_leave_model.g.dart';

@collection
class RemainingLeaveModel {
  Id id = Isar.autoIncrement;
  String? staffId;
  int? paternityLeaveBalance;
  int? maternityLeaveBalance;
  int? annualLeaveBalance;
  int? holidayLeaveBalance;


  Map<String, dynamic> toJson() {
    return {
      'staffId':staffId,
      'paternityLeaveBalance': paternityLeaveBalance,
      'maternityLeaveBalance': maternityLeaveBalance,
      'annualLeaveBalance': annualLeaveBalance,
      'holidayLeaveBalance': holidayLeaveBalance,

    };
  }


}