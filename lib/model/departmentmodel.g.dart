// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departmentmodel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDepartmentModelCollection on Isar {
  IsarCollection<DepartmentModel> get departmentModels => this.collection();
}

const DepartmentModelSchema = CollectionSchema(
  name: r'DepartmentModel',
  id: -3264949521414704685,
  properties: {
    r'departmentName': PropertySchema(
      id: 0,
      name: r'departmentName',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    )
  },
  estimateSize: _departmentModelEstimateSize,
  serialize: _departmentModelSerialize,
  deserialize: _departmentModelDeserialize,
  deserializeProp: _departmentModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'departmentName': IndexSchema(
      id: -4995946204002413617,
      name: r'departmentName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'departmentName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'designationpage': LinkSchema(
      id: 9204577694733768881,
      name: r'designationpage',
      target: r'DesignationModel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _departmentModelGetId,
  getLinks: _departmentModelGetLinks,
  attach: _departmentModelAttach,
  version: '3.1.0+1',
);

int _departmentModelEstimateSize(
  DepartmentModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.departmentName.length * 3;
  return bytesCount;
}

void _departmentModelSerialize(
  DepartmentModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.departmentName);
  writer.writeLong(offsets[1], object.hashCode);
}

DepartmentModel _departmentModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DepartmentModel();
  object.departmentName = reader.readString(offsets[0]);
  object.id = id;
  return object;
}

P _departmentModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _departmentModelGetId(DepartmentModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _departmentModelGetLinks(DepartmentModel object) {
  return [object.designationpage];
}

void _departmentModelAttach(
    IsarCollection<dynamic> col, Id id, DepartmentModel object) {
  object.id = id;
  object.designationpage.attach(
      col, col.isar.collection<DesignationModel>(), r'designationpage', id);
}

extension DepartmentModelByIndex on IsarCollection<DepartmentModel> {
  Future<DepartmentModel?> getByDepartmentName(String departmentName) {
    return getByIndex(r'departmentName', [departmentName]);
  }

  DepartmentModel? getByDepartmentNameSync(String departmentName) {
    return getByIndexSync(r'departmentName', [departmentName]);
  }

  Future<bool> deleteByDepartmentName(String departmentName) {
    return deleteByIndex(r'departmentName', [departmentName]);
  }

  bool deleteByDepartmentNameSync(String departmentName) {
    return deleteByIndexSync(r'departmentName', [departmentName]);
  }

  Future<List<DepartmentModel?>> getAllByDepartmentName(
      List<String> departmentNameValues) {
    final values = departmentNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'departmentName', values);
  }

  List<DepartmentModel?> getAllByDepartmentNameSync(
      List<String> departmentNameValues) {
    final values = departmentNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'departmentName', values);
  }

  Future<int> deleteAllByDepartmentName(List<String> departmentNameValues) {
    final values = departmentNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'departmentName', values);
  }

  int deleteAllByDepartmentNameSync(List<String> departmentNameValues) {
    final values = departmentNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'departmentName', values);
  }

  Future<Id> putByDepartmentName(DepartmentModel object) {
    return putByIndex(r'departmentName', object);
  }

  Id putByDepartmentNameSync(DepartmentModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'departmentName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDepartmentName(List<DepartmentModel> objects) {
    return putAllByIndex(r'departmentName', objects);
  }

  List<Id> putAllByDepartmentNameSync(List<DepartmentModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'departmentName', objects, saveLinks: saveLinks);
  }
}

extension DepartmentModelQueryWhereSort
    on QueryBuilder<DepartmentModel, DepartmentModel, QWhere> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DepartmentModelQueryWhere
    on QueryBuilder<DepartmentModel, DepartmentModel, QWhereClause> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause>
      departmentNameEqualTo(String departmentName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'departmentName',
        value: [departmentName],
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterWhereClause>
      departmentNameNotEqualTo(String departmentName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'departmentName',
              lower: [],
              upper: [departmentName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'departmentName',
              lower: [departmentName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'departmentName',
              lower: [departmentName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'departmentName',
              lower: [],
              upper: [departmentName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DepartmentModelQueryFilter
    on QueryBuilder<DepartmentModel, DepartmentModel, QFilterCondition> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'departmentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'departmentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'departmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      departmentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'departmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      idBetween(
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
}

extension DepartmentModelQueryObject
    on QueryBuilder<DepartmentModel, DepartmentModel, QFilterCondition> {}

extension DepartmentModelQueryLinks
    on QueryBuilder<DepartmentModel, DepartmentModel, QFilterCondition> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpage(FilterQuery<DesignationModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'designationpage');
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'designationpage', length, true, length, true);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'designationpage', 0, true, 0, true);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'designationpage', 0, false, 999999, true);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'designationpage', 0, true, length, include);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'designationpage', length, include, 999999, true);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterFilterCondition>
      designationpageLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'designationpage', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DepartmentModelQuerySortBy
    on QueryBuilder<DepartmentModel, DepartmentModel, QSortBy> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      sortByDepartmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.asc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      sortByDepartmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.desc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }
}

extension DepartmentModelQuerySortThenBy
    on QueryBuilder<DepartmentModel, DepartmentModel, QSortThenBy> {
  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      thenByDepartmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.asc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      thenByDepartmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.desc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DepartmentModelQueryWhereDistinct
    on QueryBuilder<DepartmentModel, DepartmentModel, QDistinct> {
  QueryBuilder<DepartmentModel, DepartmentModel, QDistinct>
      distinctByDepartmentName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'departmentName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DepartmentModel, DepartmentModel, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }
}

extension DepartmentModelQueryProperty
    on QueryBuilder<DepartmentModel, DepartmentModel, QQueryProperty> {
  QueryBuilder<DepartmentModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DepartmentModel, String, QQueryOperations>
      departmentNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'departmentName');
    });
  }

  QueryBuilder<DepartmentModel, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }
}
