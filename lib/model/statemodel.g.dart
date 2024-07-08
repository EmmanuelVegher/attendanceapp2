// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statemodel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStateModelCollection on Isar {
  IsarCollection<StateModel> get stateModels => this.collection();
}

const StateModelSchema = CollectionSchema(
  name: r'StateModel',
  id: 7073699290220819961,
  properties: {
    r'hashCode': PropertySchema(
      id: 0,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'stateName': PropertySchema(
      id: 1,
      name: r'stateName',
      type: IsarType.string,
    )
  },
  estimateSize: _stateModelEstimateSize,
  serialize: _stateModelSerialize,
  deserialize: _stateModelDeserialize,
  deserializeProp: _stateModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'stateName': IndexSchema(
      id: -438629444052835162,
      name: r'stateName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stateName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'locationpage': LinkSchema(
      id: 6583296256232129643,
      name: r'locationpage',
      target: r'LocationModel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _stateModelGetId,
  getLinks: _stateModelGetLinks,
  attach: _stateModelAttach,
  version: '3.1.0+1',
);

int _stateModelEstimateSize(
  StateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.stateName.length * 3;
  return bytesCount;
}

void _stateModelSerialize(
  StateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeString(offsets[1], object.stateName);
}

StateModel _stateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StateModel();
  object.id = id;
  object.stateName = reader.readString(offsets[1]);
  return object;
}

P _stateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stateModelGetId(StateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stateModelGetLinks(StateModel object) {
  return [object.locationpage];
}

void _stateModelAttach(IsarCollection<dynamic> col, Id id, StateModel object) {
  object.id = id;
  object.locationpage
      .attach(col, col.isar.collection<LocationModel>(), r'locationpage', id);
}

extension StateModelByIndex on IsarCollection<StateModel> {
  Future<StateModel?> getByStateName(String stateName) {
    return getByIndex(r'stateName', [stateName]);
  }

  StateModel? getByStateNameSync(String stateName) {
    return getByIndexSync(r'stateName', [stateName]);
  }

  Future<bool> deleteByStateName(String stateName) {
    return deleteByIndex(r'stateName', [stateName]);
  }

  bool deleteByStateNameSync(String stateName) {
    return deleteByIndexSync(r'stateName', [stateName]);
  }

  Future<List<StateModel?>> getAllByStateName(List<String> stateNameValues) {
    final values = stateNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'stateName', values);
  }

  List<StateModel?> getAllByStateNameSync(List<String> stateNameValues) {
    final values = stateNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'stateName', values);
  }

  Future<int> deleteAllByStateName(List<String> stateNameValues) {
    final values = stateNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'stateName', values);
  }

  int deleteAllByStateNameSync(List<String> stateNameValues) {
    final values = stateNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'stateName', values);
  }

  Future<Id> putByStateName(StateModel object) {
    return putByIndex(r'stateName', object);
  }

  Id putByStateNameSync(StateModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'stateName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStateName(List<StateModel> objects) {
    return putAllByIndex(r'stateName', objects);
  }

  List<Id> putAllByStateNameSync(List<StateModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'stateName', objects, saveLinks: saveLinks);
  }
}

extension StateModelQueryWhereSort
    on QueryBuilder<StateModel, StateModel, QWhere> {
  QueryBuilder<StateModel, StateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StateModelQueryWhere
    on QueryBuilder<StateModel, StateModel, QWhereClause> {
  QueryBuilder<StateModel, StateModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> stateNameEqualTo(
      String stateName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'stateName',
        value: [stateName],
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterWhereClause> stateNameNotEqualTo(
      String stateName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateName',
              lower: [],
              upper: [stateName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateName',
              lower: [stateName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateName',
              lower: [stateName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateName',
              lower: [],
              upper: [stateName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StateModelQueryFilter
    on QueryBuilder<StateModel, StateModel, QFilterCondition> {
  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      stateNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      stateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> stateNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      stateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateName',
        value: '',
      ));
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      stateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateName',
        value: '',
      ));
    });
  }
}

extension StateModelQueryObject
    on QueryBuilder<StateModel, StateModel, QFilterCondition> {}

extension StateModelQueryLinks
    on QueryBuilder<StateModel, StateModel, QFilterCondition> {
  QueryBuilder<StateModel, StateModel, QAfterFilterCondition> locationpage(
      FilterQuery<LocationModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'locationpage');
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'locationpage', length, true, length, true);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'locationpage', 0, true, 0, true);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'locationpage', 0, false, 999999, true);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'locationpage', 0, true, length, include);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'locationpage', length, include, 999999, true);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterFilterCondition>
      locationpageLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'locationpage', lower, includeLower, upper, includeUpper);
    });
  }
}

extension StateModelQuerySortBy
    on QueryBuilder<StateModel, StateModel, QSortBy> {
  QueryBuilder<StateModel, StateModel, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> sortByStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.asc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> sortByStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.desc);
    });
  }
}

extension StateModelQuerySortThenBy
    on QueryBuilder<StateModel, StateModel, QSortThenBy> {
  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenByStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.asc);
    });
  }

  QueryBuilder<StateModel, StateModel, QAfterSortBy> thenByStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.desc);
    });
  }
}

extension StateModelQueryWhereDistinct
    on QueryBuilder<StateModel, StateModel, QDistinct> {
  QueryBuilder<StateModel, StateModel, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<StateModel, StateModel, QDistinct> distinctByStateName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateName', caseSensitive: caseSensitive);
    });
  }
}

extension StateModelQueryProperty
    on QueryBuilder<StateModel, StateModel, QQueryProperty> {
  QueryBuilder<StateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StateModel, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<StateModel, String, QQueryOperations> stateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateName');
    });
  }
}
