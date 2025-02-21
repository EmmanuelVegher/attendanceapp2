import 'package:isar/isar.dart';
part 'appversion.g.dart';

@Collection()
class AppVersionModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? appVersion;
  DateTime? appVersionDate;
  DateTime? checkDate;
  bool? latestVersion;


  AppVersionModel(
      {this.appVersion,this.appVersionDate,this.checkDate,this.latestVersion});

  factory AppVersionModel.fromJson(json) {
    return AppVersionModel(
        appVersion: json['appVersion'],
        appVersionDate: json['appVersionDate'],
        checkDate: json['checkDate'],
        latestVersion: json['latestVersion']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'appVersion': appVersion,
      'appVersionDate':appVersionDate,
      'checkDate':checkDate,
      'latestVersion':latestVersion
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
