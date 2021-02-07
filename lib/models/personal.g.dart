// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Personal _$PersonalFromJson(Map<String, dynamic> json) {
  return Personal(
    _$enumDecodeNullable(_$GenderEnumMap, json['gender']),
    json['weight'] as int,
    _$enumDecodeNullable(_$ActivityEnumMap, json['activity']),
  );
}

Map<String, dynamic> _$PersonalToJson(Personal instance) => <String, dynamic>{
      'gender': _$GenderEnumMap[instance.gender],
      'weight': instance.weight,
      'activity': _$ActivityEnumMap[instance.activity],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$ActivityEnumMap = {
  Activity.low: 'low',
  Activity.medium: 'medium',
  Activity.high: 'high',
};
