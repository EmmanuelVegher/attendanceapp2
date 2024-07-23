import 'package:isar/isar.dart';
part 'track_location_model.g.dart';

@collection
class TrackLocationModel {
  Id id = Isar.autoIncrement;

  final double latitude;
  final double longitude;
  final DateTime timestamp;

  TrackLocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}