import 'package:isar/isar.dart';
part 'projectmodel.g.dart';

@Collection()
class ProjectModel {

  Id id = Isar.autoIncrement;

  @Index(unique: true) // you can also use id = null to auto increment
  String? project;


  ProjectModel(
      {this.project});

  factory ProjectModel.fromJson(json) {
    return ProjectModel(
        project: json['project']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'project': project
    };
  }

  map(Map<String, dynamic> Function(dynamic e) param0) {}
}
