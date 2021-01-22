import 'package:flutter/material.dart';
import 'package:water_reminder/models/common.dart';
import 'package:water_reminder/models/math.dart';

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
}
