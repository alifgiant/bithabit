import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../model/timeline.dart';
import 'analytic_service.dart';
import 'database/database_service.dart';
import 'navigation_service.dart';
import 'subs_service.dart';

class TimelineService extends ChangeNotifier {
  final DatabaseService _dbService;
  final SubsService _subsService;

  static const int maxWeekNonPremium = 12;
  static const int _maxDayNonPremium = maxWeekNonPremium * 7 /** day */;

  /// [_habitTimelineMap] is Map<HabitId, Map<DateTime, Timeline>>
  late final Map<int, Map<DateTime, Timeline>> _habitTimelineMap;
  late final TimelineCounter counter;

  TimelineService(this._dbService, this._subsService) {
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

  Future<void> maybeCheck(
    BuildContext context,
    Habit habit,
    DateTime time,
  ) async {
    final removedHourTime = time.emptyHour();
    final timelines = _getHabitTimeline(habit.id) ?? {};
    final timeline = timelines[removedHourTime];
    final hasSavedTimeline = timeline != null;

    if (hasSavedTimeline) return _uncheck(habit, timeline);

    if (!_subsService.isPremiumUser && timelines.length > _maxDayNonPremium) {
      return NavigationService.of(context).showPremiumDialog(
        'Track Day is Maxed Out',
        desc: 'You can only track an habit for $maxWeekNonPremium weeks. '
            'BitHabit Pro subcription is required for more days',
      );
    }

    return _check(habit, Timeline(removedHourTime, habit.id));
  }

  Future<void> _check(Habit habit, Timeline timeline) async {
    final timelines = _getHabitTimeline(habit.id) ?? {};
    final id = await _dbService.saveTimeline(timeline);
    final timelineWithId = timeline.copy(id: id);

    // update map
    timelines[timeline.time] = timelineWithId;
    _habitTimelineMap[habit.id] = timelines;

    lastAction = CheckAction(timeline.time, isCheck: true);
    Analytic.get().logCheckTimeline(timelineWithId, isCheck: true);

    notifyListeners();
  }

  Future<void> _uncheck(Habit habit, Timeline timeline) async {
    final timelines = _getHabitTimeline(habit.id) ?? {};
    final success = await _dbService.deleteTimeline(timeline);
    if (!success) return;

    // update map
    timelines.remove(timeline.time);
    _habitTimelineMap[habit.id] = timelines;

    lastAction = CheckAction(timeline.time, isCheck: false);
    Analytic.get().logCheckTimeline(timeline, isCheck: false);

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
