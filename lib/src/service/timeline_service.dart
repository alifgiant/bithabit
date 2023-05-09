import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../model/habit.dart';

class TimelineService extends ChangeNotifier {
  final Map<String, Set<DateTime>> _habitTimelineMap = {};
  DateTime? lastTimelineUpdated;
  final player = AudioPlayer()..setAsset('assets/win-sound.wav');

  Future<void> loadTimeline() async {
    // read from DB or whatever
  }

  bool isHabitChecked(Habit habit, DateTime time) {
    final removedHourTime = time.emptyHour();
    final timeline = _habitTimelineMap[habit.id];
    if (timeline == null) return false;

    return timeline.contains(removedHourTime);
  }

  Future<void> check(Habit habit, DateTime time) async {
    final removedHourTime = time.emptyHour();
    lastTimelineUpdated = removedHourTime;
    Set<DateTime> timeline;
    if (!_habitTimelineMap.containsKey(habit.id)) {
      // create set if still not loaded
      timeline = {};
    } else {
      timeline = _habitTimelineMap[habit.id]!;
    }

    if (timeline.contains(removedHourTime)) {
      timeline.remove(removedHourTime);
    } else {
      timeline.add(removedHourTime);

      player.seek(Duration.zero).then((_) {
        player.play();
      });
    }

    _habitTimelineMap[habit.id] = timeline;
    // save to DB
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
