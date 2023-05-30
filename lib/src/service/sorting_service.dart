import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';

import '../model/habit.dart';
import 'analytic_service.dart';

class SortingService extends ChangeNotifier {
  SortingOption currentSelectedFilter = SortingOption.byName;

  void updateOption(SortingOption option, String source) {
    Analytic.get().logSortTypeUpdate(option, source);
    currentSelectedFilter = option;
    notifyListeners();
  }

  List<Habit> sort({
    required Iterable<Habit> source,
    required bool Function(Habit habit, DateTime time) completionChecker,
  }) {
    if (currentSelectedFilter == SortingOption.byReminder) {
      return source.toList()
        ..sort(
          (a, b) {
            if (a.reminder.isNotEmpty && b.reminder.isNotEmpty) {
              // if both a and b have reminder, sort by first reminder
              final timeA = TimeOfDay(
                hour: a.reminder.first.hour,
                minute: a.reminder.first.minute,
              );
              final timeB = TimeOfDay(
                hour: b.reminder.first.hour,
                minute: b.reminder.first.minute,
              );
              return timeA.compareTo(timeB);
            } else if (a.reminder.isNotEmpty && b.reminder.isEmpty) {
              // if a has reminder but b doesn't, don't switch
              return -1;
            } else if (a.reminder.isEmpty && b.reminder.isNotEmpty) {
              // if a doesn't have reminder but b has, swith place
              return 1;
            } else {
              // else, if both empty sort by name
              return a.name.compareTo(b.name);
            }
          },
        );
    } else if (currentSelectedFilter == SortingOption.byCompletion) {
      final now = DateTime.now();
      return source.toList()
        ..sort(
          (a, b) {
            final isAChecked = completionChecker(a, now);
            final isBChecked = completionChecker(b, now);

            if (!isAChecked && isBChecked) {
              return -1;
            } else if (isAChecked && !isBChecked) {
              return 1;
            } else {
              // else, if both checked or both unchecked
              return a.name.compareTo(b.name);
            }
          },
        );
    } else {
      //option == SortingOption.byName
      return source.toList()
        ..sort(
          (a, b) => a.name.compareTo(b.name),
        );
    }
  }
}

enum SortingOption {
  byName('Sort by Name'),
  byReminder('Sort by Reminder'),
  byCompletion('Sort by Completion');

  const SortingOption(this.title);
  final String title;
}

extension ListHabitExt on Iterable<Habit> {
  List<Habit> sortByName() {
    return toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}
