import 'dart:async';

import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/model/timeline.dart';
import 'package:bithabit/src/service/database/database_service.dart';

class WebPrefService extends DatabaseService {
  Future<void> setup() async {}

  @override
  Future<int> saveHabit(Habit habit) async {
    return 0;
  }

  @override
  Future<bool> deleteHabit(int id) async {
    return false;
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    return [];
  }

  @override
  Future<int> saveTimeline(Timeline timeline) async {
    return 0;
  }

  @override
  Future<bool> deleteTimeline(int id) async {
    return false;
  }

  @override
  Future<List<Timeline>> getAllTimelines() async {
    return [];
  }

  @override
  Future<Map<String, dynamic>> dump() async {
    return {};
    // final isar = await isarCompleter.future;
    // return {
    //   'habits': await isar.habits.where().exportJson(),
    //   'timeline': await isar.timelines.where().exportJson(),
    // };
  }

  @override
  Future<bool> import(Map<String, dynamic> json) async {
    return false;
    // final isar = await isarCompleter.future;

    // final rawJsonHabit = json['habits'] as List;
    // final rawJsonTimeline = json['timeline'] as List;
    // final jsonHabit = rawJsonHabit.cast<Map<String, dynamic>>();
    // final jsonTimeline = rawJsonTimeline.cast<Map<String, dynamic>>();
    // if (jsonHabit.isEmpty) return false;

    // await isar.writeTxn(() async {
    //   await isar.habits.importJson(jsonHabit);
    //   await isar.timelines.importJson(jsonTimeline);
    // });

    // return true;
  }
}

DatabaseService startService() => WebPrefService()..setup();
