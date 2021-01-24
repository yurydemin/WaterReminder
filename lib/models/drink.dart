import 'package:json_annotation/json_annotation.dart';

part 'drink.g.dart';

@JsonSerializable(explicitToJson: true)
class Drink {
  final int oneDrink;
  final int doubleDrink;

  Drink({this.oneDrink = 200, this.doubleDrink = 400});

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}
