// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reasonfordaysoff.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReasonForDaysOffModelCollection on Isar {
  IsarCollection<ReasonForDaysOffModel> get reasonForDaysOffModels =>
      this.collection();
}

const ReasonForDaysOffModelSchema = CollectionSchema(
  name: r'ReasonForDaysOffModel',
  id: -1243919197254354142,
  properties: {
    r'reasonForDaysOff': PropertySchema(
      id: 0,
      name: r'reasonForDaysOff',
      type: IsarType.string,
    )
  },
  estimateSize: _reasonForDaysOffModelEstimateSize,
  serialize: _reasonForDaysOffModelSerialize,
  deserialize: _reasonForDaysOffModelDeserialize,
  deserializeProp: _reasonForDaysOffModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'reasonForDaysOff': IndexSchema(
      id: -987738229383149904,
      name: r'reasonForDaysOff',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reasonForDaysOff',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _reasonForDaysOffModelGetId,
  getLinks: _reasonForDaysOffModelGetLinks,
  attach: _reasonForDaysOffModelAttach,
  version: '3.1.0+1',
);

int _reasonForDaysOffModelEstimateSize(
  ReasonForDaysOffModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.reasonForDaysOff;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _reasonForDaysOffModelSerialize(
  ReasonForDaysOffModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.reasonForDaysOff);
}

ReasonForDaysOffModel _reasonForDaysOffModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReasonForDaysOffModel(
    reasonForDaysOff: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _reasonForDaysOffModelDeserializeProp<P>(
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

Id _reasonForDaysOffModelGetId(ReasonForDaysOffModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reasonForDaysOffModelGetLinks(
    ReasonForDaysOffModel object) {
  return [];
}

void _reasonForDaysOffModelAttach(
    IsarCollection<dynamic> col, Id id, ReasonForDaysOffModel object) {
  object.id = id;
}

extension ReasonForDaysOffModelByIndex
    on IsarCollection<ReasonForDaysOffModel> {
  Future<ReasonForDaysOffModel?> getByReasonForDaysOff(
      String? reasonForDaysOff) {
    return getByIndex(r'reasonForDaysOff', [reasonForDaysOff]);
  }

  ReasonForDaysOffModel? getByReasonForDaysOffSync(String? reasonForDaysOff) {
    return getByIndexSync(r'reasonForDaysOff', [reasonForDaysOff]);
  }

  Future<bool> deleteByReasonForDaysOff(String? reasonForDaysOff) {
    return deleteByIndex(r'reasonForDaysOff', [reasonForDaysOff]);
  }

  bool deleteByReasonForDaysOffSync(String? reasonForDaysOff) {
    return deleteByIndexSync(r'reasonForDaysOff', [reasonForDaysOff]);
  }

  Future<List<ReasonForDaysOffModel?>> getAllByReasonForDaysOff(
      List<String?> reasonForDaysOffValues) {
    final values = reasonForDaysOffValues.map((e) => [e]).toList();
    return getAllByIndex(r'reasonForDaysOff', values);
  }

  List<ReasonForDaysOffModel?> getAllByReasonForDaysOffSync(
      List<String?> reasonForDaysOffValues) {
    final values = reasonForDaysOffValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reasonForDaysOff', values);
  }

  Future<int> deleteAllByReasonForDaysOff(
      List<String?> reasonForDaysOffValues) {
    final values = reasonForDaysOffValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reasonForDaysOff', values);
  }

  int deleteAllByReasonForDaysOffSync(List<String?> reasonForDaysOffValues) {
    final values = reasonForDaysOffValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reasonForDaysOff', values);
  }

  Future<Id> putByReasonForDaysOff(ReasonForDaysOffModel object) {
    return putByIndex(r'reasonForDaysOff', object);
  }

  Id putByReasonForDaysOffSync(ReasonForDaysOffModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'reasonForDaysOff', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReasonForDaysOff(
      List<ReasonForDaysOffModel> objects) {
    return putAllByIndex(r'reasonForDaysOff', objects);
  }

  List<Id> putAllByReasonForDaysOffSync(List<ReasonForDaysOffModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reasonForDaysOff', objects,
        saveLinks: saveLinks);
  }
}

extension ReasonForDaysOffModelQueryWhereSort
    on QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QWhere> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReasonForDaysOffModelQueryWhere on QueryBuilder<ReasonForDaysOffModel,
    ReasonForDaysOffModel, QWhereClause> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
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

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
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

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      reasonForDaysOffIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reasonForDaysOff',
        value: [null],
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      reasonForDaysOffIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reasonForDaysOff',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      reasonForDaysOffEqualTo(String? reasonForDaysOff) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reasonForDaysOff',
        value: [reasonForDaysOff],
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterWhereClause>
      reasonForDaysOffNotEqualTo(String? reasonForDaysOff) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reasonForDaysOff',
              lower: [],
              upper: [reasonForDaysOff],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reasonForDaysOff',
              lower: [reasonForDaysOff],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reasonForDaysOff',
              lower: [reasonForDaysOff],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reasonForDaysOff',
              lower: [],
              upper: [reasonForDaysOff],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ReasonForDaysOffModelQueryFilter on QueryBuilder<
    ReasonForDaysOffModel, ReasonForDaysOffModel, QFilterCondition> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reasonForDaysOff',
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reasonForDaysOff',
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reasonForDaysOff',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
          QAfterFilterCondition>
      reasonForDaysOffContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reasonForDaysOff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
          QAfterFilterCondition>
      reasonForDaysOffMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reasonForDaysOff',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasonForDaysOff',
        value: '',
      ));
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel,
      QAfterFilterCondition> reasonForDaysOffIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reasonForDaysOff',
        value: '',
      ));
    });
  }
}

extension ReasonForDaysOffModelQueryObject on QueryBuilder<
    ReasonForDaysOffModel, ReasonForDaysOffModel, QFilterCondition> {}

extension ReasonForDaysOffModelQueryLinks on QueryBuilder<ReasonForDaysOffModel,
    ReasonForDaysOffModel, QFilterCondition> {}

extension ReasonForDaysOffModelQuerySortBy
    on QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QSortBy> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      sortByReasonForDaysOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonForDaysOff', Sort.asc);
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      sortByReasonForDaysOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonForDaysOff', Sort.desc);
    });
  }
}

extension ReasonForDaysOffModelQuerySortThenBy
    on QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QSortThenBy> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      thenByReasonForDaysOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonForDaysOff', Sort.asc);
    });
  }

  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QAfterSortBy>
      thenByReasonForDaysOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonForDaysOff', Sort.desc);
    });
  }
}

extension ReasonForDaysOffModelQueryWhereDistinct
    on QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QDistinct> {
  QueryBuilder<ReasonForDaysOffModel, ReasonForDaysOffModel, QDistinct>
      distinctByReasonForDaysOff({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reasonForDaysOff',
          caseSensitive: caseSensitive);
    });
  }
}

extension ReasonForDaysOffModelQueryProperty on QueryBuilder<
    ReasonForDaysOffModel, ReasonForDaysOffModel, QQueryProperty> {
  QueryBuilder<ReasonForDaysOffModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReasonForDaysOffModel, String?, QQueryOperations>
      reasonForDaysOffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reasonForDaysOff');
    });
  }
}
