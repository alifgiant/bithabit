import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';

class TimelineService extends ChangeNotifier {
  final Map<String, Set<DateTime>> _habitTimelineMap = {};
  TimelineAction? lastAction;

  Future<void> loadTimeline() async {
    // read from DB or whatever
  }

  int countHabit(
    Habit habit, {
    int? month,
    int? year,
  }) {
    final timeline = _habitTimelineMap[habit.id];
    if (timeline == null) return 0;

    Iterable<DateTime> times = timeline.toList();
    if (month != null) times = times.where((time) => time.month == month);
    if (year != null) times = times.where((time) => time.year == year);

    return times.length;
  }

  bool isHabitChecked(Habit habit, DateTime time) {
    final removedHourTime = time.emptyHour();
    final timeline = _habitTimelineMap[habit.id];
    if (timeline == null) return false;

    return timeline.contains(removedHourTime);
  }

  void resetLastAction() {
    lastAction = null;
  }

  Future<void> check(Habit habit, DateTime time) async {
    final removedHourTime = time.emptyHour();

    Set<DateTime> timeline;
    if (!_habitTimelineMap.containsKey(habit.id)) {
      // create set if still not loaded
      timeline = {};
    } else {
      timeline = _habitTimelineMap[habit.id]!;
    }

    if (timeline.contains(removedHourTime)) {
      lastAction = CheckAction(removedHourTime, false);
      timeline.remove(removedHourTime);
    } else {
      lastAction = CheckAction(removedHourTime, true);
      timeline.add(removedHourTime);
    }

    _habitTimelineMap[habit.id] = timeline;
    // save to DB
    notifyListeners();
  }
}

class TimelineAction {
  final bool isCheck;

  TimelineAction(this.isCheck);
}

class CheckAction extends TimelineAction {
  final DateTime time;

  CheckAction(this.time, super.isCheck);
}
