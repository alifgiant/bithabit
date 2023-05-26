abstract class HabitFrequency {
  final String typeKey;
  final Set<int> selected;
  const HabitFrequency({required this.selected, required this.typeKey});

  HabitFrequency copyWith({Set<int>? selected});
  bool isEnabledFor(DateTime time);

  Map<String, dynamic> toMap() {
    return {
      'name': typeKey,
      'selected': selected.toList(),
    };
  }

  static HabitFrequency fromJson(Map<String, dynamic> json) {
    switch (json['name']) {
      case DailyFrequency.name:
        return DailyFrequency(selected: (json['selected'] as List).cast<int>().toSet());
      default:
        return MonthlyFrequency(selected: (json['selected'] as List).cast<int>().toSet());
    }
  }
}

class DailyFrequency extends HabitFrequency {
  static const name = 'daily';

  const DailyFrequency({
    super.selected = const {1, 2, 3, 4, 5, 6, 7},
  }) : super(typeKey: name);

  @override
  DailyFrequency copyWith({Set<int>? selected}) {
    return DailyFrequency(selected: selected ?? this.selected);
  }

  @override
  bool isEnabledFor(DateTime time) => selected.contains(time.weekday);
}

class MonthlyFrequency extends HabitFrequency {
  static const name = 'monthly';

  const MonthlyFrequency({
    super.selected = const {},
  }) : super(typeKey: name);

  @override
  MonthlyFrequency copyWith({Set<int>? selected}) {
    return MonthlyFrequency(selected: selected ?? this.selected);
  }

  @override
  bool isEnabledFor(DateTime time) => selected.contains(time.day);
}
