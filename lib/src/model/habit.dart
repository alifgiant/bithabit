import 'habit_color.dart';
import 'habit_frequency.dart';
import 'habit_reminder.dart';
import 'habit_state.dart';

class Habit {
  final String id;
  final String name;
  final HabitColor color;
  final HabitState state;
  final HabitFrequency frequency;
  final List<HabitReminder> reminder;

  const Habit(
    this.id,
    this.name,
    this.color, {
    this.state = HabitState.enabled,
    this.frequency = const DailyFrequency(),
    this.reminder = const [],
  });

  Habit copy({
    String? id,
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
      json['id'] ?? '',
      json['name'] ?? '',
      HabitColor.parse(json['color'] ?? ''),
      state: HabitState.parse(json['state'] ?? ''),
      frequency: HabitFrequency.fromJson(json['frequency'] ?? {}),
      reminder: (json['reminder'] as List?)
              ?.map<HabitReminder>(
                (e) => HabitReminder.fromJson(e),
              )
              .toList() ??
          [],
    );
  }
}
