import 'package:flutter/material.dart';

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

  factory HabitReminder.fromJson(Map<String, dynamic> json) {
    return HabitReminder(
      TimeOfDay(hour: json['hour'], minute: json['minute']),
      enabled: json['enabled'],
    );
  }
}
