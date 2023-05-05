import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

class Habit {
  final String id;
  final String name;
  final HabitColor color;
  final DateTime? reminder;

  Habit(
    this.id,
    this.name,
    this.color, {
    this.reminder,
  });

  Habit copy({
    String? id,
    String? name,
    HabitColor? color,
    DateTime? reminder,
  }) {
    return Habit(
      id ?? this.id,
      name ?? this.name,
      color ?? this.color,
      reminder: reminder ?? this.reminder,
    );
  }

  @override
  String toString() {
    return 'Habit($id,$name,$color,$reminder)';
  }
}

enum HabitColor {
  purple(ResColor.purple, ResColor.white),
  yellow(ResColor.yellow, ResColor.white),
  pink(ResColor.pink, ResColor.white),
  darkGreen(ResColor.darkGreen, ResColor.white),
  lightGreen(ResColor.lightGreen, ResColor.white),
  darkBlue(ResColor.darkBlue, ResColor.white),
  lightBlue(ResColor.lightBlue, ResColor.white);

  const HabitColor(this.mainColor, this.textColor);
  final Color mainColor;
  final Color textColor;
}
