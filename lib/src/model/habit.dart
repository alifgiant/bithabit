import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'habit_color.dart';
import 'habit_frequency.dart';
import 'habit_reminder.dart';
import 'habit_state.dart';

class Habit extends Equatable {
  final int id;
  final String name;
  final HabitColor color;
  final HabitState state;
  final HabitFrequency frequency;
  final List<HabitReminder> reminder;

  const Habit(
    this.name,
    this.color, {
    this.id = Isar.autoIncrement,
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
  bool get stringify => true;

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
      json['name'] as String? ?? '',
      HabitColor.parse(json['color'] as String? ?? ''),
      id: json['id'] as int? ?? Isar.autoIncrement,
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

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        state,
        frequency,
        ...reminder,
      ];
}
