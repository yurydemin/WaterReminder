// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressHistory _$ProgressHistoryFromJson(Map<String, dynamic> json) {
  return ProgressHistory();
}

Map<String, dynamic> _$ProgressHistoryToJson(ProgressHistory instance) =>
    <String, dynamic>{};

ProgressHistoryItem _$ProgressHistoryItemFromJson(Map<String, dynamic> json) {
  return ProgressHistoryItem(
    json['date'] as String,
    json['amount'] as String,
    json['progress'] as String,
  );
}

Map<String, dynamic> _$ProgressHistoryItemToJson(
        ProgressHistoryItem instance) =>
    <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'progress': instance.progress,
    };
