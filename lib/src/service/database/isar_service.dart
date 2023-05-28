import 'dart:async';

import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/model/timeline.dart';
import 'package:bithabit/src/service/database/database_service.dart';
import 'package:isar/isar.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class IsarService extends DatabaseService {
  final isarCompleter = Completer<Isar>();

  Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [HabitSchema, TimelineSchema],
      directory: dir.path,
    );
    isarCompleter.complete(isar);
  }

  @override
  Future<int> saveHabit(Habit habit) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.habits.put(habit));
  }

  @override
  Future<bool> deleteHabit(int id) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.habits.delete(id));
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    final isar = await isarCompleter.future;
    return isar.habits.where().findAll();
  }

  @override
  Future<int> saveTimeline(Timeline timeline) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.timelines.put(timeline));
  }

  @override
  Future<bool> deleteTimeline(int id) async {
    final isar = await isarCompleter.future;
    return isar.writeTxn(() => isar.timelines.delete(id));
  }

  @override
  Future<List<Timeline>> getAllTimelines() async {
    final isar = await isarCompleter.future;
    return isar.timelines.where().findAll();
  }

  @override
  Future<Map<String, dynamic>> dump() async {
    final isar = await isarCompleter.future;
    return {
      'habits': await isar.habits.where().exportJson(),
      'timeline': await isar.timelines.where().exportJson(),
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

    await isar.writeTxn(() async {
      await isar.habits.importJson(jsonHabit);
      await isar.timelines.importJson(jsonTimeline);
    });

    return true;
  }
}
