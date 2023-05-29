import 'package:isar/isar.dart';

import '../../../model/habit_reminder.dart';

part 'db_habit_reminder.g.dart';

@embedded
class DbHabitReminder {
  final int hour;
  final int minute;
  final bool enabled;

  const DbHabitReminder({
    this.hour = 0,
    this.minute = 0,
    this.enabled = true,
  });

  DbHabitReminder copyWith({
    int? hour,
    int? minute,
    bool? enabled,
  }) {
    return DbHabitReminder(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
    );
  }

  HabitReminder toHabitReminder() {
    return HabitReminder(
      hour: hour,
      minute: minute,
      enabled: enabled,
    );
  }
}

extension HabitReminderExt on HabitReminder {
  DbHabitReminder toDbHabitReminder() {
    return DbHabitReminder(
      hour: hour,
      minute: minute,
      enabled: enabled,
    );
  }
}
