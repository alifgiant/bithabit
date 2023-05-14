import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

class Habit {
  final String id;
  final String name;
  final HabitColor color;
  final String desc;
  final HabitFrequency frequency;
  final List<HabitReminder> reminder;

  const Habit(
    this.id,
    this.name,
    this.color, {
    this.desc = '',
    this.frequency = const DailyFrequency(),
    this.reminder = const [],
  });

  Habit copy({
    String? id,
    String? name,
    HabitColor? color,
    String? desc,
    HabitFrequency? frequency,
    List<HabitReminder>? reminder,
  }) {
    return Habit(
      id ?? this.id,
      name ?? this.name,
      color ?? this.color,
      desc: desc ?? this.desc,
      frequency: frequency ?? this.frequency,
      reminder: reminder ?? this.reminder.toList(),
    );
  }

  @override
  String toString() {
    return 'Habit($id,$name,$color,$desc,$frequency,$reminder)';
  }
}

enum HabitColor {
  red(ResColor.red, ResColor.white),
  pink(ResColor.pink, ResColor.white),
  purple(ResColor.purple, ResColor.white),
  darkGreen(ResColor.darkGreen, ResColor.white),
  lightGreen(ResColor.lightGreen, ResColor.white),
  darkBlue(ResColor.darkBlue, ResColor.white),
  lightBlue(ResColor.lightBlue, ResColor.white),
  brown(ResColor.brown, ResColor.white);

  const HabitColor(this.mainColor, this.textColor);
  final Color mainColor;
  final Color textColor;
}

abstract class HabitFrequency {
  final Set<int> selected;
  const HabitFrequency({required this.selected});

  HabitFrequency copyWith({Set<int>? selected});
  bool isEnabledFor(DateTime time);
}

class DailyFrequency extends HabitFrequency {
  static const name = 'daily';

  const DailyFrequency({
    super.selected = const {1, 2, 3, 4, 5, 6, 7},
  });

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
  });

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
}
