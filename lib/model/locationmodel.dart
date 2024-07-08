import 'package:attendanceapp/model/statemodel.dart';
import 'package:isar/isar.dart';
part 'locationmodel.g.dart';

@Collection()
class LocationModel {

  Id id = Isar.autoIncrement;
  String? state;
  @Index(unique: true) // you can also use id = null to auto increment
  String? locationName;
  double? latitude;
  double? longitude;
  double? radius;
  final statepage = IsarLink<StateModel>();

  LocationModel(
      {this.state,
      this.locationName,
      this.latitude,
      this.longitude,
      this.radius});

  factory LocationModel.fromJson(json) {
    return LocationModel(
      state: json['state'],
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'state': state,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
