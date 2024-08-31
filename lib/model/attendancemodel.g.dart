// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendancemodel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceModelCollection on Isar {
  IsarCollection<AttendanceModel> get attendanceModels => this.collection();
}

const AttendanceModelSchema = CollectionSchema(
  name: r'AttendanceModel',
  id: -8601204094621324448,
  properties: {
    r'clockIn': PropertySchema(
      id: 0,
      name: r'clockIn',
      type: IsarType.string,
    ),
    r'clockInLatitude': PropertySchema(
      id: 1,
      name: r'clockInLatitude',
      type: IsarType.double,
    ),
    r'clockInLocation': PropertySchema(
      id: 2,
      name: r'clockInLocation',
      type: IsarType.string,
    ),
    r'clockInLongitude': PropertySchema(
      id: 3,
      name: r'clockInLongitude',
      type: IsarType.double,
    ),
    r'clockOut': PropertySchema(
      id: 4,
      name: r'clockOut',
      type: IsarType.string,
    ),
    r'clockOutLatitude': PropertySchema(
      id: 5,
      name: r'clockOutLatitude',
      type: IsarType.double,
    ),
    r'clockOutLocation': PropertySchema(
      id: 6,
      name: r'clockOutLocation',
      type: IsarType.string,
    ),
    r'clockOutLongitude': PropertySchema(
      id: 7,
      name: r'clockOutLongitude',
      type: IsarType.double,
    ),
    r'comments': PropertySchema(
      id: 8,
      name: r'comments',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 9,
      name: r'date',
      type: IsarType.string,
    ),
    r'durationWorked': PropertySchema(
      id: 10,
      name: r'durationWorked',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 11,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'isUpdated': PropertySchema(
      id: 12,
      name: r'isUpdated',
      type: IsarType.bool,
    ),
    r'month': PropertySchema(
      id: 13,
      name: r'month',
      type: IsarType.string,
    ),
    r'noOfHours': PropertySchema(
      id: 14,
      name: r'noOfHours',
      type: IsarType.double,
    ),
    r'offDay': PropertySchema(
      id: 15,
      name: r'offDay',
      type: IsarType.bool,
    ),
    r'voided': PropertySchema(
      id: 16,
      name: r'voided',
      type: IsarType.bool,
    )
  },
  estimateSize: _attendanceModelEstimateSize,
  serialize: _attendanceModelSerialize,
  deserialize: _attendanceModelDeserialize,
  deserializeProp: _attendanceModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _attendanceModelGetId,
  getLinks: _attendanceModelGetLinks,
  attach: _attendanceModelAttach,
  version: '3.1.0+1',
);

int _attendanceModelEstimateSize(
  AttendanceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.clockIn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clockInLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clockOut;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clockOutLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.comments;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.durationWorked;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.month;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _attendanceModelSerialize(
  AttendanceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clockIn);
  writer.writeDouble(offsets[1], object.clockInLatitude);
  writer.writeString(offsets[2], object.clockInLocation);
  writer.writeDouble(offsets[3], object.clockInLongitude);
  writer.writeString(offsets[4], object.clockOut);
  writer.writeDouble(offsets[5], object.clockOutLatitude);
  writer.writeString(offsets[6], object.clockOutLocation);
  writer.writeDouble(offsets[7], object.clockOutLongitude);
  writer.writeString(offsets[8], object.comments);
  writer.writeString(offsets[9], object.date);
  writer.writeString(offsets[10], object.durationWorked);
  writer.writeBool(offsets[11], object.isSynced);
  writer.writeBool(offsets[12], object.isUpdated);
  writer.writeString(offsets[13], object.month);
  writer.writeDouble(offsets[14], object.noOfHours);
  writer.writeBool(offsets[15], object.offDay);
  writer.writeBool(offsets[16], object.voided);
}

AttendanceModel _attendanceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttendanceModel(
    clockIn: reader.readStringOrNull(offsets[0]),
    clockInLatitude: reader.readDoubleOrNull(offsets[1]),
    clockInLocation: reader.readStringOrNull(offsets[2]),
    clockInLongitude: reader.readDoubleOrNull(offsets[3]),
    clockOut: reader.readStringOrNull(offsets[4]),
    clockOutLatitude: reader.readDoubleOrNull(offsets[5]),
    clockOutLocation: reader.readStringOrNull(offsets[6]),
    clockOutLongitude: reader.readDoubleOrNull(offsets[7]),
    comments: reader.readStringOrNull(offsets[8]),
    date: reader.readStringOrNull(offsets[9]),
    durationWorked: reader.readStringOrNull(offsets[10]),
    isSynced: reader.readBoolOrNull(offsets[11]),
    isUpdated: reader.readBoolOrNull(offsets[12]),
    month: reader.readStringOrNull(offsets[13]),
    noOfHours: reader.readDoubleOrNull(offsets[14]),
    offDay: reader.readBoolOrNull(offsets[15]),
    voided: reader.readBoolOrNull(offsets[16]),
  );
  object.id = id;
  return object;
}

