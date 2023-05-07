import 'package:flutter/material.dart';

import '../model/habit.dart';

class TimelineService extends ChangeNotifier {
  final Map<String, Set<DateTime>> _habitTimelineMap = {};

  Future<void> loadTimeline() async {
    // read from DB or whatever
  }

  bool isHabitChecked(Habit habit, DateTime time) {
    final timeline = _habitTimelineMap[habit.id];
    if (timeline == null) return false;

    return timeline.contains(time);
  }

  Future<void> check(Habit habit, DateTime time) async {
    Set<DateTime> timeline;
    if (!_habitTimelineMap.containsKey(habit.id)) {
      // create set if still not loaded
      timeline = {};
    } else {
      timeline = _habitTimelineMap[habit.id]!;
    }

    if (timeline.contains(time)) {
      timeline.remove(time);
    } else {
      timeline.add(time);
    }

    _habitTimelineMap[habit.id] = timeline;
    // save to DB
    notifyListeners();
  }
}
