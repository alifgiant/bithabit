import 'dart:async';
import 'dart:convert';

import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/model/timeline.dart';
import 'package:bithabit/src/service/database/database_service.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebPrefService extends DatabaseService {
  static const _dbHabitsKey = 'dbHabits';
  static const _dbTimelineKey = 'dbTimeline';

  Future<bool> _replaceSavedHabits(List<Habit> newHabits) async {
    final rawHabits = jsonEncode(newHabits.map((e) => e.toMap()).toList());
    final pref = await SharedPreferences.getInstance();
    return pref.setString(_dbHabitsKey, rawHabits);
  }

  Future<bool> _replaceSavedTimelines(List<Timeline> newTimelines) async {
    final rawHabits = jsonEncode(newTimelines.map((e) => e.toMap()).toList());
    final pref = await SharedPreferences.getInstance();
    return pref.setString(_dbTimelineKey, rawHabits);
  }

  @override
  Future<int> saveHabit(Habit habit) async {
    final savedHabits = await getAllHabits();

    Habit inspectedHabit = habit;
    if (inspectedHabit.id == Isar.autoIncrement) {
      // create new Habit ID
      final newId = DateTime.now().millisecondsSinceEpoch;
      inspectedHabit = inspectedHabit.copy(id: newId);
    } else {
      // remove saved habit with same ID
      savedHabits.removeWhere((e) => e.id == inspectedHabit.id);
    }

    // add habit to list
    savedHabits.add(inspectedHabit);

    await _replaceSavedHabits(savedHabits);
    return inspectedHabit.id;
  }

  @override
  Future<bool> deleteHabit(int id) async {
    final savedHabits = await getAllHabits();
    savedHabits.removeWhere((e) => e.id == id);
    return _replaceSavedHabits(savedHabits);
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    final pref = await SharedPreferences.getInstance();
    final rawHabits = pref.getString(_dbHabitsKey);
    if (rawHabits == null) return [];

    try {
      final jsonHabits = jsonDecode(rawHabits);
      return (jsonHabits as List)
          .map<Habit>(
            (e) => Habit.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      await pref.remove(_dbHabitsKey);
      return [];
    }
  }

  @override
  Future<int> saveTimeline(Timeline timeline) async {
    final savedTimeline = await getAllTimelines();

    Timeline inspectedHabit = timeline;
    if (inspectedHabit.id == Isar.autoIncrement) {
      // create new Timeline ID
      final newId = DateTime.now().millisecondsSinceEpoch;
      inspectedHabit = inspectedHabit.copy(id: newId);
    } else {
      // remove saved Timeline with same ID
      savedTimeline.removeWhere((e) => e.id == inspectedHabit.id);
    }

    // add Timeline to list
    savedTimeline.add(inspectedHabit);

    await _replaceSavedTimelines(savedTimeline);
    return inspectedHabit.id;
  }

  @override
  Future<bool> deleteTimeline(int id) async {
    final savedTimeline = await getAllTimelines();
    savedTimeline.removeWhere((e) => e.id == id);
    return _replaceSavedTimelines(savedTimeline);
  }

  @override
  Future<List<Timeline>> getAllTimelines() async {
    final pref = await SharedPreferences.getInstance();
    final rawTimelines = pref.getString(_dbTimelineKey);
    if (rawTimelines == null) return [];

    try {
      final jsonHabits = jsonDecode(rawTimelines);
      return (jsonHabits as List)
          .map<Timeline>(
            (e) => Timeline.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      await pref.remove(_dbTimelineKey);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> dump() async {
    return {
      'habits': await getAllHabits(),
      'timeline': await getAllTimelines(),
    };
  }

  @override
  Future<bool> import(Map<String, dynamic> json) async {
    final rawJsonHabit = json['habits'] as List;
    final rawJsonTimeline = json['timeline'] as List;
    final jsonHabit = rawJsonHabit.cast<Map<String, dynamic>>();
    final jsonTimeline = rawJsonTimeline.cast<Map<String, dynamic>>();
    if (jsonHabit.isEmpty) return false;

    final habits = jsonHabit.map(Habit.fromJson);
    final savedHabits = await getAllHabits();
    final mergedHabit = combineHabits(savedHabits, habits);

    final timelines = jsonTimeline.map(Timeline.fromJson);
    final savedTimeline = await getAllTimelines();
    final mergedTimeline = combineTimeline(savedTimeline, timelines);

    await _replaceSavedHabits(mergedHabit);
    await _replaceSavedTimelines(mergedTimeline);

    return true;
  }

  List<Habit> combineHabits(List<Habit> old, Iterable<Habit> newHabit) {
    final newHabitKeys = newHabit.map((e) => e.id).toSet();
    return old
      ..removeWhere((e) => newHabitKeys.contains(e.id))
      ..addAll(newHabit);
  }

  List<Timeline> combineTimeline(List<Timeline> old, Iterable<Timeline> newTimeline) {
    final newTimelineKeys = newTimeline.map((e) => e.id).toSet();
    return old
      ..removeWhere((e) => newTimelineKeys.contains(e.id))
      ..addAll(newTimeline);
  }
}

DatabaseService startService() => WebPrefService();
