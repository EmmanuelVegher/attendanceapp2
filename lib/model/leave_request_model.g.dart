// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLeaveRequestModelCollection on Isar {
  IsarCollection<LeaveRequestModel> get leaveRequestModels => this.collection();
}

const LeaveRequestModelSchema = CollectionSchema(
  name: r'LeaveRequestModel',
  id: -9183033686452534584,
  properties: {
    r'endDate': PropertySchema(
      id: 0,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'firstName': PropertySchema(
      id: 1,
      name: r'firstName',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 2,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'lastName': PropertySchema(
      id: 3,
      name: r'lastName',
      type: IsarType.string,
    ),
    r'leaveDuration': PropertySchema(
      id: 4,
      name: r'leaveDuration',
      type: IsarType.long,
    ),
    r'leaveRequestId': PropertySchema(
      id: 5,
      name: r'leaveRequestId',
      type: IsarType.string,
    ),
    r'reason': PropertySchema(
      id: 6,
      name: r'reason',
      type: IsarType.string,
    ),
    r'reasonsForRejectedLeave': PropertySchema(
      id: 7,
      name: r'reasonsForRejectedLeave',
      type: IsarType.string,
    ),
    r'selectedSupervisor': PropertySchema(
      id: 8,
      name: r'selectedSupervisor',
      type: IsarType.string,
    ),
    r'selectedSupervisorEmail': PropertySchema(
      id: 9,
      name: r'selectedSupervisorEmail',
      type: IsarType.string,
    ),
    r'staffCategory': PropertySchema(
      id: 10,
      name: r'staffCategory',
      type: IsarType.string,
    ),
    r'staffDepartment': PropertySchema(
      id: 11,
      name: r'staffDepartment',
      type: IsarType.string,
    ),
    r'staffDesignation': PropertySchema(
      id: 12,
      name: r'staffDesignation',
      type: IsarType.string,
    ),
    r'staffEmail': PropertySchema(
      id: 13,
      name: r'staffEmail',
      type: IsarType.string,
    ),
    r'staffId': PropertySchema(
      id: 14,
      name: r'staffId',
      type: IsarType.string,
    ),
    r'staffLocation': PropertySchema(
      id: 15,
      name: r'staffLocation',
      type: IsarType.string,
    ),
    r'staffPhone': PropertySchema(
      id: 16,
      name: r'staffPhone',
      type: IsarType.string,
    ),
    r'staffState': PropertySchema(
      id: 17,
      name: r'staffState',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 18,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 19,
      name: r'status',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 20,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _leaveRequestModelEstimateSize,
  serialize: _leaveRequestModelSerialize,
  deserialize: _leaveRequestModelDeserialize,
  deserializeProp: _leaveRequestModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _leaveRequestModelGetId,
  getLinks: _leaveRequestModelGetLinks,
  attach: _leaveRequestModelAttach,
  version: '3.1.0+1',
);

int _leaveRequestModelEstimateSize(
  LeaveRequestModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.firstName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.leaveRequestId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reasonsForRejectedLeave;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedSupervisor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedSupervisorEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffDepartment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffDesignation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.staffState;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _leaveRequestModelSerialize(
  LeaveRequestModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endDate);
  writer.writeString(offsets[1], object.firstName);
  writer.writeBool(offsets[2], object.isSynced);
  writer.writeString(offsets[3], object.lastName);
  writer.writeLong(offsets[4], object.leaveDuration);
  writer.writeString(offsets[5], object.leaveRequestId);
  writer.writeString(offsets[6], object.reason);
  writer.writeString(offsets[7], object.reasonsForRejectedLeave);
  writer.writeString(offsets[8], object.selectedSupervisor);
  writer.writeString(offsets[9], object.selectedSupervisorEmail);
  writer.writeString(offsets[10], object.staffCategory);
  writer.writeString(offsets[11], object.staffDepartment);
  writer.writeString(offsets[12], object.staffDesignation);
  writer.writeString(offsets[13], object.staffEmail);
  writer.writeString(offsets[14], object.staffId);
  writer.writeString(offsets[15], object.staffLocation);
  writer.writeString(offsets[16], object.staffPhone);
  writer.writeString(offsets[17], object.staffState);
  writer.writeDateTime(offsets[18], object.startDate);
  writer.writeString(offsets[19], object.status);
  writer.writeString(offsets[20], object.type);
}

LeaveRequestModel _leaveRequestModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LeaveRequestModel();
  object.endDate = reader.readDateTimeOrNull(offsets[0]);
  object.firstName = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[2]);
  object.lastName = reader.readStringOrNull(offsets[3]);
  object.leaveDuration = reader.readLongOrNull(offsets[4]);
  object.leaveRequestId = reader.readStringOrNull(offsets[5]);
  object.reason = reader.readStringOrNull(offsets[6]);
  object.reasonsForRejectedLeave = reader.readStringOrNull(offsets[7]);
  object.selectedSupervisor = reader.readStringOrNull(offsets[8]);
  object.selectedSupervisorEmail = reader.readStringOrNull(offsets[9]);
  object.staffCategory = reader.readStringOrNull(offsets[10]);
  object.staffDepartment = reader.readStringOrNull(offsets[11]);
  object.staffDesignation = reader.readStringOrNull(offsets[12]);
  object.staffEmail = reader.readStringOrNull(offsets[13]);
  object.staffId = reader.readStringOrNull(offsets[14]);
  object.staffLocation = reader.readStringOrNull(offsets[15]);
  object.staffPhone = reader.readStringOrNull(offsets[16]);
  object.staffState = reader.readStringOrNull(offsets[17]);
  object.startDate = reader.readDateTimeOrNull(offsets[18]);
  object.status = reader.readStringOrNull(offsets[19]);
  object.type = reader.readStringOrNull(offsets[20]);
  return object;
}

P _leaveRequestModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _leaveRequestModelGetId(LeaveRequestModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _leaveRequestModelGetLinks(
    LeaveRequestModel object) {
  return [];
}

void _leaveRequestModelAttach(
    IsarCollection<dynamic> col, Id id, LeaveRequestModel object) {
  object.id = id;
}

extension LeaveRequestModelQueryWhereSort
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QWhere> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LeaveRequestModelQueryWhere
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QWhereClause> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhereClause>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterWhereClause>
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
}

extension LeaveRequestModelQueryFilter
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QFilterCondition> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstName',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstName',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firstName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstName',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      firstNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firstName',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastName',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastName',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastName',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      lastNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastName',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leaveDuration',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leaveDuration',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leaveDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leaveDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leaveDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveDurationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leaveDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leaveRequestId',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leaveRequestId',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leaveRequestId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'leaveRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'leaveRequestId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leaveRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      leaveRequestIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'leaveRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reasonsForRejectedLeave',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reasonsForRejectedLeave',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reasonsForRejectedLeave',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reasonsForRejectedLeave',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reasonsForRejectedLeave',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasonsForRejectedLeave',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      reasonsForRejectedLeaveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reasonsForRejectedLeave',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedSupervisor',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedSupervisor',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedSupervisor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedSupervisor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedSupervisor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSupervisor',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedSupervisor',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedSupervisorEmail',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedSupervisorEmail',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedSupervisorEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedSupervisorEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedSupervisorEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSupervisorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      selectedSupervisorEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedSupervisorEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffCategory',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffCategory',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
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

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffDepartment',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffDepartment',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffDepartment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffDepartment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDepartmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffDesignation',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffDesignation',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffDesignation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffDesignation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffDesignation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffDesignation',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffDesignationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffDesignation',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffEmail',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffEmail',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffId',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffLocation',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffLocation',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffLocation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffLocation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffLocation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffLocation',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffPhone',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffPhone',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffState',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffState',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staffState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffState',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      staffStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffState',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      startDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension LeaveRequestModelQueryObject
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QFilterCondition> {}

extension LeaveRequestModelQueryLinks
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QFilterCondition> {}

extension LeaveRequestModelQuerySortBy
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QSortBy> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLastName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLastNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLeaveDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveDuration', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLeaveDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveDuration', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLeaveRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveRequestId', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByLeaveRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveRequestId', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByReasonsForRejectedLeave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsForRejectedLeave', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByReasonsForRejectedLeaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsForRejectedLeave', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortBySelectedSupervisor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisor', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortBySelectedSupervisorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisor', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortBySelectedSupervisorEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisorEmail', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortBySelectedSupervisorEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisorEmail', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDepartment', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDepartment', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDesignation', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDesignation', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffEmail', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffEmail', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffLocation', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffLocation', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffPhone', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffPhone', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffState', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStaffStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffState', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LeaveRequestModelQuerySortThenBy
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QSortThenBy> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLastName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLastNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLeaveDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveDuration', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLeaveDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveDuration', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLeaveRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveRequestId', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByLeaveRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaveRequestId', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByReasonsForRejectedLeave() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsForRejectedLeave', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByReasonsForRejectedLeaveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsForRejectedLeave', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenBySelectedSupervisor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisor', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenBySelectedSupervisorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisor', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenBySelectedSupervisorEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisorEmail', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenBySelectedSupervisorEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSupervisorEmail', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffCategory', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDepartment', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDepartment', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDesignation', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffDesignation', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffEmail', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffEmail', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffLocation', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffLocation', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffPhone', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffPhone', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffState', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStaffStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffState', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LeaveRequestModelQueryWhereDistinct
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct> {
  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByFirstName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByLastName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByLeaveDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leaveDuration');
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByLeaveRequestId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leaveRequestId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByReasonsForRejectedLeave({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reasonsForRejectedLeave',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctBySelectedSupervisor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedSupervisor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctBySelectedSupervisorEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedSupervisorEmail',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffDepartment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffDepartment',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffDesignation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffDesignation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffLocation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStaffState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LeaveRequestModel, LeaveRequestModel, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension LeaveRequestModelQueryProperty
    on QueryBuilder<LeaveRequestModel, LeaveRequestModel, QQueryProperty> {
  QueryBuilder<LeaveRequestModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LeaveRequestModel, DateTime?, QQueryOperations>
      endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      firstNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstName');
    });
  }

  QueryBuilder<LeaveRequestModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      lastNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastName');
    });
  }

  QueryBuilder<LeaveRequestModel, int?, QQueryOperations>
      leaveDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leaveDuration');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      leaveRequestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leaveRequestId');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations> reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      reasonsForRejectedLeaveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reasonsForRejectedLeave');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      selectedSupervisorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedSupervisor');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      selectedSupervisorEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedSupervisorEmail');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffCategory');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffDepartmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffDepartment');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffDesignationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffDesignation');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffEmail');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations> staffIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffId');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffLocation');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffPhone');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations>
      staffStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffState');
    });
  }

  QueryBuilder<LeaveRequestModel, DateTime?, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<LeaveRequestModel, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
