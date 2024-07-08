class Attendance {
  int? id;
  String? clockIn;
  String? clockOut;
  String? clockInLocation;
  String? clockOutLocation;
  String? date;
  int? isSynced;
  String? clockInLatitude;
  String? clockInLongitude;
  String? clockOutLatitude;
  String? clockOutLongitude;

  Attendance({
    this.id,
    this.clockIn,
    this.clockOut,
    this.clockInLocation,
    this.clockOutLocation,
    this.date,
    this.isSynced,
    this.clockInLatitude,
    this.clockInLongitude,
    this.clockOutLatitude,
    this.clockOutLongitude,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clockIn = json["clockIn"];
    clockOut = json["clockOut"];
    clockInLocation = json["clockInLocation"];
    clockOutLocation = json["clockOutLocation"];
    date = json["date"];
    isSynced = json["isSynced"];
    clockInLatitude = json["clockInLatitude"];
    clockInLongitude = json["clockInLongitude"];
    clockOutLatitude = json["clockOutLatitude"];
    clockOutLongitude = json["clockOutLongitude"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["clockIn"] = this.clockIn;
    data["clockOut"] = this.clockOut;
    data["clockInLocation"] = this.clockInLocation;
    data["clockOutLocation"] = this.clockOutLocation;
    data["date"] = this.date;
    data["isSynced"] = this.isSynced;
    data["clockInLatitude"] = this.clockInLatitude;
    data["clockInLongitude"] = this.clockInLongitude;
    data["clockOutLatitude"] = this.clockOutLatitude;
    data["clockOutLongitude"] = this.clockOutLongitude;

    return data;
  }
}
