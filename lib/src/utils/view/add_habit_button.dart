import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../service/navigation_service.dart';
import '../const/app_route.dart';

class AddHabitButton extends StatelessWidget {
  const AddHabitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => AddHabitButton.navToAddHabit(context),
      tooltip: 'Add Habit',
      icon: const Icon(Icons.add_rounded),
    );
  }

  static Future<void> navToAddHabit(
    BuildContext context, {
    Habit? habit,
  }) {
    return NavigationService.of(context).open(
      AppRoute.detail,
      arguments: habit,
    );
  }
}
