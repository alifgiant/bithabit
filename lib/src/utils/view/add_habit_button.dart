import 'package:bithabit/src/service/analytic_service.dart';
import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../service/navigation_service.dart';
import '../const/app_route.dart';

class AddHabitButton extends StatelessWidget {
  final String source;
  const AddHabitButton({
    required this.source,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => AddHabitButton.navToAddHabit(context, source: source),
      tooltip: 'Add Habit',
      icon: const Icon(Icons.add_rounded),
    );
  }

  static Future<void> navToAddHabit(
    BuildContext context, {
    required String source,
    Habit? habit,
  }) {
    if (habit != null) Analytic.get().logHabitAction(habit, HabitAction.open);

    return NavigationService.of(context).open(
      AppRoute.detail,
      arguments: habit,
    );
  }
}
