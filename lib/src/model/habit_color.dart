import 'package:flutter/material.dart';

import '../utils/res/res_color.dart';

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
