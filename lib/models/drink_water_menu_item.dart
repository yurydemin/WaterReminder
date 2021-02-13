import 'package:flutter/material.dart';

enum DrinkWaterMenuChoice {
  add,
  undo,
  reset,
}

class DrinkWaterMenuItem {
  DrinkWaterMenuItem({
    this.title,
    this.icon,
    this.choice,
  });

  String title;
  IconData icon;
  DrinkWaterMenuChoice choice;
}
