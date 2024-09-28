// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appversion.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppVersionModelCollection on Isar {
  IsarCollection<AppVersionModel> get appVersionModels => this.collection();
}

const AppVersionModelSchema = CollectionSchema(
  name: r'AppVersionModel',
  id: 3637361711694670994,
  properties: {
    r'appVersion': PropertySchema(
      id: 0,
      name: r'appVersion',
      type: IsarType.string,
    ),
    r'appVersionDate': PropertySchema(
      id: 1,
      name: r'appVersionDate',
      type: IsarType.dateTime,
    ),
    r'checkDate': PropertySchema(
      id: 2,
      name: r'checkDate',
      type: IsarType.dateTime,
    ),
    r'latestVersion': PropertySchema(
      id: 3,
      name: r'latestVersion',
      type: IsarType.bool,
    )
  },
  estimateSize: _appVersionModelEstimateSize,
  serialize: _appVersionModelSerialize,
  deserialize: _appVersionModelDeserialize,
  deserializeProp: _appVersionModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'appVersion': IndexSchema(
      id: 1858497460369256557,
      name: r'appVersion',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'appVersion',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appVersionModelGetId,
  getLinks: _appVersionModelGetLinks,
  attach: _appVersionModelAttach,
  version: '3.1.0+1',
);

int _appVersionModelEstimateSize(
  AppVersionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.appVersion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appVersionModelSerialize(
  AppVersionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appVersion);
  writer.writeDateTime(offsets[1], object.appVersionDate);
  writer.writeDateTime(offsets[2], object.checkDate);
  writer.writeBool(offsets[3], object.latestVersion);
}

AppVersionModel _appVersionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppVersionModel(
    appVersion: reader.readStringOrNull(offsets[0]),
    appVersionDate: reader.readDateTimeOrNull(offsets[1]),
    checkDate: reader.readDateTimeOrNull(offsets[2]),
    latestVersion: reader.readBoolOrNull(offsets[3]),
  );
  object.id = id;
  return object;
}

P _appVersionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appVersionModelGetId(AppVersionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appVersionModelGetLinks(AppVersionModel object) {
  return [];
}

void _appVersionModelAttach(
    IsarCollection<dynamic> col, Id id, AppVersionModel object) {
  object.id = id;
}

extension AppVersionModelByIndex on IsarCollection<AppVersionModel> {
  Future<AppVersionModel?> getByAppVersion(String? appVersion) {
    return getByIndex(r'appVersion', [appVersion]);
  }

  AppVersionModel? getByAppVersionSync(String? appVersion) {
    return getByIndexSync(r'appVersion', [appVersion]);
  }

  Future<bool> deleteByAppVersion(String? appVersion) {
    return deleteByIndex(r'appVersion', [appVersion]);
  }

  bool deleteByAppVersionSync(String? appVersion) {
    return deleteByIndexSync(r'appVersion', [appVersion]);
  }

  Future<List<AppVersionModel?>> getAllByAppVersion(
      List<String?> appVersionValues) {
    final values = appVersionValues.map((e) => [e]).toList();
    return getAllByIndex(r'appVersion', values);
  }

  List<AppVersionModel?> getAllByAppVersionSync(
      List<String?> appVersionValues) {
    final values = appVersionValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'appVersion', values);
  }

  Future<int> deleteAllByAppVersion(List<String?> appVersionValues) {
    final values = appVersionValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'appVersion', values);
  }

  int deleteAllByAppVersionSync(List<String?> appVersionValues) {
    final values = appVersionValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'appVersion', values);
  }

  Future<Id> putByAppVersion(AppVersionModel object) {
    return putByIndex(r'appVersion', object);
  }

  Id putByAppVersionSync(AppVersionModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'appVersion', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAppVersion(List<AppVersionModel> objects) {
    return putAllByIndex(r'appVersion', objects);
  }

  List<Id> putAllByAppVersionSync(List<AppVersionModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'appVersion', objects, saveLinks: saveLinks);
  }
}

extension AppVersionModelQueryWhereSort
    on QueryBuilder<AppVersionModel, AppVersionModel, QWhere> {
  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppVersionModelQueryWhere
    on QueryBuilder<AppVersionModel, AppVersionModel, QWhereClause> {
  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
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

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
      appVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'appVersion',
        value: [null],
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
      appVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'appVersion',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
      appVersionEqualTo(String? appVersion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'appVersion',
        value: [appVersion],
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterWhereClause>
      appVersionNotEqualTo(String? appVersion) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appVersion',
              lower: [],
              upper: [appVersion],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appVersion',
              lower: [appVersion],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appVersion',
              lower: [appVersion],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'appVersion',
              lower: [],
              upper: [appVersion],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppVersionModelQueryFilter
    on QueryBuilder<AppVersionModel, AppVersionModel, QFilterCondition> {
  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appVersion',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appVersion',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appVersionDate',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appVersionDate',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appVersionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appVersionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appVersionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      appVersionDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appVersionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkDate',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkDate',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      checkDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
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

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
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

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
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

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      latestVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latestVersion',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      latestVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latestVersion',
      ));
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterFilterCondition>
      latestVersionEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latestVersion',
        value: value,
      ));
    });
  }
}

extension AppVersionModelQueryObject
    on QueryBuilder<AppVersionModel, AppVersionModel, QFilterCondition> {}

extension AppVersionModelQueryLinks
    on QueryBuilder<AppVersionModel, AppVersionModel, QFilterCondition> {}

extension AppVersionModelQuerySortBy
    on QueryBuilder<AppVersionModel, AppVersionModel, QSortBy> {
  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByAppVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersion', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByAppVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersion', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByAppVersionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersionDate', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByAppVersionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersionDate', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByCheckDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDate', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByCheckDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDate', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByLatestVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestVersion', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      sortByLatestVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestVersion', Sort.desc);
    });
  }
}

extension AppVersionModelQuerySortThenBy
    on QueryBuilder<AppVersionModel, AppVersionModel, QSortThenBy> {
  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByAppVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersion', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByAppVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersion', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByAppVersionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersionDate', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByAppVersionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appVersionDate', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByCheckDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDate', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByCheckDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkDate', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByLatestVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestVersion', Sort.asc);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QAfterSortBy>
      thenByLatestVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestVersion', Sort.desc);
    });
  }
}

extension AppVersionModelQueryWhereDistinct
    on QueryBuilder<AppVersionModel, AppVersionModel, QDistinct> {
  QueryBuilder<AppVersionModel, AppVersionModel, QDistinct>
      distinctByAppVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QDistinct>
      distinctByAppVersionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appVersionDate');
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QDistinct>
      distinctByCheckDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkDate');
    });
  }

  QueryBuilder<AppVersionModel, AppVersionModel, QDistinct>
      distinctByLatestVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latestVersion');
    });
  }
}

extension AppVersionModelQueryProperty
    on QueryBuilder<AppVersionModel, AppVersionModel, QQueryProperty> {
  QueryBuilder<AppVersionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppVersionModel, String?, QQueryOperations>
      appVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appVersion');
    });
  }

  QueryBuilder<AppVersionModel, DateTime?, QQueryOperations>
      appVersionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appVersionDate');
    });
  }

  QueryBuilder<AppVersionModel, DateTime?, QQueryOperations>
      checkDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkDate');
    });
  }

  QueryBuilder<AppVersionModel, bool?, QQueryOperations>
      latestVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latestVersion');
    });
  }
}
