// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projectmodel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProjectModelCollection on Isar {
  IsarCollection<ProjectModel> get projectModels => this.collection();
}

const ProjectModelSchema = CollectionSchema(
  name: r'ProjectModel',
  id: 1822059982794199752,
  properties: {
    r'project': PropertySchema(
      id: 0,
      name: r'project',
      type: IsarType.string,
    )
  },
  estimateSize: _projectModelEstimateSize,
  serialize: _projectModelSerialize,
  deserialize: _projectModelDeserialize,
  deserializeProp: _projectModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'project': IndexSchema(
      id: -354551204576314440,
      name: r'project',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'project',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _projectModelGetId,
  getLinks: _projectModelGetLinks,
  attach: _projectModelAttach,
  version: '3.1.0+1',
);

int _projectModelEstimateSize(
  ProjectModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.project;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _projectModelSerialize(
  ProjectModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.project);
}

ProjectModel _projectModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProjectModel(
    project: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _projectModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _projectModelGetId(ProjectModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _projectModelGetLinks(ProjectModel object) {
  return [];
}

void _projectModelAttach(
    IsarCollection<dynamic> col, Id id, ProjectModel object) {
  object.id = id;
}

extension ProjectModelByIndex on IsarCollection<ProjectModel> {
  Future<ProjectModel?> getByProject(String? project) {
    return getByIndex(r'project', [project]);
  }

  ProjectModel? getByProjectSync(String? project) {
    return getByIndexSync(r'project', [project]);
  }

  Future<bool> deleteByProject(String? project) {
    return deleteByIndex(r'project', [project]);
  }

  bool deleteByProjectSync(String? project) {
    return deleteByIndexSync(r'project', [project]);
  }

  Future<List<ProjectModel?>> getAllByProject(List<String?> projectValues) {
    final values = projectValues.map((e) => [e]).toList();
    return getAllByIndex(r'project', values);
  }

  List<ProjectModel?> getAllByProjectSync(List<String?> projectValues) {
    final values = projectValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'project', values);
  }

  Future<int> deleteAllByProject(List<String?> projectValues) {
    final values = projectValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'project', values);
  }

  int deleteAllByProjectSync(List<String?> projectValues) {
    final values = projectValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'project', values);
  }

  Future<Id> putByProject(ProjectModel object) {
    return putByIndex(r'project', object);
  }

  Id putByProjectSync(ProjectModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'project', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByProject(List<ProjectModel> objects) {
    return putAllByIndex(r'project', objects);
  }

  List<Id> putAllByProjectSync(List<ProjectModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'project', objects, saveLinks: saveLinks);
  }
}

extension ProjectModelQueryWhereSort
    on QueryBuilder<ProjectModel, ProjectModel, QWhere> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProjectModelQueryWhere
    on QueryBuilder<ProjectModel, ProjectModel, QWhereClause> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> projectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'project',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause>
      projectIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'project',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> projectEqualTo(
      String? project) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'project',
        value: [project],
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterWhereClause> projectNotEqualTo(
      String? project) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'project',
              lower: [],
              upper: [project],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'project',
              lower: [project],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'project',
              lower: [project],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'project',
              lower: [],
              upper: [project],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ProjectModelQueryFilter
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'project',
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'project',
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'project',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'project',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'project',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'project',
        value: '',
      ));
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterFilterCondition>
      projectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'project',
        value: '',
      ));
    });
  }
}

extension ProjectModelQueryObject
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {}

extension ProjectModelQueryLinks
    on QueryBuilder<ProjectModel, ProjectModel, QFilterCondition> {}

extension ProjectModelQuerySortBy
    on QueryBuilder<ProjectModel, ProjectModel, QSortBy> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByProject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'project', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> sortByProjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'project', Sort.desc);
    });
  }
}

extension ProjectModelQuerySortThenBy
    on QueryBuilder<ProjectModel, ProjectModel, QSortThenBy> {
  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByProject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'project', Sort.asc);
    });
  }

  QueryBuilder<ProjectModel, ProjectModel, QAfterSortBy> thenByProjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'project', Sort.desc);
    });
  }
}

extension ProjectModelQueryWhereDistinct
    on QueryBuilder<ProjectModel, ProjectModel, QDistinct> {
  QueryBuilder<ProjectModel, ProjectModel, QDistinct> distinctByProject(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'project', caseSensitive: caseSensitive);
    });
  }
}

extension ProjectModelQueryProperty
    on QueryBuilder<ProjectModel, ProjectModel, QQueryProperty> {
  QueryBuilder<ProjectModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProjectModel, String?, QQueryOperations> projectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'project');
    });
  }
}
