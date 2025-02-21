// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychological_metrics.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPsychologicalMetricsModelCollection on Isar {
  IsarCollection<PsychologicalMetricsModel> get psychologicalMetricsModels =>
      this.collection();
}

const PsychologicalMetricsModelSchema = CollectionSchema(
  name: r'PsychologicalMetricsModel',
  id: 3486197849028192679,
  properties: {
    r'sectionsJson': PropertySchema(
      id: 0,
      name: r'sectionsJson',
      type: IsarType.string,
    )
  },
  estimateSize: _psychologicalMetricsModelEstimateSize,
  serialize: _psychologicalMetricsModelSerialize,
  deserialize: _psychologicalMetricsModelDeserialize,
  deserializeProp: _psychologicalMetricsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _psychologicalMetricsModelGetId,
  getLinks: _psychologicalMetricsModelGetLinks,
  attach: _psychologicalMetricsModelAttach,
  version: '3.1.0+1',
);

int _psychologicalMetricsModelEstimateSize(
  PsychologicalMetricsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sectionsJson.length * 3;
  return bytesCount;
}

void _psychologicalMetricsModelSerialize(
  PsychologicalMetricsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.sectionsJson);
}

PsychologicalMetricsModel _psychologicalMetricsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PsychologicalMetricsModel();
  object.id = id;
  object.sectionsJson = reader.readString(offsets[0]);
  return object;
}

P _psychologicalMetricsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _psychologicalMetricsModelGetId(PsychologicalMetricsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _psychologicalMetricsModelGetLinks(
    PsychologicalMetricsModel object) {
  return [];
}

void _psychologicalMetricsModelAttach(
    IsarCollection<dynamic> col, Id id, PsychologicalMetricsModel object) {
  object.id = id;
}

extension PsychologicalMetricsModelQueryWhereSort on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QWhere> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PsychologicalMetricsModelQueryWhere on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QWhereClause> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterWhereClause> idBetween(
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

extension PsychologicalMetricsModelQueryFilter on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QFilterCondition> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
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

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
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

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
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

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sectionsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
          QAfterFilterCondition>
      sectionsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sectionsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
          QAfterFilterCondition>
      sectionsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sectionsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectionsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterFilterCondition> sectionsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sectionsJson',
        value: '',
      ));
    });
  }
}

extension PsychologicalMetricsModelQueryObject on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QFilterCondition> {}

extension PsychologicalMetricsModelQueryLinks on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QFilterCondition> {}

extension PsychologicalMetricsModelQuerySortBy on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QSortBy> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> sortBySectionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionsJson', Sort.asc);
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> sortBySectionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionsJson', Sort.desc);
    });
  }
}

extension PsychologicalMetricsModelQuerySortThenBy on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QSortThenBy> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> thenBySectionsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionsJson', Sort.asc);
    });
  }

  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel,
      QAfterSortBy> thenBySectionsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionsJson', Sort.desc);
    });
  }
}

extension PsychologicalMetricsModelQueryWhereDistinct on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QDistinct> {
  QueryBuilder<PsychologicalMetricsModel, PsychologicalMetricsModel, QDistinct>
      distinctBySectionsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectionsJson', caseSensitive: caseSensitive);
    });
  }
}

extension PsychologicalMetricsModelQueryProperty on QueryBuilder<
    PsychologicalMetricsModel, PsychologicalMetricsModel, QQueryProperty> {
  QueryBuilder<PsychologicalMetricsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PsychologicalMetricsModel, String, QQueryOperations>
      sectionsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectionsJson');
    });
  }
}
