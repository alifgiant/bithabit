import 'package:isar/isar.dart';

@embedded
class HabitReminder {
  final int hour;
  final int minute;
  final bool enabled;

  const HabitReminder({
    this.hour = 0,
    this.minute = 0,
    this.enabled = true,
  });

  HabitReminder copyWith({
    int? hour,
    int? minute,
    bool? enabled,
  }) {
    return HabitReminder(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'enabled': enabled,
    };
  }

  factory HabitReminder.fromJson(Map<String, dynamic> json) {
    return HabitReminder(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      enabled: json['enabled'] as bool,
    );
  }
}
