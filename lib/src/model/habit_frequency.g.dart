// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_frequency.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HabitFrequencySchema = Schema(
  name: r'HabitFrequency',
  id: 4386631787166777847,
  properties: {
    r'selected': PropertySchema(
      id: 0,
      name: r'selected',
      type: IsarType.longList,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.string,
      enumMap: _HabitFrequencytypeEnumValueMap,
    )
  },
  estimateSize: _habitFrequencyEstimateSize,
  serialize: _habitFrequencySerialize,
  deserialize: _habitFrequencyDeserialize,
  deserializeProp: _habitFrequencyDeserializeProp,
);

int _habitFrequencyEstimateSize(
  HabitFrequency object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.selected.length * 8;
  bytesCount += 3 + object.type.key.length * 3;
  return bytesCount;
}

void _habitFrequencySerialize(
  HabitFrequency object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.selected);
  writer.writeString(offsets[1], object.type.key);
}

HabitFrequency _habitFrequencyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitFrequency(
    selected: reader.readLongList(offsets[0]) ?? const [1, 2, 3, 4, 5, 6, 7],
    type:
        _HabitFrequencytypeValueEnumMap[reader.readStringOrNull(offsets[1])] ??
            FrequencyType.daily,
  );
  return object;
}

P _habitFrequencyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? const [1, 2, 3, 4, 5, 6, 7]) as P;
    case 1:
      return (_HabitFrequencytypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          FrequencyType.daily) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HabitFrequencytypeEnumValueMap = {
  r'daily': r'daily',
  r'monthly': r'monthly',
};
const _HabitFrequencytypeValueEnumMap = {
  r'daily': FrequencyType.daily,
  r'monthly': FrequencyType.monthly,
};

extension HabitFrequencyQueryFilter
    on QueryBuilder<HabitFrequency, HabitFrequency, QFilterCondition> {
  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selected',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selected',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selected',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      selectedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selected',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeEqualTo(
    FrequencyType value, {
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeGreaterThan(
    FrequencyType value, {
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeLessThan(
    FrequencyType value, {
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeBetween(
    FrequencyType lower,
    FrequencyType upper, {
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
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

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitFrequency, HabitFrequency, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension HabitFrequencyQueryObject
    on QueryBuilder<HabitFrequency, HabitFrequency, QFilterCondition> {}
