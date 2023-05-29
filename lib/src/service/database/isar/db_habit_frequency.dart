import 'package:isar/isar.dart';

import '../../../model/habit_frequency.dart';

part 'db_habit_frequency.g.dart';

@embedded
class DbHabitFrequency {
  @Enumerated(EnumType.value, 'key')
  final FrequencyType type;
  final List<int> selected;

  const DbHabitFrequency({
    this.type = FrequencyType.daily,
    this.selected = const [1, 2, 3, 4, 5, 6, 7],
  });

  bool isEnabledFor(DateTime time) {
    return selected.contains(type.checkTime(time));
  }

  HabitFrequency toHabitFrequency() {
    return HabitFrequency(
      type: type,
      selected: selected,
    );
  }
}

extension HabitFrequencyExt on HabitFrequency {
  DbHabitFrequency toDbHabitFrequency() {
    return DbHabitFrequency(
      type: type,
      selected: selected,
    );
  }
}
