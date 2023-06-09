import 'dart:async';
import 'dart:convert';

import 'package:isar/isar.dart';

import '../../../model/habit.dart';
import '../../../model/timeline.dart';
import '../../cache/cache.dart';
import '../database_service.dart';

class WebPrefService extends DatabaseService {
  final Cache cache;

  const WebPrefService(this.cache);

  static const _dbHabitsKey = 'dbHabits';
  static const _dbTimelineKey = 'dbTimeline';

  Future<bool> _replaceSavedHabits(List<Habit> newHabits) {
    final rawHabits = jsonEncode(newHabits.map((e) => e.toMap()).toList());
    return cache.setString(_dbHabitsKey, rawHabits);
  }

  Future<bool> _replaceSavedTimelines(List<Timeline> newTimelines) {
    final rawHabits = jsonEncode(newTimelines.map((e) => e.toMap()).toList());
    return cache.setString(_dbTimelineKey, rawHabits);
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
  Future<bool> deleteHabit(Habit habit) async {
    final savedHabits = await getAllHabits();
    savedHabits.removeWhere((e) => e.id == habit.id);
    return _replaceSavedHabits(savedHabits);
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    final rawHabits = await cache.getString(_dbHabitsKey);
    if (rawHabits == null) return [];

    try {
      final jsonHabits = jsonDecode(rawHabits);
      return (jsonHabits as List)
          .map<Habit>(
            (e) => Habit.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      await cache.remove(_dbHabitsKey);
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
  Future<bool> deleteTimeline(Timeline timeline) async {
    final savedTimeline = await getAllTimelines();
    savedTimeline.removeWhere((e) => e.id == timeline.id);
    return _replaceSavedTimelines(savedTimeline);
  }

  @override
  Future<List<Timeline>> getAllTimelines() async {
    final rawTimelines = await cache.getString(_dbTimelineKey);
    if (rawTimelines == null) return [];

    try {
      final jsonHabits = jsonDecode(rawTimelines);
      return (jsonHabits as List)
          .map<Timeline>(
            (e) => Timeline.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      await cache.remove(_dbTimelineKey);
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> dump() async {
    return {
      'habits': (await getAllHabits()).map((e) => e.toMap()).toList(),
      'timeline': (await getAllTimelines()).map((e) => e.toMap()).toList(),
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

  List<Timeline> combineTimeline(
      List<Timeline> old, Iterable<Timeline> newTimeline) {
    final newTimelineKeys = newTimeline.map((e) => e.id).toSet();
    return old
      ..removeWhere((e) => newTimelineKeys.contains(e.id))
      ..addAll(newTimeline);
  }
}

DatabaseService startService(Cache cache) => WebPrefService(cache);
