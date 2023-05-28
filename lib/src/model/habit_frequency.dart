import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'habit_frequency.g.dart';

@embedded
class HabitFrequency {
  @Enumerated(EnumType.value, 'key')
  final FrequencyType type;
  final List<int> selected;
  const HabitFrequency({
    this.type = FrequencyType.daily,
    this.selected = const [1, 2, 3, 4, 5, 6, 7],
  });

  HabitFrequency copyWith({List<int>? selected}) {
    return HabitFrequency(
      selected: selected ?? this.selected,
      type: type,
    );
  }

  bool isEnabledFor(DateTime time) {
    return selected.contains(type.checkTime(time));
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.key,
      'selected': selected.toList(),
    };
  }

  factory HabitFrequency.fromJson(Map<String, dynamic> json) {
    return HabitFrequency(
      selected: (json['selected'] as List).cast<int>(),
      type: FrequencyType.parse(json['type'] as String),
    );
  }
}

enum FrequencyType {
  daily('daily'),
  monthly('monthly');

  const FrequencyType(this.key);
  final String key;

  static FrequencyType parse(String key) {
    switch (key) {
      case 'daily':
        return FrequencyType.daily;
      default:
        return FrequencyType.monthly;
    }
  }

  int checkTime(DateTime time) {
    if (this == FrequencyType.daily) {
      return time.weekday;
    } else {
      // this == FrequencyType.monthly
      return time.day;
    }
  }
}
