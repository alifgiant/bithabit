import 'package:flutter/material.dart';

import '../model/habit.dart';

class HabitService extends ChangeNotifier {
  final Map<String, Habit> _habitMap = {};

  HabitService() {
    loadHabit();
  }

  Future<void> loadHabit() async {
    // read from DB or whatever
    notifyListeners();
  }

  Iterable<Habit> getHabits({
    DateTime? day,
    HabitState state = HabitState.enabled,
  }) {
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
    final isExist = _habitMap.containsKey(habit.id);
    if (isExist) {
      await _updateHabit(habit);
    } else {
      await _createHabit(habit);
    }
    notifyListeners();
  }

  Future<void> deleteHabit(String id, {bool permanent = false}) async {
    final habit = _habitMap[id];
    if (habit == null) return;

    if (permanent) {
      // TODO: delete from db
      _habitMap.remove(id);

      // TODO: save to db
    } else {
      // TODO: mark archive
      _habitMap[id] = habit.copy(state: HabitState.archieved);

      // TODO: save to db
    }
    notifyListeners();
  }

  Future<void> _createHabit(Habit habit) async {
    // TODO: create new id
    final newId = DateTime.now().toIso8601String();
    _habitMap[newId] = habit.copy(id: newId);

    // TODO: save to db
  }

  Future<void> _updateHabit(Habit habit) async {
    // update async
    _habitMap[habit.id] = habit;

    // TODO: save to db
  }
}
