import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../pages/recap/monthly_recap.dart';
import '../pages/recap/streak_recap.dart';
import '../pages/recap/weekly_recap.dart';
import 'analytic_service.dart';
import 'cache/cache.dart';

class RecapService extends ChangeNotifier {
  static const _prefKey = 'RecapService';
  final Cache cache;
  RecapService(this.cache) {
    load();
  }

  Future<void> load() async {
    final title = await cache.getString(_prefKey);
    if (title == null) return;

    selectedOption = RecapOption.parse(title);
    notifyListeners();
  }

  RecapOption selectedOption = RecapOption.byWeek;

  void updateOption(RecapOption option, String source) {
    Analytic.get().logRecapOptionUpdate(option, source);
    selectedOption = option;
    cache.setString(_prefKey, option.title);
    notifyListeners();
  }

  Widget createView(Habit habit) {
    switch (selectedOption) {
      case RecapOption.byMonth:
        return MonthlyRecap(habit: habit);
      case RecapOption.byStreak:
        return StreakRecap(habit: habit);
      case RecapOption.byWeek:
        return WeeklyRecap(habit: habit);
    }
  }
}

enum RecapOption {
  byWeek('Weekly', 'Show Week'),
  byMonth('Monthly', 'Show Month'),
  byStreak('Streak', 'Show Streak');

  const RecapOption(
    this.title,
    this.menuTitle,
  );

  final String title;
  final String menuTitle;

  static RecapOption parse(String title) {
    if (title == RecapOption.byWeek.title) return RecapOption.byWeek;
    if (title == RecapOption.byMonth.title) return RecapOption.byMonth;
    return RecapOption.byStreak;
  }
}
