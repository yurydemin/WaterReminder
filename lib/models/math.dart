import 'package:water_reminder/models/common.dart';

class Math {
  static int _getWeightCoef(Gender gender) {
    return (gender == Gender.male ? 35 : 31);
  }

  static int _getAdditionalWaterAmount(
    Gender gender,
    Activity activity,
  ) {
    int genderCoef = (gender == Gender.male ? 600 : 400);
    double activityCoef;
    switch (activity) {
      case Activity.low:
        activityCoef = 0;
        break;
      case Activity.medium:
        activityCoef = 0.5;
        break;
      case Activity.high:
        activityCoef = 2.0;
        break;
      default:
        activityCoef = 0;
        break;
    }
    return (genderCoef * activityCoef).toInt();
  }

  static int _roundDownToHundred(int number) {
    int a = number % 100;
    if (a > 0) {
      return (number ~/ 100) * 100;
    }
    return number;
  }

  static int getRequiredWaterAmount(
    Gender gender,
    int weight,
    Activity activity,
  ) {
    var value = weight * _getWeightCoef(gender) +
        _getAdditionalWaterAmount(gender, activity);
    return _roundDownToHundred(value);
  }
}
