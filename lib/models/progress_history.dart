import 'package:json_annotation/json_annotation.dart';

part 'progress_history.g.dart';

@JsonSerializable(explicitToJson: true)
class ProgressHistory {
  List<ProgressHistoryItem> _items;

  ProgressHistory() {
    _items = [];
  }

  List<ProgressHistoryItem> get items => _items;

  void addHistoryItem(String date, String amount, String progress) {
    _items.add(ProgressHistoryItem(date, amount, progress));
  }

  factory ProgressHistory.fromJson(Map<String, dynamic> json) =>
      _$ProgressHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressHistoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProgressHistoryItem {
  final String date;
  final String amount;
  final String progress;

  ProgressHistoryItem(this.date, this.amount, this.progress);

  factory ProgressHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$ProgressHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressHistoryItemToJson(this);
}
