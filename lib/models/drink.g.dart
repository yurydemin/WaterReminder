// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drink _$DrinkFromJson(Map<String, dynamic> json) {
  return Drink(
    oneDrink: json['oneDrink'] as int,
    doubleDrink: json['doubleDrink'] as int,
  );
}

Map<String, dynamic> _$DrinkToJson(Drink instance) => <String, dynamic>{
      'oneDrink': instance.oneDrink,
      'doubleDrink': instance.doubleDrink,
    };
