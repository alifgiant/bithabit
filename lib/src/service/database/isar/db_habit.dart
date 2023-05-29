import 'package:bithabit/src/model/habit.dart';
import 'package:isar/isar.dart';

import '../../../model/habit_color.dart';
import '../../../model/habit_state.dart';
import 'db_habit_frequency.dart';
import 'db_habit_reminder.dart';

part 'db_habit.g.dart';

@collection
class DbHabit {
  final Id id; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  final String name;
  @Enumerated(EnumType.value, 'key')
  final HabitColor color;
  @Enumerated(EnumType.value, 'key')
  final HabitState state;
  final DbHabitFrequency frequency;
  final List<DbHabitReminder> reminder;

  DbHabit(
    this.name,
    this.color, {
    this.id = Isar.autoIncrement,
    this.state = HabitState.enabled,
    this.frequency = const DbHabitFrequency(),
    this.reminder = const [],
  });

  DbHabit copy({
    int? id,
    String? name,
    HabitColor? color,
    HabitState? state,
    DbHabitFrequency? frequency,
    List<DbHabitReminder>? reminder,
  }) {
    return DbHabit(
      name ?? this.name,
      color ?? this.color,
      id: id ?? this.id,
      state: state ?? this.state,
      frequency: frequency ?? this.frequency,
      reminder: reminder ?? this.reminder.toList(),
    );
  }

  bool get isEnabled => state == HabitState.enabled;
  bool get isArchived => state == HabitState.archieved;

  @override
  String toString() {
    return 'DbHabit($id,$name,$color,$state,$frequency,$reminder)';
  }

  Habit toHabit() {
    return Habit(
      name,
      color,
      id: id,
      state: state,
      frequency: frequency.toHabitFrequency(),
      reminder: reminder.map((e) => e.toHabitReminder()).toList(),
    );
  }
}

extension HabitExt on Habit {
  DbHabit toDbHabit() {
    return DbHabit(
      name,
      color,
      id: id,
      state: state,
      frequency: frequency.toDbHabitFrequency(),
      reminder: reminder.map((e) => e.toDbHabitReminder()).toList(),
    );
  }
}
