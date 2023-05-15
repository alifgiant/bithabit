import 'package:flutter/material.dart';

import '../model/habit.dart';

class HabitService extends ChangeNotifier {
  final Map<String, Habit> _habitMap = {};

  // Iterable<Habit> get habits => _habitMap.values;

  Future<void> loadHabit() async {
    // read from DB or whatever
  }

  Iterable<Habit> getHabits({DateTime? day}) {
    if (day == null) return _habitMap.values;

    return _habitMap.values.where(
      (habit) => habit.frequency.isEnabledFor(day),
    );
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
    _habitMap.remove(id);
    notifyListeners();
  }

  Future<void> _createHabit(Habit habit) async {
    // TODO: create new id
    final newId = DateTime.now().toIso8601String();
    _habitMap[newId] = habit.copy(id: newId);
  }

  Future<void> _updateHabit(Habit habit) async {
    // update async
    _habitMap[habit.id] = habit;
  }
}