P _attendanceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset)) as P;
    case 16:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _attendanceModelGetId(AttendanceModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceModelGetLinks(AttendanceModel object) {
  return [];
}

void _attendanceModelAttach(
    IsarCollection<dynamic> col, Id id, AttendanceModel object) {
  object.id = id;
}

extension AttendanceModelQueryWhereSort
    on QueryBuilder<AttendanceModel, AttendanceModel, QWhere> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AttendanceModelQueryWhere
    on QueryBuilder<AttendanceModel, AttendanceModel, QWhereClause> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idBetween(
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

extension AttendanceModelQueryFilter
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockIn',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockIn',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockIn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clockIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clockIn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockIn',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clockIn',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockInLatitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockInLatitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockInLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockInLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockInLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLatitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockInLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockInLocation',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockInLocation',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockInLocation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clockInLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clockInLocation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockInLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clockInLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockInLongitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockInLongitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockInLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockInLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockInLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockInLongitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockInLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockOut',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockOut',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockOut',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clockOut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clockOut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOut',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clockOut',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockOutLatitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockOutLatitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOutLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockOutLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockOutLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLatitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockOutLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockOutLocation',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockOutLocation',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockOutLocation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clockOutLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clockOutLocation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOutLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clockOutLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clockOutLongitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clockOutLongitude',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clockOutLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clockOutLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clockOutLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      clockOutLongitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clockOutLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comments',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comments',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comments',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comments',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comments',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comments',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      commentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comments',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationWorked',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationWorked',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationWorked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'durationWorked',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'durationWorked',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationWorked',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      durationWorkedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'durationWorked',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isSyncedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isSynced',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isSyncedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isSynced',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isSyncedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isUpdated',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isUpdated',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      isUpdatedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'month',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'month',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'month',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      monthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'month',
        value: '',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noOfHours',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noOfHours',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noOfHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noOfHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noOfHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      noOfHoursBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noOfHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      offDayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'offDay',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      offDayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'offDay',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      offDayEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offDay',
        value: value,
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      voidedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'voided',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      voidedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'voided',
      ));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
      voidedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voided',
        value: value,
      ));
    });
  }
}

extension AttendanceModelQueryObject
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {}

extension AttendanceModelQueryLinks
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {}

extension AttendanceModelQuerySortBy
    on QueryBuilder<AttendanceModel, AttendanceModel, QSortBy> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByClockIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLatitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLatitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLocation', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLocation', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLongitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockInLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLongitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLatitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLatitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLocation', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLocation', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLongitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByClockOutLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLongitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByDurationWorked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWorked', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByDurationWorkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWorked', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByIsUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpdated', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByIsUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpdated', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByNoOfHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noOfHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByNoOfHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noOfHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByOffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offDay', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByOffDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offDay', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByVoided() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voided', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      sortByVoidedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voided', Sort.desc);
    });
  }
}

extension AttendanceModelQuerySortThenBy
    on QueryBuilder<AttendanceModel, AttendanceModel, QSortThenBy> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByClockIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLatitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLatitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLocation', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLocation', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLongitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockInLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockInLongitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLatitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLatitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLocation', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLocation', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLongitude', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByClockOutLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clockOutLongitude', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByComments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByCommentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comments', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByDurationWorked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWorked', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByDurationWorkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWorked', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByIsUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpdated', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByIsUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUpdated', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByNoOfHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noOfHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByNoOfHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noOfHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByOffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offDay', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByOffDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'offDay', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByVoided() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voided', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
      thenByVoidedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voided', Sort.desc);
    });
  }
}

extension AttendanceModelQueryWhereDistinct
    on QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> {
  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByClockIn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockIn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockInLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockInLatitude');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockInLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockInLocation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockInLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockInLongitude');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByClockOut(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockOut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockOutLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockOutLatitude');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockOutLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockOutLocation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByClockOutLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clockOutLongitude');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByComments(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comments', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByDurationWorked({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationWorked',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByIsUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUpdated');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByMonth(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
      distinctByNoOfHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noOfHours');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByOffDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offDay');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByVoided() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voided');
    });
  }
}

extension AttendanceModelQueryProperty
    on QueryBuilder<AttendanceModel, AttendanceModel, QQueryProperty> {
  QueryBuilder<AttendanceModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> clockInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockIn');
    });
  }

  QueryBuilder<AttendanceModel, double?, QQueryOperations>
      clockInLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockInLatitude');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations>
      clockInLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockInLocation');
    });
  }

  QueryBuilder<AttendanceModel, double?, QQueryOperations>
      clockInLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockInLongitude');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> clockOutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockOut');
    });
  }

  QueryBuilder<AttendanceModel, double?, QQueryOperations>
      clockOutLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockOutLatitude');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations>
      clockOutLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockOutLocation');
    });
  }

  QueryBuilder<AttendanceModel, double?, QQueryOperations>
      clockOutLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clockOutLongitude');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> commentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comments');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations>
      durationWorkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationWorked');
    });
  }

  QueryBuilder<AttendanceModel, bool?, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<AttendanceModel, bool?, QQueryOperations> isUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUpdated');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<AttendanceModel, double?, QQueryOperations> noOfHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noOfHours');
    });
  }

  QueryBuilder<AttendanceModel, bool?, QQueryOperations> offDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offDay');
    });
  }

  QueryBuilder<AttendanceModel, bool?, QQueryOperations> voidedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voided');
    });
  }
}
