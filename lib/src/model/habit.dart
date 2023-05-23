import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

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

  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      json['id'] ?? '',
      json['name'] ?? '',
      HabitColor.parse(json['color'] ?? ''),
      state: HabitState.parse(json['state'] ?? ''),
      frequency: HabitFrequency.fromJson(json['frequency'] ?? {}),
      reminder: (json['reminder'] as List?)
              ?.map(
                (e) => HabitReminder.fromJson(e),
              )
              .toList() ??
          [],
    );
  }
}

enum HabitState {
  enabled('enabled'),
  archieved('archieved');

  const HabitState(this.key);
  final String key;

  static HabitState parse(String key) {
    return HabitState.values.firstWhere(
      (e) => e.key == key,
      orElse: () => HabitState.enabled,
    );
  }
}

enum HabitColor {
  red(ResColor.red, ResColor.white, 'red'),
  pink(ResColor.pink, ResColor.white, 'pink'),
  purple(ResColor.purple, ResColor.white, 'purple'),
  darkGreen(ResColor.darkGreen, ResColor.white, 'darkGreen'),
  lightGreen(ResColor.lightGreen, ResColor.white, 'lightGreen'),
  darkBlue(ResColor.darkBlue, ResColor.white, 'darkBlue'),
  lightBlue(ResColor.lightBlue, ResColor.white, 'lightBlue'),
  brown(ResColor.brown, ResColor.white, 'brown');

  const HabitColor(this.mainColor, this.textColor, this.key);
  final Color mainColor;
  final Color textColor;
  final String key;

  static HabitColor parse(String key) {
    return HabitColor.values.firstWhere(
      (e) => e.key == key,
      orElse: () => HabitColor.red,
    );
  }
}

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

class HabitReminder {
  final TimeOfDay time;
  final bool enabled;

  const HabitReminder(this.time, {required this.enabled});

  HabitReminder copyWith({
    TimeOfDay? time,
    bool? enabled,
  }) {
    return HabitReminder(time ?? this.time, enabled: enabled ?? this.enabled);
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'enabled': enabled,
    };
  }

  static HabitReminder fromJson(Map<String, dynamic> json) {
    return HabitReminder(
      TimeOfDay(hour: json['hour'], minute: json['minute']),
      enabled: json['enabled'],
    );
  }
}
