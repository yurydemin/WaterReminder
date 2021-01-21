import 'package:water_reminder/models/common_model.dart';

class Math {
  int _getWeightCoef(Gender gender) {}

  int _getActivityCoef(
    Gender gender,
    Activity activity,
  ) {}

  static int getRequiredWaterAmount(
    Gender gender,
    int weight,
    Activity activity,
  ) {}
}
