import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

class Habit {
  final String id;
  final String name;
  final HabitColor color;
  final HabitFrequency frequency;
  final Set<int> selectedDay;
  final List<DateTime> reminder;

  const Habit(
    this.id,
    this.name,
    this.color, {
    this.frequency = HabitFrequency.daily,
    this.selectedDay = const {1, 2, 3, 4, 5, 6, 7}, // 7 day of week
    this.reminder = const [],
  });

  Habit copy({
    String? id,
    String? name,
    HabitColor? color,
    HabitFrequency? frequency,
    List<DateTime>? reminder,
  }) {
    return Habit(
      id ?? this.id,
      name ?? this.name,
      color ?? this.color,
      frequency: frequency ?? this.frequency,
      reminder: reminder ?? this.reminder,
    );
  }

  @override
  String toString() {
    return 'Habit($id,$name,$color,$reminder)';
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

enum HabitFrequency {
  daily('daily'),
  monthly('monthly');

  const HabitFrequency(this.name);
  final String name;
}
