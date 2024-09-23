import 'package:isar/isar.dart';
part 'track_location_model.g.dart';

@collection
class TrackLocationModel {
  Id id = Isar.autoIncrement;

  double? latitude;
  double? longitude;
  DateTime? timestamp;
  String? locationName;
  bool? isSynched;

  TrackLocationModel({
    this.latitude,
    this.longitude,
    this.timestamp,
    this.locationName,
    this.isSynched
  });


  factory TrackLocationModel.fromJson(json) {
    return TrackLocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: json['timestamp'],
      locationName: json['locationName'],
        isSynched: json['isSynched']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'locationName': locationName,
      'isSynched': isSynched,
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}

}