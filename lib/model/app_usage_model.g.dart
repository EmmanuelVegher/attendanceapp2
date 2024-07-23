// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_usage_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppUsageModelCollection on Isar {
  IsarCollection<AppUsageModel> get appUsageModels => this.collection();
}

const AppUsageModelSchema = CollectionSchema(
  name: r'AppUsageModel',
  id: -2548070758830099292,
  properties: {
    r'lastUsedDate': PropertySchema(
      id: 0,
      name: r'lastUsedDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _appUsageModelEstimateSize,
  serialize: _appUsageModelSerialize,
  deserialize: _appUsageModelDeserialize,
  deserializeProp: _appUsageModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appUsageModelGetId,
  getLinks: _appUsageModelGetLinks,
  attach: _appUsageModelAttach,
  version: '3.1.0+1',
);

int _appUsageModelEstimateSize(
  AppUsageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appUsageModelSerialize(
  AppUsageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastUsedDate);
}

AppUsageModel _appUsageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppUsageModel(
    lastUsedDate: reader.readDateTimeOrNull(offsets[0]),
  );
  object.id = id;
  return object;
}

P _appUsageModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appUsageModelGetId(AppUsageModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appUsageModelGetLinks(AppUsageModel object) {
  return [];
}

void _appUsageModelAttach(
    IsarCollection<dynamic> col, Id id, AppUsageModel object) {
  object.id = id;
}

extension AppUsageModelQueryWhereSort
    on QueryBuilder<AppUsageModel, AppUsageModel, QWhere> {
  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppUsageModelQueryWhere
    on QueryBuilder<AppUsageModel, AppUsageModel, QWhereClause> {
  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterWhereClause> idBetween(
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
}

extension AppUsageModelQueryFilter
    on QueryBuilder<AppUsageModel, AppUsageModel, QFilterCondition> {
  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
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

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsedDate',
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsedDate',
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUsedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUsedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterFilterCondition>
      lastUsedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUsedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppUsageModelQueryObject
    on QueryBuilder<AppUsageModel, AppUsageModel, QFilterCondition> {}

extension AppUsageModelQueryLinks
    on QueryBuilder<AppUsageModel, AppUsageModel, QFilterCondition> {}

extension AppUsageModelQuerySortBy
    on QueryBuilder<AppUsageModel, AppUsageModel, QSortBy> {
  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy>
      sortByLastUsedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedDate', Sort.asc);
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy>
      sortByLastUsedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedDate', Sort.desc);
    });
  }
}

extension AppUsageModelQuerySortThenBy
    on QueryBuilder<AppUsageModel, AppUsageModel, QSortThenBy> {
  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy>
      thenByLastUsedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedDate', Sort.asc);
    });
  }

  QueryBuilder<AppUsageModel, AppUsageModel, QAfterSortBy>
      thenByLastUsedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedDate', Sort.desc);
    });
  }
}

extension AppUsageModelQueryWhereDistinct
    on QueryBuilder<AppUsageModel, AppUsageModel, QDistinct> {
  QueryBuilder<AppUsageModel, AppUsageModel, QDistinct>
      distinctByLastUsedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsedDate');
    });
  }
}

extension AppUsageModelQueryProperty
    on QueryBuilder<AppUsageModel, AppUsageModel, QQueryProperty> {
  QueryBuilder<AppUsageModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppUsageModel, DateTime?, QQueryOperations>
      lastUsedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsedDate');
    });
  }
}
