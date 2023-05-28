import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'timeline.g.dart';

@collection
class Timeline {
  Id id; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  final DateTime time;

  @Index(type: IndexType.value)
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
}
