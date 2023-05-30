import 'package:bithabit/src/service/analytic_service.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../model/timeline.dart';
import 'database/database_service.dart';

class TimelineService extends ChangeNotifier {
  final DatabaseService _dbService;

  /// [_habitTimelineMap] is Map<HabitId, Map<DateTime, Timeline>>
  late final Map<int, Map<DateTime, Timeline>> _habitTimelineMap;
  late final TimelineCounter counter;

  TimelineService(this._dbService) {
    _habitTimelineMap = {};
    counter = TimelineCounter(_habitTimelineMap);

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

  Map<DateTime, Timeline>? _getHabitTimeline(int habitId) {
    return _habitTimelineMap[habitId];
  }

  bool isHabitChecked(Habit habit, DateTime time) {
    final removedHourTime = time.emptyHour();

    final timeline = _getHabitTimeline(habit.id);
    if (timeline == null) return false;

    return timeline[removedHourTime] != null;
  }

  Future<void> check(
    Habit habit,
    DateTime time, {
    bool setAction = true,
  }) async {
    final removedHourTime = time.emptyHour();

    final timelines = _getHabitTimeline(habit.id) ?? {};
    final savedTimeline = timelines[removedHourTime];
    if (savedTimeline != null) {
      final success = await _dbService.deleteTimeline(savedTimeline);
      if (!success) return;

      timelines.remove(removedHourTime);

      Analytic.get().logCheckTimeline(savedTimeline, isCheck: false);
      if (setAction) lastAction = CheckAction(removedHourTime, isCheck: false);
    } else {
      final timeline = Timeline(removedHourTime, habit.id);
      final id = await _dbService.saveTimeline(timeline);

      final newTimeline = timeline.copy(id: id);
      timelines[removedHourTime] = newTimeline;

      Analytic.get().logCheckTimeline(newTimeline, isCheck: true);
      if (setAction) lastAction = CheckAction(removedHourTime, isCheck: true);
    }
    _habitTimelineMap[habit.id] = timelines;

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

class TimelineCounter {
  final Map<int, Map<DateTime, Timeline>> _habitTimelineMap;

  TimelineCounter(this._habitTimelineMap);

  Map<DateTime, Timeline>? _getHabitTimeline(int habitId) {
    return _habitTimelineMap[habitId];
  }

  int bestStreak(Habit habit) {
    final timeline = _getHabitTimeline(habit.id);
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

  int completionIn(
    Habit habit, {
    int? year,
    int? month,
    int? dayOfWeek,
  }) {
    final timeline = _getHabitTimeline(habit.id);
    if (timeline == null || timeline.isEmpty) return 0;

    Iterable<DateTime> times = timeline.keys;
    if (year != null) times = times.where((time) => time.year == year);
    if (month != null) times = times.where((time) => time.month == month);
    if (dayOfWeek != null) {
      times = times.where((time) => time.weekday == dayOfWeek);
    }

    return times.length;
  }
}
