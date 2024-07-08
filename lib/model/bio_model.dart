import 'package:isar/isar.dart';
part 'bio_model.g.dart';

@Collection()
class BioModel {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  String? firstName;
  String? lastName;
  String? staffCategory;
  String? designation;
  String? password;
  String? state;
  String? emailAddress;
  String? role;
  String? location;
  String? firebaseAuthId;
  String? department;
  String? mobile;
  String? project;

  BioModel({
    this.firstName,
    this.lastName,
    this.staffCategory,
    this.designation,
    this.password,
    this.state,
    this.emailAddress,
    this.role,
    this.location,
    this.firebaseAuthId,
    this.department,
    this.mobile,
    this.project,
  });

  factory BioModel.fromJson(json) {
    return BioModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      staffCategory: json['staffCategory'],
      designation: json['designation'],
      password: json['password'],
      state: json['state'],
      emailAddress: json['emailAddress'],
      role: json['role'],
      location: json['location'],
      firebaseAuthId: json['firebaseAuthId'],
      department: json['department'],
      mobile: json['mobile'],
      project: json['project'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'firstName': firstName,
      'lastName': lastName,
      'staffCategory': staffCategory,
      'designation': designation,
      'password': password,
      'state': state,
      'emailAddress': emailAddress,
      'role': role,
      'location': location,
      'firebaseAuthId': firebaseAuthId,
      'department': department,
      'mobile': mobile,
      'project': project,
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
