import 'package:flutter/material.dart';

import '../model/habit.dart';
import '../pages/recap/monthly_recap.dart';
import '../pages/recap/streak_recap.dart';
import '../pages/recap/weekly_recap.dart';
import 'analytic_service.dart';

class RecapService extends ChangeNotifier {
  RecapOption currentView = RecapOption.byWeek;

  void updateOption(RecapOption option, String source) {
    Analytic.get().logRecapOptionUpdate(option, source);
    currentView = option;
    notifyListeners();
  }

  Widget createView(Habit habit) {
    switch (currentView) {
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
}
