// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'designationmodel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDesignationModelCollection on Isar {
  IsarCollection<DesignationModel> get designationModels => this.collection();
}

const DesignationModelSchema = CollectionSchema(
  name: r'DesignationModel',
  id: 3246704627169970715,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'departmentName': PropertySchema(
      id: 1,
      name: r'departmentName',
      type: IsarType.string,
    ),
    r'designationName': PropertySchema(
      id: 2,
      name: r'designationName',
      type: IsarType.string,
    )
  },
  estimateSize: _designationModelEstimateSize,
  serialize: _designationModelSerialize,
  deserialize: _designationModelDeserialize,
  deserializeProp: _designationModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'designationName': IndexSchema(
      id: 4795349918757479481,
      name: r'designationName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'designationName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'statepage': LinkSchema(
      id: -3928509768420675306,
      name: r'statepage',
      target: r'DepartmentModel',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _designationModelGetId,
  getLinks: _designationModelGetLinks,
  attach: _designationModelAttach,
  version: '3.1.0+1',
);

int _designationModelEstimateSize(
  DesignationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.departmentName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.designationName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _designationModelSerialize(
  DesignationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeString(offsets[1], object.departmentName);
  writer.writeString(offsets[2], object.designationName);
}

DesignationModel _designationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DesignationModel(
    category: reader.readStringOrNull(offsets[0]),
    departmentName: reader.readStringOrNull(offsets[1]),
    designationName: reader.readStringOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _designationModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _designationModelGetId(DesignationModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _designationModelGetLinks(DesignationModel object) {
  return [object.statepage];
}

void _designationModelAttach(
    IsarCollection<dynamic> col, Id id, DesignationModel object) {
  object.id = id;
  object.statepage
      .attach(col, col.isar.collection<DepartmentModel>(), r'statepage', id);
}

extension DesignationModelByIndex on IsarCollection<DesignationModel> {
  Future<DesignationModel?> getByDesignationName(String? designationName) {
    return getByIndex(r'designationName', [designationName]);
  }

  DesignationModel? getByDesignationNameSync(String? designationName) {
    return getByIndexSync(r'designationName', [designationName]);
  }

  Future<bool> deleteByDesignationName(String? designationName) {
    return deleteByIndex(r'designationName', [designationName]);
  }

  bool deleteByDesignationNameSync(String? designationName) {
    return deleteByIndexSync(r'designationName', [designationName]);
  }

  Future<List<DesignationModel?>> getAllByDesignationName(
      List<String?> designationNameValues) {
    final values = designationNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'designationName', values);
  }

  List<DesignationModel?> getAllByDesignationNameSync(
      List<String?> designationNameValues) {
    final values = designationNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'designationName', values);
  }

  Future<int> deleteAllByDesignationName(List<String?> designationNameValues) {
    final values = designationNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'designationName', values);
  }

  int deleteAllByDesignationNameSync(List<String?> designationNameValues) {
    final values = designationNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'designationName', values);
  }

  Future<Id> putByDesignationName(DesignationModel object) {
    return putByIndex(r'designationName', object);
  }

  Id putByDesignationNameSync(DesignationModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'designationName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDesignationName(List<DesignationModel> objects) {
    return putAllByIndex(r'designationName', objects);
  }

  List<Id> putAllByDesignationNameSync(List<DesignationModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'designationName', objects, saveLinks: saveLinks);
  }
}

extension DesignationModelQueryWhereSort
    on QueryBuilder<DesignationModel, DesignationModel, QWhere> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DesignationModelQueryWhere
    on QueryBuilder<DesignationModel, DesignationModel, QWhereClause> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
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

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      designationNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'designationName',
        value: [null],
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      designationNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'designationName',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      designationNameEqualTo(String? designationName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'designationName',
        value: [designationName],
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterWhereClause>
      designationNameNotEqualTo(String? designationName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'designationName',
              lower: [],
              upper: [designationName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'designationName',
              lower: [designationName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'designationName',
              lower: [designationName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'designationName',
              lower: [],
              upper: [designationName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DesignationModelQueryFilter
    on QueryBuilder<DesignationModel, DesignationModel, QFilterCondition> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'departmentName',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'departmentName',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'departmentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'departmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'departmentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'departmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      departmentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'departmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'designationName',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'designationName',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'designationName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'designationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'designationName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'designationName',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      designationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'designationName',
        value: '',
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
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

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
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

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
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

extension DesignationModelQueryObject
    on QueryBuilder<DesignationModel, DesignationModel, QFilterCondition> {}

extension DesignationModelQueryLinks
    on QueryBuilder<DesignationModel, DesignationModel, QFilterCondition> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      statepage(FilterQuery<DepartmentModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'statepage');
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterFilterCondition>
      statepageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'statepage', 0, true, 0, true);
    });
  }
}

extension DesignationModelQuerySortBy
    on QueryBuilder<DesignationModel, DesignationModel, QSortBy> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByDepartmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByDepartmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.desc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByDesignationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designationName', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      sortByDesignationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designationName', Sort.desc);
    });
  }
}

extension DesignationModelQuerySortThenBy
    on QueryBuilder<DesignationModel, DesignationModel, QSortThenBy> {
  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByDepartmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByDepartmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'departmentName', Sort.desc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByDesignationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designationName', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByDesignationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designationName', Sort.desc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DesignationModelQueryWhereDistinct
    on QueryBuilder<DesignationModel, DesignationModel, QDistinct> {
  QueryBuilder<DesignationModel, DesignationModel, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QDistinct>
      distinctByDepartmentName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'departmentName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DesignationModel, DesignationModel, QDistinct>
      distinctByDesignationName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'designationName',
          caseSensitive: caseSensitive);
    });
  }
}

extension DesignationModelQueryProperty
    on QueryBuilder<DesignationModel, DesignationModel, QQueryProperty> {
  QueryBuilder<DesignationModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DesignationModel, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<DesignationModel, String?, QQueryOperations>
      departmentNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'departmentName');
    });
  }

  QueryBuilder<DesignationModel, String?, QQueryOperations>
      designationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'designationName');
    });
  }
}
