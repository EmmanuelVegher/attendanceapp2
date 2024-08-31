import 'package:isar/isar.dart';
part 'attendancemodel.g.dart';

@Collection()
class AttendanceModel {
  Id id = Isar.autoIncrement;
  //@Index(unique: true) // you can also use id = null to auto increment
  String? clockIn;
  // @Index(unique: true)
  String? clockOut;

  String? clockInLocation;
  String? clockOutLocation;
  String? date;
  bool? isSynced;
  double? clockInLatitude;
  double? clockInLongitude;
  double? clockOutLatitude;
  double? clockOutLongitude;
  bool? voided;
  bool? isUpdated;
  bool? offDay;
  double? noOfHours;
  String? durationWorked;
  String? month;
  String? comments;

  AttendanceModel(
      {this.clockIn,
      this.clockOut,
      this.clockInLocation,
      this.clockOutLocation,
      this.date,
      this.isSynced,
      this.clockInLatitude,
      this.clockInLongitude,
      this.clockOutLatitude,
      this.clockOutLongitude,
      this.voided,
      this.isUpdated,
      this.offDay,
      this.noOfHours,
      this.durationWorked,
      this.month,
        this.comments
      });

  factory AttendanceModel.fromJson(json) {
    return AttendanceModel(
      clockIn: json['clockIn'],
      clockOut: json['clockOut'],
      clockInLocation: json['clockInLocation'],
      clockOutLocation: json['clockOutLocation'],
      date: json['date'],
      isSynced: json['isSynced'],
      clockInLatitude: json['clockInLatitude'],
      clockInLongitude: json['clockInLongitude'],
      clockOutLatitude: json['clockOutLatitude'],
      clockOutLongitude: json['clockOutLongitude'],
      voided: json['voided'],
      isUpdated: json['isUpdated'],
      offDay: json['offDay'],
      noOfHours: json['noOfHours'],
      durationWorked: json['durationWorked'],
      month: json['month'],
        comments:json['comments']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'clockIn': clockIn,
      'clockOut': clockOut,
      'clockInLocation': clockInLocation,
      'clockOutLocation': clockOutLocation,
      'date': date,
      'isSynced': isSynced,
      'clockInLatitude': clockInLatitude,
      'clockInLongitude': clockInLongitude,
      'clockOutLatitude': clockOutLatitude,
      'clockOutLongitude': clockOutLongitude,
      'voided': voided,
      'isUpdated': isUpdated,
      'offDay': offDay,
      'noOfHours': noOfHours,
      'durationWorked': durationWorked,
      'month': month,
      'comments':comments
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
