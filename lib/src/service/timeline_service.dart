import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/text/num_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';

class TimelineService extends ChangeNotifier {
  final Map<String, Set<DateTime>> _habitTimelineMap = {};
  Map<String, Set<DateTime>> get timelineMap => _habitTimelineMap;

  TimelineAction? lastAction;

  Future<void> loadTimeline() async {
    // read from DB or whatever
  }

  Set<DateTime>? getHabitTimeline(String habitId) {
    return _habitTimelineMap[habitId];
  }

  int countBestStreak(Habit habit) {
    final timeline = getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    int best = 1;
    int count = 1;
    final sortedTime = timeline.toList()..sort();

    for (int i = 1; i < sortedTime.length; i++) {
      final prevTime = sortedTime[i - 1];
      final time = sortedTime[i];
      if (time.difference(prevTime).inDays == 1) {
        count += 1;
        if (best < count) best = count;
      } else {
        count = 1;
      }
    }
    return best;
  }

  int countHabit(
    Habit habit,
    int dayOfWeek,
  ) {
    final timeline = getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    return timeline.where((time) => time.weekday == dayOfWeek).length;
  }

  double habitCompletion(
    Habit habit,
    int year, {
    int? month,
  }) {
    final timeline = getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    Iterable<DateTime> times = timeline.where((time) => time.year == year);
    if (month != null) times = times.where((time) => time.month == month);

    final count = times.length;

    int totalDays;
    if (month != null) {
      totalDays = month.getMonthTotalDays(year: year);
    } else {
      totalDays = year.getYearTotalDays();
    }

    return count / totalDays;
  }

  bool isHabitChecked(Habit habit, DateTime time) {
    final removedHourTime = time.emptyHour();

    final timeline = getHabitTimeline(habit.id);
    if (timeline == null) return false;

    return timeline.contains(removedHourTime);
  }

  Future<void> check(Habit habit, DateTime time, {bool setAction = true}) async {
    final removedHourTime = time.emptyHour();

    Set<DateTime> timeline;
    if (!_habitTimelineMap.containsKey(habit.id)) {
      // create set if still not loaded
      timeline = {};
    } else {
      timeline = _habitTimelineMap[habit.id]!;
    }

    if (timeline.contains(removedHourTime)) {
      if (setAction) lastAction = CheckAction(removedHourTime, false);
      timeline.remove(removedHourTime);
    } else {
      if (setAction) lastAction = CheckAction(removedHourTime, true);
      timeline.add(removedHourTime);
    }

    _habitTimelineMap[habit.id] = timeline;
    // save to DB
    notifyListeners();
  }

  void resetLastAction() {
    lastAction = null;
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
