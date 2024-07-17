import 'package:isar/isar.dart';
part 'app_usage_model.g.dart';

@Collection()
class AppUsageModel {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  DateTime? lastUsedDate;


  AppUsageModel({
    this.lastUsedDate,

  });

  factory AppUsageModel.fromJson(json) {
    return AppUsageModel(
      lastUsedDate: json['lastUsedDate'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'appUsage': lastUsedDate,

    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
