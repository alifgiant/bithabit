import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

class Habit {
  final String id;
  final String name;
  final HabitColor color;
  final DateTime? reminder;

  Habit(this.id, this.name, this.color, {this.reminder});
}

enum HabitColor {
  purple(ResColor.purple, ResColor.black),
  yellow(ResColor.yellow, ResColor.black),
  pink(ResColor.pink, ResColor.black),
  darkGreen(ResColor.darkGreen, ResColor.black),
  lightGreen(ResColor.lightGreen, ResColor.black),
  darkBlue(ResColor.darkBlue, ResColor.black),
  lightBlue(ResColor.lightBlue, ResColor.black);

  const HabitColor(this.mainColor, this.textColor);
  final Color mainColor;
  final Color textColor;
}
