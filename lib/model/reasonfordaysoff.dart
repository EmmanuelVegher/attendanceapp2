import 'package:isar/isar.dart';
part 'reasonfordaysoff.g.dart';

@Collection()
class ReasonForDaysOffModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? reasonForDaysOff;


  ReasonForDaysOffModel(
      {this.reasonForDaysOff});

  factory ReasonForDaysOffModel.fromJson(json) {
    return ReasonForDaysOffModel(
        reasonForDaysOff: json['reasonForDaysOff']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'reasonForDaysOff': reasonForDaysOff
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
