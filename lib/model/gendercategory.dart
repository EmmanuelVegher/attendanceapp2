import 'package:isar/isar.dart';
part 'gendercategory.g.dart';

@Collection()
class GenderCategoryModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? gender;


  GenderCategoryModel(
      {this.gender});

  factory GenderCategoryModel.fromJson(json) {
    return GenderCategoryModel(
        gender: json['gender']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'gender': gender
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
