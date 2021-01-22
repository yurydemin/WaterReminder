import 'package:water_reminder/models/drink.dart';
import 'package:water_reminder/models/notification.dart';
import 'package:water_reminder/models/personal.dart';

class Profile {
  final Personal personal;
  final Drink drink;
  final Notification notification;

  Profile({this.personal, this.drink, this.notification});
}
