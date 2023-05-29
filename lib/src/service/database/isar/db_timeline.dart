import 'package:isar/isar.dart';

import '../../../model/timeline.dart';

part 'db_timeline.g.dart';

@collection
class DbTimeline {
  final Id id; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  final DateTime time;

  @Index(type: IndexType.value)
  final int habitId;

  DbTimeline(
    this.time,
    this.habitId, {
    this.id = Isar.autoIncrement,
  });

  DbTimeline copy({
    DateTime? time,
    int? habitId,
    int? id,
  }) {
    return DbTimeline(
      time ?? this.time,
      habitId ?? this.habitId,
      id: id ?? this.id,
    );
  }

  Timeline toTimeline() {
    return Timeline(time, habitId, id: id);
  }
}

extension TimelineExt on Timeline {
  DbTimeline toDbTimeline() {
    return DbTimeline(time, habitId, id: id);
  }
}
