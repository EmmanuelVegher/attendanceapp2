import 'package:isar/isar.dart';
part 'user_face.g.dart';

@collection
class UserFace {
  static const String nameKey = "user_name";
  static const String arrayKey = "user_array";

  Id id = Isar.autoIncrement;
  String? name;
  List<bool>? array;

  UserFace({this.name, this.array});

  factory UserFace.fromJson(Map<dynamic, dynamic> json) => UserFace(
        name: json[nameKey],
        array: json[arrayKey],
      );

  Map<String, dynamic> toJson() => {
        nameKey: name,
        arrayKey: array,
      };
/*
  fromJson(Map<dynamic, dynamic> json) => UserHive(
    name: json[nameKey],
    array: json[arrayKey],
  );*/
}
