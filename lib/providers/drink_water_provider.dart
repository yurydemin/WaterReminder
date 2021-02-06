import 'package:flutter/material.dart';
import 'package:water_reminder/models/profile.dart';
import 'package:water_reminder/models/common.dart';
import 'package:water_reminder/extensions/string_extension.dart';
import 'package:enum_to_string/enum_to_string.dart';

class DrinkWaterProvider extends ChangeNotifier {
  // all settings user profile
  Profile _profile;
  // enums -> comboboxitem
  List<String> _genderList;
  List<String> _activitiesList;
  Map<String, int> _notificationPeriodList;

  Profile get drinkWaterProfile => _profile;
  List<String> get genderList => _genderList;
  List<String> get activitiesList => _activitiesList;
  Map<String, int> get notificationPeriodList => _notificationPeriodList;

  void baseInit() {
    _genderList = EnumToString.toList<Gender>(Gender.values)
        .map((value) => value.firstLetterCap())
        .toList();
    _activitiesList = EnumToString.toList<Activity>(Activity.values)
        .map((value) => value.firstLetterCap())
        .toList();
    _notificationPeriodList = {
      '1 hour': 1,
      '2 hours': 2,
      '3 hours': 3,
      '6 hours': 6,
      '12 hours': 12,
      'None': 0,
    };
    notifyListeners();
  }

  void initNewProfile() {
    notifyListeners();
  }

  void loadProfile() {
    notifyListeners();
  }

  void updateProfile() {
    notifyListeners();
  }
}
