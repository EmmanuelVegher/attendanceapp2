// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staffcategory.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStaffCategoryModelCollection on Isar {
  IsarCollection<StaffCategoryModel> get staffCategoryModels =>
      this.collection();
}

const StaffCategoryModelSchema = CollectionSchema(
  name: r'StaffCategoryModel',
  id: -5419849247965795295,
  properties: {
    r'staffCategory': PropertySchema(
      id: 0,
      name: r'staffCategory',
      type: IsarType.string,
    )
  },
  estimateSize: _staffCategoryModelEstimateSize,
  serialize: _staffCategoryModelSerialize,
  deserialize: _staffCategoryModelDeserialize,
  deserializeProp: _staffCategoryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'staffCategory': IndexSchema(
      id: -2311586105846973723,
      name: r'staffCategory',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'staffCategory',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _staffCategoryModelGetId,
  getLinks: _staffCategoryModelGetLinks,
  attach: _staffCategoryModelAttach,
  version: '3.1.0+1',
);

int _staffCategoryModelEstimateSize(
  StaffCategoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.staffCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _staffCategoryModelSerialize(
  StaffCategoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.staffCategory);
}

StaffCategoryModel _staffCategoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StaffCategoryModel(
    staffCategory: reader.readStringOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _staffCategoryModelDeserializeProp<P>(
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

Id _staffCategoryModelGetId(StaffCategoryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _staffCategoryModelGetLinks(
    StaffCategoryModel object) {
  return [];
}

void _staffCategoryModelAttach(
    IsarCollection<dynamic> col, Id id, StaffCategoryModel object) {
  object.id = id;
}

extension StaffCategoryModelByIndex on IsarCollection<StaffCategoryModel> {
  Future<StaffCategoryModel?> getByStaffCategory(String? staffCategory) {
    return getByIndex(r'staffCategory', [staffCategory]);
  }

  StaffCategoryModel? getByStaffCategorySync(String? staffCategory) {
    return getByIndexSync(r'staffCategory', [staffCategory]);
  }

  Future<bool> deleteByStaffCategory(String? staffCategory) {
    return deleteByIndex(r'staffCategory', [staffCategory]);
  }

  bool deleteByStaffCategorySync(String? staffCategory) {
    return deleteByIndexSync(r'staffCategory', [staffCategory]);
  }

  Future<List<StaffCategoryModel?>> getAllByStaffCategory(
      List<String?> staffCategoryValues) {
    final values = staffCategoryValues.map((e) => [e]).toList();
    return getAllByIndex(r'staffCategory', values);
  }

  List<StaffCategoryModel?> getAllByStaffCategorySync(
      List<String?> staffCategoryValues) {
    final values = staffCategoryValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'staffCategory', values);
  }

  Future<int> deleteAllByStaffCategory(List<String?> staffCategoryValues) {
    final values = staffCategoryValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'staffCategory', values);
  }

  int deleteAllByStaffCategorySync(List<String?> staffCategoryValues) {
    final values = staffCategoryValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'staffCategory', values);
  }

  Future<Id> putByStaffCategory(StaffCategoryModel object) {
    return putByIndex(r'staffCategory', object);
  }

  Id putByStaffCategorySync(StaffCategoryModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'staffCategory', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStaffCategory(List<StaffCategoryModel> objects) {
    return putAllByIndex(r'staffCategory', objects);
  }

  List<Id> putAllByStaffCategorySync(List<StaffCategoryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'staffCategory', objects, saveLinks: saveLinks);
  }
}

extension StaffCategoryModelQueryWhereSort
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QWhere> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StaffCategoryModelQueryWhere
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QWhereClause> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
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

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
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

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      staffCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'staffCategory',
        value: [null],
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      staffCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'staffCategory',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      staffCategoryEqualTo(String? staffCategory) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'staffCategory',
        value: [staffCategory],
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterWhereClause>
      staffCategoryNotEqualTo(String? staffCategory) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'staffCategory',
              lower: [],
              upper: [staffCategory],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'staffCategory',
              lower: [staffCategory],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'staffCategory',
              lower: [staffCategory],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'staffCategory',
              lower: [],
              upper: [staffCategory],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StaffCategoryModelQueryFilter
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QFilterCondition> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
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

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffCategory',
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffCategory',
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterFilterCondition>
      staffCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffCategory',
        value: '',
      ));
    });
  }
}

extension StaffCategoryModelQueryObject
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QFilterCondition> {}

extension StaffCategoryModelQueryLinks
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QFilterCondition> {}

extension StaffCategoryModelQuerySortBy
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QSortBy> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      sortByStaffCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.asc);
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      sortByStaffCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.desc);
    });
  }
}

extension StaffCategoryModelQuerySortThenBy
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QSortThenBy> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      thenByStaffCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.asc);
    });
  }

  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QAfterSortBy>
      thenByStaffCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.desc);
    });
  }
}

extension StaffCategoryModelQueryWhereDistinct
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QDistinct> {
  QueryBuilder<StaffCategoryModel, StaffCategoryModel, QDistinct>
      distinctByStaffCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffCategory',
          caseSensitive: caseSensitive);
    });
  }
}

extension StaffCategoryModelQueryProperty
    on QueryBuilder<StaffCategoryModel, StaffCategoryModel, QQueryProperty> {
  QueryBuilder<StaffCategoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StaffCategoryModel, String?, QQueryOperations>
      staffCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffCategory');
    });
  }
}
