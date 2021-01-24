// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    personal: json['personal'] == null
        ? null
        : Personal.fromJson(json['personal'] as Map<String, dynamic>),
    drink: json['drink'] == null
        ? null
        : Drink.fromJson(json['drink'] as Map<String, dynamic>),
    notification: json['notification'] == null
        ? null
        : Notification.fromJson(json['notification'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'personal': instance.personal?.toJson(),
      'drink': instance.drink?.toJson(),
      'notification': instance.notification?.toJson(),
    };
