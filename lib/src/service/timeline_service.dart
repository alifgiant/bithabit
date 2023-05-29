import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/text/num_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../model/timeline.dart';
import 'database/database_service.dart';

class TimelineService extends ChangeNotifier {
  final DatabaseService _dbService;

  /// [_habitTimelineMap] is Map<HabitId, Map<DateTime, Timeline>>
  final Map<int, Map<DateTime, Timeline>> _habitTimelineMap = {};

  TimelineService(this._dbService) {
    loadTimeline();
  }

  Map<int, Map<DateTime, Timeline>> get timelineMap => _habitTimelineMap;
  TimelineAction? lastAction;

  Future<void> loadTimeline() async {
    resetLastAction();

    final timelines = await _dbService.getAllTimelines();
    for (final timeline in timelines) {
      if (!_habitTimelineMap.containsKey(timeline.habitId)) {
        _habitTimelineMap[timeline.habitId] = {};
      }
      _habitTimelineMap[timeline.habitId]?[timeline.time] = timeline;
    }

    notifyListeners();
  }

  Map<DateTime, Timeline>? getHabitTimeline(int habitId) {
    return _habitTimelineMap[habitId];
  }

  int countBestStreak(Habit habit) {
    final timeline = getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    int best = 1;
    int count = 1;
    final sortedTime = timeline.keys.toList()..sort();

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

    return timeline.keys.where((time) => time.weekday == dayOfWeek).length;
  }

  double habitCompletion(
    Habit habit,
    int year, {
    int? month,
  }) {
    final timeline = getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    Iterable<DateTime> times = timeline.keys.where((time) => time.year == year);
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

    return timeline[removedHourTime] != null;
  }

  Future<void> check(
    Habit habit,
    DateTime time, {
    bool setAction = true,
  }) async {
    final removedHourTime = time.emptyHour();

    final timelines = _habitTimelineMap[habit.id] ?? {};
    final savedTimeline = timelines[removedHourTime];
    if (savedTimeline != null) {
      final success = await _dbService.deleteTimeline(savedTimeline);
      if (!success) return;

      timelines.remove(removedHourTime);
      if (setAction) lastAction = CheckAction(removedHourTime, isCheck: false);
    } else {
      final timeline = Timeline(removedHourTime, habit.id);
      final id = await _dbService.saveTimeline(timeline);

      timelines[removedHourTime] = timeline.copy(id: id);
      if (setAction) lastAction = CheckAction(removedHourTime, isCheck: true);
    }
    _habitTimelineMap[habit.id] = timelines;

    // save to DB
    notifyListeners();
  }

  void resetLastAction() => lastAction = null;
}

class TimelineAction {
  final bool isCheck;

  TimelineAction({required this.isCheck});
}

class CheckAction extends TimelineAction {
  final DateTime time;

  CheckAction(this.time, {required super.isCheck});
}
