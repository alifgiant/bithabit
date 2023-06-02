import 'dart:async';

import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../model/habit_state.dart';
import 'database/database_service.dart';
import 'notification_manager.dart';

class HabitService extends ChangeNotifier {
  final DatabaseService _dbService;
  final NotificationManager _notificationManager;
  final Map<int, Habit> _habitMap = {};

  HabitService(
    this._dbService,
    this._notificationManager,
  ) {
    loadHabit();
  }

  Future<void> loadHabit() async {
    final habits = await _dbService.getAllHabits();
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
    final id = await _dbService.saveHabit(habit);
    _habitMap[id] = habit.copy(id: id);

    // TODO: run reminder service to remove reminder
    notifyListeners();
  }

  Future<void> deleteHabit(int id, {bool permanent = false}) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    if (permanent) {
      final success = await _dbService.deleteHabit(habit);
      if (success) _habitMap.remove(id);

      // TODO: run reminder service to remove reminder
      notifyListeners();
    } else {
      final updatedHabit = habit.copy(state: HabitState.archieved);
      return saveHabit(updatedHabit);
    }
  }

  Future<void> restoreHabit(int id) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    final updatedHabit = habit.copy(state: HabitState.enabled);
    return saveHabit(updatedHabit);
  }
}
