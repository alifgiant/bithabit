import 'package:isar/isar.dart';

import 'habit_color.dart';
import 'habit_frequency.dart';
import 'habit_reminder.dart';
import 'habit_state.dart';

// part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  // final String id;
  @Index(type: IndexType.value)
  final String name;
  @Enumerated(EnumType.value, 'key')
  final HabitColor color;
  @Enumerated(EnumType.value, 'key')
  final HabitState state;
  final HabitFrequency frequency;
  final List<HabitReminder> reminder;

  Habit(
    this.id,
    this.name,
    this.color, {
    this.state = HabitState.enabled,
    this.frequency = const HabitFrequency(),
    this.reminder = const [],
  });

  Habit copy({
    int? id,
    String? name,
    HabitColor? color,
    HabitState? state,
    HabitFrequency? frequency,
    List<HabitReminder>? reminder,
  }) {
    return Habit(
      id ?? this.id,
      name ?? this.name,
      color ?? this.color,
      state: state ?? this.state,
      frequency: frequency ?? this.frequency,
      reminder: reminder ?? this.reminder.toList(),
    );
  }

  bool get isEnabled => state == HabitState.enabled;
  bool get isArchived => state == HabitState.archieved;

  @override
  String toString() {
    return 'Habit($id,$name,$color,$state,$frequency,$reminder)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.key,
      'state': state.key,
      'frequency': frequency.toMap(),
      'reminder': reminder.map((e) => e.toMap()).toList()
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      json['id'] as int? ?? 0,
      json['name'] as String? ?? '',
      HabitColor.parse(json['color'] as String? ?? ''),
      state: HabitState.parse(json['state'] as String? ?? ''),
      frequency: HabitFrequency.fromJson(
        json['frequency'] as Map<String, dynamic>? ?? {},
      ),
      reminder: (json['reminder'] as List?)
              ?.cast<Map<String, dynamic>>()
              .map<HabitReminder>(
                HabitReminder.fromJson,
              )
              .toList() ??
          [],
    );
  }
}
