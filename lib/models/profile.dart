import 'package:water_reminder/models/drink.dart';
import 'package:water_reminder/models/notification.dart';
import 'package:water_reminder/models/personal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  final Personal personal;
  final Drink drink;
  final Notification notification;

  Profile(this.personal, this.drink, this.notification);

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
