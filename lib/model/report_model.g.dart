// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReportCollection on Isar {
  IsarCollection<Report> get reports => this.collection();
}

const ReportSchema = CollectionSchema(
  name: r'Report',
  id: 4107730612455750309,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'reportEntries': PropertySchema(
      id: 1,
      name: r'reportEntries',
      type: IsarType.objectList,
      target: r'ReportEntry',
    ),
    r'reportType': PropertySchema(
      id: 2,
      name: r'reportType',
      type: IsarType.string,
    ),
    r'reportingMonth': PropertySchema(
      id: 3,
      name: r'reportingMonth',
      type: IsarType.string,
    ),
    r'reportingWeek': PropertySchema(
      id: 4,
      name: r'reportingWeek',
      type: IsarType.string,
    )
  },
  estimateSize: _reportEstimateSize,
  serialize: _reportSerialize,
  deserialize: _reportDeserialize,
  deserializeProp: _reportDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'ReportEntry': ReportEntrySchema},
  getId: _reportGetId,
  getLinks: _reportGetLinks,
  attach: _reportAttach,
  version: '3.1.0+1',
);

int _reportEstimateSize(
  Report object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.reportEntries;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ReportEntry]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ReportEntrySchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.reportType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reportingMonth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reportingWeek;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _reportSerialize(
  Report object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeObjectList<ReportEntry>(
    offsets[1],
    allOffsets,
    ReportEntrySchema.serialize,
    object.reportEntries,
  );
  writer.writeString(offsets[2], object.reportType);
  writer.writeString(offsets[3], object.reportingMonth);
  writer.writeString(offsets[4], object.reportingWeek);
}

Report _reportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Report(
    date: reader.readDateTimeOrNull(offsets[0]),
    id: id,
    reportEntries: reader.readObjectList<ReportEntry>(
      offsets[1],
      ReportEntrySchema.deserialize,
      allOffsets,
      ReportEntry(),
    ),
    reportType: reader.readStringOrNull(offsets[2]),
    reportingMonth: reader.readStringOrNull(offsets[3]),
    reportingWeek: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _reportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readObjectList<ReportEntry>(
        offset,
        ReportEntrySchema.deserialize,
        allOffsets,
        ReportEntry(),
      )) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reportGetId(Report object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _reportGetLinks(Report object) {
  return [];
}

void _reportAttach(IsarCollection<dynamic> col, Id id, Report object) {
  object.id = id;
}

extension ReportQueryWhereSort on QueryBuilder<Report, Report, QWhere> {
  QueryBuilder<Report, Report, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReportQueryWhere on QueryBuilder<Report, Report, QWhereClause> {
  QueryBuilder<Report, Report, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Report, Report, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idBetween(
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

extension ReportQueryFilter on QueryBuilder<Report, Report, QFilterCondition> {
  QueryBuilder<Report, Report, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Report, Report, QAfterFilterCondition> reportEntriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportEntries',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportEntriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportEntries',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportEntriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportEntriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportEntriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportEntriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportEntriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportEntriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportEntries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportType',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportType',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportType',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportType',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingMonth',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportingMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingMonth',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportingMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportingMonth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportingMonth',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingMonthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingMonth',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportingMonthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingMonth',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingWeek',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingWeek',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportingWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportingWeek',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportingWeek',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> reportingWeekIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingWeek',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      reportingWeekIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingWeek',
        value: '',
      ));
    });
  }
}

extension ReportQueryObject on QueryBuilder<Report, Report, QFilterCondition> {
  QueryBuilder<Report, Report, QAfterFilterCondition> reportEntriesElement(
      FilterQuery<ReportEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'reportEntries');
    });
  }
}

extension ReportQueryLinks on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQuerySortBy on QueryBuilder<Report, Report, QSortBy> {
  QueryBuilder<Report, Report, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportingMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingMonth', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportingMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingMonth', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportingWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingWeek', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByReportingWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingWeek', Sort.desc);
    });
  }
}

extension ReportQuerySortThenBy on QueryBuilder<Report, Report, QSortThenBy> {
  QueryBuilder<Report, Report, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportType', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportingMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingMonth', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportingMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingMonth', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportingWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingWeek', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByReportingWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingWeek', Sort.desc);
    });
  }
}

extension ReportQueryWhereDistinct on QueryBuilder<Report, Report, QDistinct> {
  QueryBuilder<Report, Report, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByReportType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByReportingMonth(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingMonth',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByReportingWeek(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingWeek',
          caseSensitive: caseSensitive);
    });
  }
}

extension ReportQueryProperty on QueryBuilder<Report, Report, QQueryProperty> {
  QueryBuilder<Report, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Report, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Report, List<ReportEntry>?, QQueryOperations>
      reportEntriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportEntries');
    });
  }

  QueryBuilder<Report, String?, QQueryOperations> reportTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportType');
    });
  }

  QueryBuilder<Report, String?, QQueryOperations> reportingMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingMonth');
    });
  }

  QueryBuilder<Report, String?, QQueryOperations> reportingWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingWeek');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ReportEntrySchema = Schema(
  name: r'ReportEntry',
  id: 5754336259220280402,
  properties: {
    r'editedBy': PropertySchema(
      id: 0,
      name: r'editedBy',
      type: IsarType.string,
    ),
    r'enteredBy': PropertySchema(
      id: 1,
      name: r'enteredBy',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 2,
      name: r'key',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 3,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _reportEntryEstimateSize,
  serialize: _reportEntrySerialize,
  deserialize: _reportEntryDeserialize,
  deserializeProp: _reportEntryDeserializeProp,
);

int _reportEntryEstimateSize(
  ReportEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.editedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.enteredBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _reportEntrySerialize(
  ReportEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.editedBy);
  writer.writeString(offsets[1], object.enteredBy);
  writer.writeString(offsets[2], object.key);
  writer.writeString(offsets[3], object.value);
}

ReportEntry _reportEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReportEntry(
    editedBy: reader.readStringOrNull(offsets[0]),
    enteredBy: reader.readStringOrNull(offsets[1]),
    key: reader.readStringOrNull(offsets[2]) ?? "",
    value: reader.readStringOrNull(offsets[3]) ?? "",
  );
  return object;
}

P _reportEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ReportEntryQueryFilter
    on QueryBuilder<ReportEntry, ReportEntry, QFilterCondition> {
  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'editedBy',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'editedBy',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> editedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> editedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'editedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'editedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> editedByMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'editedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'editedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      editedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'editedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'enteredBy',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'enteredBy',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enteredBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'enteredBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'enteredBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enteredBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      enteredByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'enteredBy',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<ReportEntry, ReportEntry, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension ReportEntryQueryObject
    on QueryBuilder<ReportEntry, ReportEntry, QFilterCondition> {}
