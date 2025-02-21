// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remaining_leave_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRemainingLeaveModelCollection on Isar {
  IsarCollection<RemainingLeaveModel> get remainingLeaveModels =>
      this.collection();
}

const RemainingLeaveModelSchema = CollectionSchema(
  name: r'RemainingLeaveModel',
  id: 881136575893494613,
  properties: {
    r'annualLeaveBalance': PropertySchema(
      id: 0,
      name: r'annualLeaveBalance',
      type: IsarType.long,
    ),
    r'dateUpdated': PropertySchema(
      id: 1,
      name: r'dateUpdated',
      type: IsarType.dateTime,
    ),
    r'holidayLeaveBalance': PropertySchema(
      id: 2,
      name: r'holidayLeaveBalance',
      type: IsarType.long,
    ),
    r'maternityLeaveBalance': PropertySchema(
      id: 3,
      name: r'maternityLeaveBalance',
      type: IsarType.long,
    ),
    r'paternityLeaveBalance': PropertySchema(
      id: 4,
      name: r'paternityLeaveBalance',
      type: IsarType.long,
    ),
    r'staffId': PropertySchema(
      id: 5,
      name: r'staffId',
      type: IsarType.string,
    )
  },
  estimateSize: _remainingLeaveModelEstimateSize,
  serialize: _remainingLeaveModelSerialize,
  deserialize: _remainingLeaveModelDeserialize,
  deserializeProp: _remainingLeaveModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _remainingLeaveModelGetId,
  getLinks: _remainingLeaveModelGetLinks,
  attach: _remainingLeaveModelAttach,
  version: '3.1.0+1',
);

int _remainingLeaveModelEstimateSize(
  RemainingLeaveModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.staffId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _remainingLeaveModelSerialize(
  RemainingLeaveModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.annualLeaveBalance);
  writer.writeDateTime(offsets[1], object.dateUpdated);
  writer.writeLong(offsets[2], object.holidayLeaveBalance);
  writer.writeLong(offsets[3], object.maternityLeaveBalance);
  writer.writeLong(offsets[4], object.paternityLeaveBalance);
  writer.writeString(offsets[5], object.staffId);
}

RemainingLeaveModel _remainingLeaveModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RemainingLeaveModel();
  object.annualLeaveBalance = reader.readLongOrNull(offsets[0]);
  object.dateUpdated = reader.readDateTimeOrNull(offsets[1]);
  object.holidayLeaveBalance = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.maternityLeaveBalance = reader.readLongOrNull(offsets[3]);
  object.paternityLeaveBalance = reader.readLongOrNull(offsets[4]);
  object.staffId = reader.readStringOrNull(offsets[5]);
  return object;
}

P _remainingLeaveModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _remainingLeaveModelGetId(RemainingLeaveModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _remainingLeaveModelGetLinks(
    RemainingLeaveModel object) {
  return [];
}

void _remainingLeaveModelAttach(
    IsarCollection<dynamic> col, Id id, RemainingLeaveModel object) {
  object.id = id;
}

extension RemainingLeaveModelQueryWhereSort
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QWhere> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RemainingLeaveModelQueryWhere
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QWhereClause> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhereClause>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterWhereClause>
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

extension RemainingLeaveModelQueryFilter on QueryBuilder<RemainingLeaveModel,
    RemainingLeaveModel, QFilterCondition> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'annualLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'annualLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'annualLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'annualLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'annualLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      annualLeaveBalanceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'annualLeaveBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateUpdated',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateUpdated',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      dateUpdatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'holidayLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'holidayLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'holidayLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'holidayLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'holidayLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      holidayLeaveBalanceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'holidayLeaveBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maternityLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maternityLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      maternityLeaveBalanceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maternityLeaveBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paternityLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paternityLeaveBalance',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paternityLeaveBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      paternityLeaveBalanceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paternityLeaveBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'staffId',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
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

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'staffId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'staffId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staffId',
        value: '',
      ));
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterFilterCondition>
      staffIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'staffId',
        value: '',
      ));
    });
  }
}

extension RemainingLeaveModelQueryObject on QueryBuilder<RemainingLeaveModel,
    RemainingLeaveModel, QFilterCondition> {}

extension RemainingLeaveModelQueryLinks on QueryBuilder<RemainingLeaveModel,
    RemainingLeaveModel, QFilterCondition> {}

extension RemainingLeaveModelQuerySortBy
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QSortBy> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByAnnualLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByAnnualLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByDateUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateUpdated', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByDateUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateUpdated', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByHolidayLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holidayLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByHolidayLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holidayLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByMaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maternityLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByMaternityLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maternityLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByPaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paternityLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByPaternityLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paternityLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      sortByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }
}

extension RemainingLeaveModelQuerySortThenBy
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QSortThenBy> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByAnnualLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByAnnualLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'annualLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByDateUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateUpdated', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByDateUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateUpdated', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByHolidayLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holidayLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByHolidayLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'holidayLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByMaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maternityLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByMaternityLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maternityLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByPaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paternityLeaveBalance', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByPaternityLeaveBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paternityLeaveBalance', Sort.desc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByStaffId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.asc);
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QAfterSortBy>
      thenByStaffIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staffId', Sort.desc);
    });
  }
}

extension RemainingLeaveModelQueryWhereDistinct
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct> {
  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByAnnualLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'annualLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByDateUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateUpdated');
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByHolidayLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'holidayLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByMaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maternityLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByPaternityLeaveBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paternityLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QDistinct>
      distinctByStaffId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staffId', caseSensitive: caseSensitive);
    });
  }
}

extension RemainingLeaveModelQueryProperty
    on QueryBuilder<RemainingLeaveModel, RemainingLeaveModel, QQueryProperty> {
  QueryBuilder<RemainingLeaveModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RemainingLeaveModel, int?, QQueryOperations>
      annualLeaveBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'annualLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, DateTime?, QQueryOperations>
      dateUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateUpdated');
    });
  }

  QueryBuilder<RemainingLeaveModel, int?, QQueryOperations>
      holidayLeaveBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'holidayLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, int?, QQueryOperations>
      maternityLeaveBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maternityLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, int?, QQueryOperations>
      paternityLeaveBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paternityLeaveBalance');
    });
  }

  QueryBuilder<RemainingLeaveModel, String?, QQueryOperations>
      staffIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staffId');
    });
  }
}
