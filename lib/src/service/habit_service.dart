import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../model/habit.dart';
import '../model/habit_state.dart';

class HabitService extends ChangeNotifier {
  final Isar isar;
  final Map<int, Habit> _habitMap = {};

  HabitService(this.isar) {
    loadHabit();
  }

  Future<void> loadHabit() async {
    final habits = await isar.habits.where().findAll();
    for (final habit in habits) {
      _habitMap[habit.id] = habit;
    }

    notifyListeners();
  }

  Iterable<Habit> getHabits({
    DateTime? day,
    HabitState state = HabitState.enabled,
  }) {
    // TODO: return stream directly from DB
    final habits = _habitMap.values.where((habit) => habit.state == state);
    if (day == null) {
      return habits;
    } else {
      return habits.where(
        (habit) => habit.frequency.isEnabledFor(day),
      );
    }
  }

  Future<void> saveHabit(Habit habit) async {
    // save to DB
    await isar.writeTxn(() async {
      final id = await isar.habits.put(habit);
      _habitMap[id] = habit;
    });

    // TODO: run reminder service to remove reminder
    notifyListeners();
  }

  Future<void> deleteHabit(int id, {bool permanent = false}) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    // TODO: run reminder service to remove reminder

    if (permanent) {
      _habitMap.remove(id);

      // TODO: delete from db
    } else {
      _habitMap[id] = habit.copy(state: HabitState.archieved);

      // TODO: save to db
    }
    notifyListeners();
  }

  Future<void> restoreHabit(int id) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    _habitMap[id] = habit.copy(state: HabitState.enabled);

    // TODO: run reminder service to restore reminder

    // TODO: save to db

    notifyListeners();
  }
}
