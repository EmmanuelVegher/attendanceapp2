// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marital_status_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMaritalStatusModelCollection on Isar {
  IsarCollection<MaritalStatusModel> get maritalStatusModels =>
      this.collection();
}

const MaritalStatusModelSchema = CollectionSchema(
  name: r'MaritalStatusModel',
  id: 477272235920741156,
  properties: {
    r'maritalStatus': PropertySchema(
      id: 0,
      name: r'maritalStatus',
      type: IsarType.string,
    )
  },
  estimateSize: _maritalStatusModelEstimateSize,
  serialize: _maritalStatusModelSerialize,
  deserialize: _maritalStatusModelDeserialize,
  deserializeProp: _maritalStatusModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'maritalStatus': IndexSchema(
      id: -1365488850950884754,
      name: r'maritalStatus',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'maritalStatus',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _maritalStatusModelGetId,
  getLinks: _maritalStatusModelGetLinks,
  attach: _maritalStatusModelAttach,
  version: '3.1.0+1',
);

int _maritalStatusModelEstimateSize(
  MaritalStatusModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.maritalStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _maritalStatusModelSerialize(
  MaritalStatusModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.maritalStatus);
}

MaritalStatusModel _maritalStatusModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MaritalStatusModel(
    maritalStatus: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _maritalStatusModelDeserializeProp<P>(
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

Id _maritalStatusModelGetId(MaritalStatusModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _maritalStatusModelGetLinks(
    MaritalStatusModel object) {
  return [];
}

void _maritalStatusModelAttach(
    IsarCollection<dynamic> col, Id id, MaritalStatusModel object) {
  object.id = id;
}

extension MaritalStatusModelByIndex on IsarCollection<MaritalStatusModel> {
  Future<MaritalStatusModel?> getByMaritalStatus(String? maritalStatus) {
    return getByIndex(r'maritalStatus', [maritalStatus]);
  }

  MaritalStatusModel? getByMaritalStatusSync(String? maritalStatus) {
    return getByIndexSync(r'maritalStatus', [maritalStatus]);
  }

  Future<bool> deleteByMaritalStatus(String? maritalStatus) {
    return deleteByIndex(r'maritalStatus', [maritalStatus]);
  }

  bool deleteByMaritalStatusSync(String? maritalStatus) {
    return deleteByIndexSync(r'maritalStatus', [maritalStatus]);
  }

  Future<List<MaritalStatusModel?>> getAllByMaritalStatus(
      List<String?> maritalStatusValues) {
    final values = maritalStatusValues.map((e) => [e]).toList();
    return getAllByIndex(r'maritalStatus', values);
  }

  List<MaritalStatusModel?> getAllByMaritalStatusSync(
      List<String?> maritalStatusValues) {
    final values = maritalStatusValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'maritalStatus', values);
  }

  Future<int> deleteAllByMaritalStatus(List<String?> maritalStatusValues) {
    final values = maritalStatusValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'maritalStatus', values);
  }

  int deleteAllByMaritalStatusSync(List<String?> maritalStatusValues) {
    final values = maritalStatusValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'maritalStatus', values);
  }

  Future<Id> putByMaritalStatus(MaritalStatusModel object) {
    return putByIndex(r'maritalStatus', object);
  }

  Id putByMaritalStatusSync(MaritalStatusModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'maritalStatus', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMaritalStatus(List<MaritalStatusModel> objects) {
    return putAllByIndex(r'maritalStatus', objects);
  }

  List<Id> putAllByMaritalStatusSync(List<MaritalStatusModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'maritalStatus', objects, saveLinks: saveLinks);
  }
}

extension MaritalStatusModelQueryWhereSort
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QWhere> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MaritalStatusModelQueryWhere
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QWhereClause> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
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

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      maritalStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'maritalStatus',
        value: [null],
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      maritalStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'maritalStatus',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      maritalStatusEqualTo(String? maritalStatus) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'maritalStatus',
        value: [maritalStatus],
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterWhereClause>
      maritalStatusNotEqualTo(String? maritalStatus) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'maritalStatus',
              lower: [],
              upper: [maritalStatus],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'maritalStatus',
              lower: [maritalStatus],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'maritalStatus',
              lower: [maritalStatus],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'maritalStatus',
              lower: [],
              upper: [maritalStatus],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MaritalStatusModelQueryFilter
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QFilterCondition> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
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

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
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

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
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

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maritalStatus',
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maritalStatus',
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maritalStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'maritalStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'maritalStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maritalStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterFilterCondition>
      maritalStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'maritalStatus',
        value: '',
      ));
    });
  }
}

extension MaritalStatusModelQueryObject
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QFilterCondition> {}

extension MaritalStatusModelQueryLinks
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QFilterCondition> {}

extension MaritalStatusModelQuerySortBy
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QSortBy> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      sortByMaritalStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maritalStatus', Sort.asc);
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      sortByMaritalStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maritalStatus', Sort.desc);
    });
  }
}

extension MaritalStatusModelQuerySortThenBy
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QSortThenBy> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      thenByMaritalStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maritalStatus', Sort.asc);
    });
  }

  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QAfterSortBy>
      thenByMaritalStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maritalStatus', Sort.desc);
    });
  }
}

extension MaritalStatusModelQueryWhereDistinct
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QDistinct> {
  QueryBuilder<MaritalStatusModel, MaritalStatusModel, QDistinct>
      distinctByMaritalStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maritalStatus',
          caseSensitive: caseSensitive);
    });
  }
}

extension MaritalStatusModelQueryProperty
    on QueryBuilder<MaritalStatusModel, MaritalStatusModel, QQueryProperty> {
  QueryBuilder<MaritalStatusModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MaritalStatusModel, String?, QQueryOperations>
      maritalStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maritalStatus');
    });
  }
}
