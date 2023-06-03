import 'dart:async';

import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../model/habit_state.dart';
import 'database/database_service.dart';
import 'notification/notification_manager.dart';

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
    final oldHabit = _habitMap[habit.id];
    final id = await _dbService.saveHabit(habit);
    final newHabit = habit.copy(id: id);

    // save on memory
    _habitMap[id] = newHabit;
    notifyListeners();

    // setup schedule
    await _notificationManager.scheduleNotification(oldHabit, newHabit);
  }

  Future<void> deleteHabit(int id, {bool permanent = false}) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    if (permanent) {
      final success = await _dbService.deleteHabit(habit);
      if (success) _habitMap.remove(id);
      notifyListeners();
    } else {
      final updatedHabit = habit.copy(state: HabitState.archieved);
      // save habit, it'll also run schedule setup,
      // but it'll be removed soon
      await saveHabit(updatedHabit);
    }

    // remove schedule
    return _notificationManager.cancelNotification(habit);
  }

  Future<void> restoreHabit(int id) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    final updatedHabit = habit.copy(state: HabitState.enabled);
    return saveHabit(updatedHabit);
  }
}
