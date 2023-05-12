import 'package:flutter/material.dart';

class RecapService extends ChangeNotifier {
  RecapOption currentView = RecapOption.byWeek;

  void updateOption(RecapOption option) {
    currentView = option;
    notifyListeners();
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
