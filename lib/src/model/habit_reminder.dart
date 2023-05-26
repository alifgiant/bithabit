import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

@embedded
class HabitReminder {
  final TimeOfDay time;
  final bool enabled;

  const HabitReminder({
    this.time = const TimeOfDay(hour: 0, minute: 0),
    this.enabled = true,
  });

  HabitReminder copyWith({
    TimeOfDay? time,
    bool? enabled,
  }) {
    return HabitReminder(
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'enabled': enabled,
    };
  }

  factory HabitReminder.fromJson(Map<String, dynamic> json) {
    return HabitReminder(
      time: TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int),
      enabled: json['enabled'] as bool,
    );
  }
}
