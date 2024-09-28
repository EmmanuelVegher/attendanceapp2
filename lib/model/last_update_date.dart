import 'package:isar/isar.dart';
part 'last_update_date.g.dart';

@Collection()
class LastUpdateDateModel {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  DateTime? lastUpdateDate;


  LastUpdateDateModel({
    this.lastUpdateDate,

  });

  factory LastUpdateDateModel.fromJson(json) {
    return LastUpdateDateModel(
      lastUpdateDate: json['lastUpdateDate'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'lastUpdateDate': lastUpdateDate,

    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
