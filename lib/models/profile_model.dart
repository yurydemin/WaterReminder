import 'package:flutter/material.dart';
import 'package:water_reminder/models/common_model.dart';

class Profile {
  final Gender gender;
  final int weight;
  final Activity activity;
  //final int requiredWaterAmount;

  Profile({
    @required this.gender,
    @required this.weight,
    @required this.activity,
  });
}
