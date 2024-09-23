import 'dart:convert';

class UserFields {
  static final String id = 'Id';
  static final String state = 'State';
  static final String project = 'Project';
  static final String firstName = 'First Name';
  static final String lastName = 'Last Name';
  static final String designation = 'Designation';
  static final String department = 'Department';
  static final String location = 'location';
  static final String staffCategory = 'Staff Category';
  static final String mobile = 'Mobile Number';
  static final String date = 'Date';
  static final String emailAddress = 'Email Address';
  static final String clockIn = 'Clock In Time';
  static final String clockInLatitude = 'Clock In Latitude';
  static final String clockInLongitude = 'Clock In Longitude';
  static final String clockInLocation = 'Clock In Location';
  static final String clockOut = 'Clock Out Time';
  static final String clockOutLatitude = 'Clock Out Latitude';
  static final String clockOutLongitude = 'Clock Out Longitude';
  static final String clockOutLocation = 'Clock Out Location';
  static final String durationWorked = 'Duration Worked';
  static final String noOfHours = 'Number Of Hours';
  static final String comments = 'Comments';

  static List<String> getFields() => [
        id,
        state,
        project,
        firstName,
        lastName,
        designation,
        department,
        location,
        staffCategory,
        mobile,
        date,
        emailAddress,
        clockIn,
        clockInLatitude,
        clockInLongitude,
        clockInLocation,
        clockOut,
        clockOutLatitude,
        clockOutLongitude,
        clockOutLocation,
        durationWorked,
        noOfHours,
    comments
      ];
}

class User {
  final int? id;
  final String state;
  final String project;
  final String firstName;
  final String lastName;
  final String designation;
  final String department;
  final String location;
  final String staffCategory;
  final String mobile;
  final String date;
  final String emailAddress;
  final String clockIn;
  final String clockInLatitude;
  final String clockInLongitude;
  final String clockInLocation;
  final String clockOut;
  final String clockOutLatitude;
  final String clockOutLongitude;
  final String clockOutLocation;
  final String durationWorked;
  final String noOfHours;
  final String comments;

  const User(
      {this.id,
      required this.state,
      required this.project,
      required this.firstName,
      required this.lastName,
      required this.designation,
      required this.department,
      required this.location,
      required this.staffCategory,
      required this.mobile,
      required this.date,
      required this.emailAddress,
      required this.clockIn,
      required this.clockInLatitude,
      required this.clockInLongitude,
      required this.clockInLocation,
      required this.clockOut,
      required this.clockOutLatitude,
      required this.clockOutLongitude,
      required this.clockOutLocation,
      required this.durationWorked,
      required this.noOfHours,
        required this.comments,
      });

  String toParam() =>
      "?state=$state&project=$project&firstName=$firstName&lastName=$lastName&designation=$designation&department=$department&location=$location&staffCategory=$staffCategory&mobile=$mobile&date=$date&emailAddress=$emailAddress&clockIn=$clockIn&clockInLatitude=$clockInLatitude&clockInLongitude=$clockInLongitude&clockInLocation=$clockInLocation&clockOut=$clockOut&clockOutLatitude=$clockOutLatitude&clockOutLongitude=$clockOutLongitude&clockOutLocation=$clockOutLocation&durationWorked=$durationWorked&noOfHours=$noOfHours&comments=$comments";

  User copy(
          {int? id,
          String? state,
          String? project,
          String? firstName,
          String? lastName,
          String? designation,
          String? department,
          String? location,
          String? staffCategory,
          String? mobile,
          String? date,
          String? emailAddress,
          String? clockIn,
          String? clockInLatitude,
          String? clockInLongitude,
          String? clockInLocation,
          String? clockOut,
          String? clockOutLatitude,
          String? clockOutLongitude,
          String? clockOutLocation,
          String? durationWorked,
          String? noOfHours,
          String? comments}) =>
      User(
          id: id ?? this.id,
          state: state ?? this.state,
          project: project ?? this.project,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          designation: designation ?? this.designation,
          department: department ?? this.department,
          location: location ?? this.location,
          staffCategory: staffCategory ?? this.staffCategory,
          mobile: mobile ?? this.mobile,
          date: date ?? this.date,
          emailAddress: emailAddress ?? this.emailAddress,
          clockIn: clockIn ?? this.clockIn,
          clockInLatitude: clockInLatitude ?? this.clockInLatitude,
          clockInLongitude: clockInLongitude ?? this.clockInLongitude,
          clockInLocation: clockInLocation ?? this.clockInLocation,
          clockOut: clockOut ?? this.clockOut,
          clockOutLatitude: clockOutLatitude ?? this.clockOutLatitude,
          clockOutLongitude: clockOutLongitude ?? this.clockOutLongitude,
          clockOutLocation: clockOutLocation ?? this.clockOutLocation,
          durationWorked: durationWorked ?? this.durationWorked,
          noOfHours: noOfHours ?? this.noOfHours,
        comments: comments?? this.comments
      );

  static User fromJson(Map<String, dynamic> json) => User(
        id: jsonDecode(json[UserFields.id]),
        state: json[UserFields.state],
        project: json[UserFields.project],
        firstName: json[UserFields.firstName],
        lastName: json[UserFields.lastName],
        designation: json[UserFields.designation],
        department: json[UserFields.department],
        location: json[UserFields.location],
        staffCategory: json[UserFields.staffCategory],
        mobile: json[UserFields.mobile],
        date: json[UserFields.date],
        emailAddress: json[UserFields.emailAddress],
        clockIn: json[UserFields.clockIn],
        clockInLatitude: json[UserFields.clockInLatitude],
        clockInLongitude: json[UserFields.clockInLongitude],
        clockInLocation: json[UserFields.clockInLocation],
        clockOut: json[UserFields.clockOut],
        clockOutLatitude: json[UserFields.clockOutLatitude],
        clockOutLongitude: json[UserFields.clockOutLongitude],
        clockOutLocation: json[UserFields.clockOutLocation],
        durationWorked: json[UserFields.durationWorked],
        noOfHours: json[UserFields.noOfHours],
        comments:json[UserFields.comments]
      );

  Map<String, dynamic> toJson() => {
        UserFields.id: id,
        UserFields.state: state,
        UserFields.project: project,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.designation: designation,
        UserFields.department: department,
        UserFields.location: location,
        UserFields.staffCategory: staffCategory,
        UserFields.mobile: mobile,
        UserFields.date: date,
        UserFields.emailAddress: emailAddress,
        UserFields.clockIn: clockIn,
        UserFields.clockInLatitude: clockInLatitude,
        UserFields.clockInLongitude: clockInLongitude,
        UserFields.clockInLocation: clockInLocation,
        UserFields.clockOut: clockOut,
        UserFields.clockOutLatitude: clockOutLatitude,
        UserFields.clockOutLongitude: clockOutLongitude,
        UserFields.clockOutLocation: clockOutLocation,
        UserFields.durationWorked: durationWorked,
        UserFields.noOfHours: noOfHours,
        UserFields.comments: comments,
      };
}
