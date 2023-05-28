import '../../model/habit.dart';
import '../../model/timeline.dart';

abstract class DatabaseService {
  const DatabaseService();

  /// create or update [habit]
  /// return habit id [int]
  Future<int> saveHabit(Habit habit);
  Future<bool> deleteHabit(int id);
  Future<List<Habit>> getAllHabits();

  /// create or update [timeline]
  /// return timeline id [int]
  Future<int> saveTimeline(Timeline timeline);
  Future<bool> deleteTimeline(int id);
  Future<List<Timeline>> getAllTimelines();

  Future<Map<String, dynamic>> dump();
  Future<bool> import(Map<String, dynamic> json);
}
