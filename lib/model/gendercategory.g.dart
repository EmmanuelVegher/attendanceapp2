// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gendercategory.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGenderCategoryModelCollection on Isar {
  IsarCollection<GenderCategoryModel> get genderCategoryModels =>
      this.collection();
}

const GenderCategoryModelSchema = CollectionSchema(
  name: r'GenderCategoryModel',
  id: -7353021417041261151,
  properties: {
    r'gender': PropertySchema(
      id: 0,
      name: r'gender',
      type: IsarType.string,
    )
  },
  estimateSize: _genderCategoryModelEstimateSize,
  serialize: _genderCategoryModelSerialize,
  deserialize: _genderCategoryModelDeserialize,
  deserializeProp: _genderCategoryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'gender': IndexSchema(
      id: 2473192203104390396,
      name: r'gender',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'gender',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _genderCategoryModelGetId,
  getLinks: _genderCategoryModelGetLinks,
  attach: _genderCategoryModelAttach,
  version: '3.1.0+1',
);

int _genderCategoryModelEstimateSize(
  GenderCategoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _genderCategoryModelSerialize(
  GenderCategoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.gender);
}

GenderCategoryModel _genderCategoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GenderCategoryModel(
    gender: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _genderCategoryModelDeserializeProp<P>(
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

Id _genderCategoryModelGetId(GenderCategoryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _genderCategoryModelGetLinks(
    GenderCategoryModel object) {
  return [];
}

void _genderCategoryModelAttach(
    IsarCollection<dynamic> col, Id id, GenderCategoryModel object) {
  object.id = id;
}

extension GenderCategoryModelByIndex on IsarCollection<GenderCategoryModel> {
  Future<GenderCategoryModel?> getByGender(String? gender) {
    return getByIndex(r'gender', [gender]);
  }

  GenderCategoryModel? getByGenderSync(String? gender) {
    return getByIndexSync(r'gender', [gender]);
  }

  Future<bool> deleteByGender(String? gender) {
    return deleteByIndex(r'gender', [gender]);
  }

  bool deleteByGenderSync(String? gender) {
    return deleteByIndexSync(r'gender', [gender]);
  }

  Future<List<GenderCategoryModel?>> getAllByGender(
      List<String?> genderValues) {
    final values = genderValues.map((e) => [e]).toList();
    return getAllByIndex(r'gender', values);
  }

  List<GenderCategoryModel?> getAllByGenderSync(List<String?> genderValues) {
    final values = genderValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'gender', values);
  }

  Future<int> deleteAllByGender(List<String?> genderValues) {
    final values = genderValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'gender', values);
  }

  int deleteAllByGenderSync(List<String?> genderValues) {
    final values = genderValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'gender', values);
  }

  Future<Id> putByGender(GenderCategoryModel object) {
    return putByIndex(r'gender', object);
  }

  Id putByGenderSync(GenderCategoryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'gender', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGender(List<GenderCategoryModel> objects) {
    return putAllByIndex(r'gender', objects);
  }

  List<Id> putAllByGenderSync(List<GenderCategoryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'gender', objects, saveLinks: saveLinks);
  }
}

extension GenderCategoryModelQueryWhereSort
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QWhere> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GenderCategoryModelQueryWhere
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QWhereClause> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
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

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
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

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'gender',
        value: [null],
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'gender',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      genderEqualTo(String? gender) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'gender',
        value: [gender],
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterWhereClause>
      genderNotEqualTo(String? gender) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gender',
              lower: [],
              upper: [gender],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gender',
              lower: [gender],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gender',
              lower: [gender],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'gender',
              lower: [],
              upper: [gender],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GenderCategoryModelQueryFilter on QueryBuilder<GenderCategoryModel,
    GenderCategoryModel, QFilterCondition> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterFilterCondition>
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

extension GenderCategoryModelQueryObject on QueryBuilder<GenderCategoryModel,
    GenderCategoryModel, QFilterCondition> {}

extension GenderCategoryModelQueryLinks on QueryBuilder<GenderCategoryModel,
    GenderCategoryModel, QFilterCondition> {}

extension GenderCategoryModelQuerySortBy
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QSortBy> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }
}

extension GenderCategoryModelQuerySortThenBy
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QSortThenBy> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension GenderCategoryModelQueryWhereDistinct
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QDistinct> {
  QueryBuilder<GenderCategoryModel, GenderCategoryModel, QDistinct>
      distinctByGender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }
}

extension GenderCategoryModelQueryProperty
    on QueryBuilder<GenderCategoryModel, GenderCategoryModel, QQueryProperty> {
  QueryBuilder<GenderCategoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GenderCategoryModel, String?, QQueryOperations>
      genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }
}
