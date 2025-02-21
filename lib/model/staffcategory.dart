import 'package:isar/isar.dart';
part 'staffcategory.g.dart';

@Collection()
class StaffCategoryModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? staffCategory;


  StaffCategoryModel(
      {this.staffCategory});

  factory StaffCategoryModel.fromJson(json) {
    return StaffCategoryModel(
        staffCategory: json['staffCategory']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'staffCategory': staffCategory
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
