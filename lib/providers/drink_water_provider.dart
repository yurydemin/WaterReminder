import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:water_reminder/helpers/notifications_helper.dart';
import 'package:water_reminder/models/notification.dart' as notify_settings;
import 'package:water_reminder/models/drink.dart';
import 'package:water_reminder/models/personal.dart';
import 'package:water_reminder/models/profile.dart';
import 'package:water_reminder/models/common.dart';
import 'package:water_reminder/extensions/string_extension.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkWaterProvider extends ChangeNotifier {
  // prefs names
  final _profileName = 'profile';
  final _drinkWaterAmountCurrentName = 'drinkWaterAmountCurrent';
  final _firstRunName = 'seen';
  final _statsName = 'stats';
  final _newDayControlDateName = 'newDayControlDate';
  // prefs
  SharedPreferences _prefs;
  // new day control date
  DateTime _newDayControlDate;
  // user days progress history
  // ToDo user progress history structue
  // user drink actions history
  final int _drinkActionsHistoryMaxSize = 10;
  Queue<int> _drinkActionsHistory;
  // first run
  bool _seen;
  // all settings user profile
  Profile _profile;
  int _drinkWaterAmountCurrent;
  // -> comboboxitems
  List<String> _genderList;
  List<String> _activitiesList;
  Map<String, int> _notificationPeriodList;

  // is possible to undo drink action
  bool get isPossibleUndoDrinkAction => _drinkActionsHistory.isNotEmpty;

  // first run
  bool get seen => _seen;

  // general lists
  List<String> get genderList => _genderList;
  List<String> get activitiesList => _activitiesList;
  Map<String, int> get notificationPeriodList => _notificationPeriodList;

  // settings
  String get oneTapBottleWaterAmount =>
      (_profile == null ? '0' : _profile.drink.oneDrink.toString());
  String get doubleTapBottleWaterAmount =>
      (_profile == null ? '0' : _profile.drink.doubleDrink.toString());

  int get notificationPeriodTime =>
      (_profile == null ? 0 : _profile.notification.time);
  String get notificationPeriodTitle => (_profile == null
      ? null
      : _notificationPeriodList.keys.firstWhere(
          (k) => _notificationPeriodList[k] == _profile.notification.time));

  String get gender => (_profile == null
      ? null
      : EnumToString.convertToString(_profile.personal.gender)
          .firstLetterCap());
  String get activity => (_profile == null
      ? null
      : EnumToString.convertToString(_profile.personal.activity)
          .firstLetterCap());
  String get weight =>
      (_profile == null ? '0' : _profile.personal.weight.toString());

  // drink water params
  int get drinkWaterAmountRequired =>
      (_profile == null ? 0 : _profile.personal.waterAmount);
  int get drinkWaterAmountCurrent => _drinkWaterAmountCurrent;
  double get drinkWaterProgress {
    if (drinkWaterAmountCurrent == 0 || drinkWaterAmountRequired == 0)
      return 0.0;
    if (drinkWaterAmountCurrent >= drinkWaterAmountRequired) return 1.0;
    return (drinkWaterAmountCurrent / drinkWaterAmountRequired);
  }

  Future<void> baseInit() async {
    // fill lists
    _genderList = EnumToString.toList<Gender>(Gender.values)
        .map((value) => value.firstLetterCap())
        .toList();
    _activitiesList = EnumToString.toList<Activity>(Activity.values)
        .map((value) => value.firstLetterCap())
        .toList();
    _notificationPeriodList = {
      '1 hour': 60,
      '2 hours': 120,
      '3 hours': 180,
      '6 hours': 360,
      '12 hours': 720,
      'None': 0,
    };

    // init prefs
    _prefs = await SharedPreferences.getInstance();
    // init history
    _drinkActionsHistory = Queue<int>();
    // check first run
    _seen = _getFirstRunFlagFromPrefs();
  }

  // drink actions
  void addOneDrink() {
    addCustomDrink(_profile.drink.oneDrink);
  }

  void addDoubleDrink() {
    addCustomDrink(_profile.drink.doubleDrink);
  }

  void addCustomDrink(int addedWaterAmount) {
    // add to current water amount
    _drinkWaterAmountCurrent += addedWaterAmount;
    notifyListeners();
    // save to prefs
    _setDrinkWaterAmountCurrentToPrefs(_drinkWaterAmountCurrent);
    // save drink action to history
    _addDrinkAction(addedWaterAmount);
    // start shedule notification
    NotificationsHelper.setScheduleNotification(notificationPeriodTime)
        .then((value) => print('Schedule started with add drink'));
  }

  void undoLastDrink() {
    // subtract from current water amount
    _drinkWaterAmountCurrent -= _undoDrinkAction();
    notifyListeners();

    // save to prefs
    _setDrinkWaterAmountCurrentToPrefs(_drinkWaterAmountCurrent);
  }

  void resetCurrentProgress() {
    // save drink action to history
    _addDrinkAction(-_drinkWaterAmountCurrent);
    // reset current water amount to zero
    _resetCurrentDrinkWaterAmount();

    notifyListeners();
  }

  // work with drink actions history
  void _addDrinkAction(int addedWaterAmount) {
    // check history -> isFull ?
    if (_drinkActionsHistory.isNotEmpty &&
        (_drinkActionsHistory.length + 1) >= _drinkActionsHistoryMaxSize)
      _drinkActionsHistory.removeFirst();

    _drinkActionsHistory.add(addedWaterAmount);
  }

  int _undoDrinkAction() {
    return _drinkActionsHistory.isNotEmpty
        ? _drinkActionsHistory.removeLast()
        : 0;
  }

  // work with profile
  Future<void> initNewProfile(
    String gender,
    int weight,
    String activity,
  ) async {
    // init new profile with default settings
    _profile = await _initProfile(gender, weight, activity);

    // update current date
    _newDayControlDate = DateTime.now();
    // save newDayControlDate to prefs
    _setNewDaycontrolDateToPrefs(_newDayControlDate);
    // set drink water amount current by default
    _resetCurrentDrinkWaterAmount();

    // set first run ok
    _seen = true;
    _setFirstRunFlagToPrefs(firstRunFlag: _seen);

    notifyListeners();
  }

  void loadProfile() {
    // load profile from prefs
    _profile = _getProfileFromPrefs();

    // load current drink water amount
    _drinkWaterAmountCurrent = _getDrinkWaterAmountCurrentFromPrefs();

    // get newDayControlDate from prefs
    _newDayControlDate = _getNewDaycontrolDateFromPrefs();
    // check current date
    if (_checkDateDifference(_newDayControlDate) > 0) {
      // save yesterday progress to db
      // ToDo save local db progress history
      // update current date
      _newDayControlDate = DateTime.now();
      // save newDayControlDate to prefs
      _setNewDaycontrolDateToPrefs(_newDayControlDate);
      // reset progress
      _resetCurrentDrinkWaterAmount();
    }

    notifyListeners();
  }

  void updateProfile(
    String gender,
    int weight,
    String activity,
    int oneTapWaterAmount,
    int doubleTapWaterAmount,
    int notificationTimeM,
  ) async {
    // reinit profile from changed settings
    _profile = await _initProfile(
      gender,
      weight,
      activity,
      oneTapWaterAmount: oneTapWaterAmount,
      doubleTapWaterAmount: doubleTapWaterAmount,
      notificationTimeM: notificationTimeM,
    );
    // update prefs
    await _prefs.reload();
    // update shedule notification
    NotificationsHelper.setScheduleNotification(notificationPeriodTime)
        .then((value) => print('Schedule started with update profile'));

    notifyListeners();
  }

  Future<Profile> _initProfile(
    String gender,
    int weight,
    String activity, {
    int oneTapWaterAmount = 200,
    int doubleTapWaterAmount = 400,
    int notificationTimeM = 0,
  }) async {
    // init
    final g = EnumToString.fromString(Gender.values, gender);
    final a = EnumToString.fromString(Activity.values, activity);
    final Personal personal = Personal(g, weight, a);
    final Drink drink = Drink(
      oneDrink: oneTapWaterAmount,
      doubleDrink: doubleTapWaterAmount,
    );
    final notify_settings.Notification notification =
        notify_settings.Notification(time: notificationTimeM);
    final newProfile = Profile(personal, drink, notification);

    // save profile to prefs
    await _prefs.setString(_profileName, jsonEncode(newProfile.toJson()));

    return newProfile;
  }

  Profile _getProfileFromPrefs() {
    Map<String, dynamic> profileMap;
    final String profileStr = _prefs.getString(_profileName);
    if (profileStr != null) {
      profileMap = jsonDecode(profileStr) as Map<String, dynamic>;
    }
    if (profileMap != null) {
      final Profile profile = Profile.fromJson(profileMap);
      return profile;
    }
    return null;
  }

  void _resetCurrentDrinkWaterAmount() {
    _drinkWaterAmountCurrent = 0;
    _setDrinkWaterAmountCurrentToPrefs(_drinkWaterAmountCurrent);
  }

  void _setDrinkWaterAmountCurrentToPrefs(int value) {
    _prefs
        .setInt(_drinkWaterAmountCurrentName, value)
        .then((value) => print(value));
  }

  int _getDrinkWaterAmountCurrentFromPrefs() {
    return (_prefs.getInt(_drinkWaterAmountCurrentName) ?? 0);
  }

  void _setFirstRunFlagToPrefs({
    bool firstRunFlag = false,
  }) {
    _prefs.setBool(_firstRunName, firstRunFlag).then((value) => print(value));
  }

  bool _getFirstRunFlagFromPrefs() {
    return (_prefs.getBool(_firstRunName) ?? false);
  }

  void _setNewDaycontrolDateToPrefs(DateTime date) {
    _prefs
        .setString(_newDayControlDateName, date.toString())
        .then((value) => print(value));
  }

  DateTime _getNewDaycontrolDateFromPrefs() {
    String newDaycontrolDateString =
        (_prefs.getString(_newDayControlDateName) ?? '');
    if (newDaycontrolDateString.isEmpty) {
      return DateTime.now();
    } else
      return DateTime.parse(newDaycontrolDateString);
  }

  int _checkDateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
