import 'package:isar/isar.dart';

class Timeline {
  final int id; // you can also use id = null to auto increment
  final DateTime time;
  final int habitId;

  Timeline(
    this.time,
    this.habitId, {
    this.id = Isar.autoIncrement,
  });

  Timeline copy({
    DateTime? time,
    int? habitId,
    int? id,
  }) {
    return Timeline(
      time ?? this.time,
      habitId ?? this.habitId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'habitId': habitId,
      'id': id,
    };
  }

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      DateTime.fromMillisecondsSinceEpoch(json['time'] as int? ?? 0),
      json['habitId'] as int? ?? 0,
      id: json['id'] as int? ?? Isar.autoIncrement,
    );
  }
}
