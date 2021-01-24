import 'package:flutter/material.dart';
import 'package:water_reminder/models/common.dart';
import 'package:water_reminder/models/math.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal.g.dart';

@JsonSerializable(explicitToJson: true)
class Personal {
  final Gender gender;
  final int weight;
  final Activity activity;
  final int waterAmount;

  Personal({
    @required this.gender,
    @required this.weight,
    @required this.activity,
  }) : waterAmount = Math.getRequiredWaterAmount(gender, weight, activity);

  factory Personal.fromJson(Map<String, dynamic> json) =>
      _$PersonalFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalToJson(this);
}
