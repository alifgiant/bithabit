import 'dart:async';

import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/model/timeline.dart';
import 'package:bithabit/src/service/database/database_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'db_habit.dart';
import 'db_timeline.dart';

class IsarService extends DatabaseService {
  final isarCompleter = Completer<Isar>();

  Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [DbHabitSchema, DbTimelineSchema],
      directory: dir.path,
    );
    isarCompleter.complete(isar);
  }

  @override
  Future<int> saveHabit(Habit habit) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.dbHabits.put(habit.toDbHabit()));
  }

  @override
  Future<bool> deleteHabit(Habit habit) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.dbHabits.delete(habit.id));
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    final isar = await isarCompleter.future;
    final dbHabits = await isar.dbHabits.where().findAll();
    return dbHabits.map((e) => e.toHabit()).toList();
  }

  @override
  Future<int> saveTimeline(Timeline timeline) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.dbTimelines.put(timeline.toDbTimeline()));
  }

  @override
  Future<bool> deleteTimeline(Timeline timeline) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.dbTimelines.delete(timeline.id));
  }

  @override
  Future<List<Timeline>> getAllTimelines() async {
    final isar = await isarCompleter.future;
    final dbTimelines = await isar.dbTimelines.where().findAll();
    return dbTimelines.map((e) => e.toTimeline()).toList();
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
    final isar = await isarCompleter.future;

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

    await isar.writeTxn(() async {
      await isar.dbHabits.putAll(mergedHabit.toList());
      await isar.dbTimelines.putAll(mergedTimeline.toList());
    });

    return true;
  }

  Iterable<DbHabit> combineHabits(List<Habit> old, Iterable<Habit> newHabit) {
    final newHabitKeys = newHabit.map((e) => e.id).toSet();
    final merged = old
      ..removeWhere((e) => newHabitKeys.contains(e.id))
      ..addAll(newHabit);
    return merged.map((e) => e.toDbHabit());
  }

  Iterable<DbTimeline> combineTimeline(List<Timeline> old, Iterable<Timeline> newTimeline) {
    final newTimelineKeys = newTimeline.map((e) => e.id).toSet();
    final merged = old
      ..removeWhere((e) => newTimelineKeys.contains(e.id))
      ..addAll(newTimeline);
    return merged.map((e) => e.toDbTimeline());
  }
}

DatabaseService startService() => IsarService()..setup();
