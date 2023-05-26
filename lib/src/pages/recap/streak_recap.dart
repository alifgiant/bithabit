import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/habit_card_title.dart';
import '../../utils/view/streak_dots.dart';

class StreakRecap extends StatelessWidget {
  final Habit habit;
  final int weekCount;
  late final DateTime today;

  StreakRecap({
    required this.habit,
    this.weekCount = 27,
    DateTime? date,
    super.key,
  }) {
    today = date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => AddHabitButton.navToAddHabit(context, habit: habit),
        child: DefaultTextStyle(
          style: TextStyle(color: habit.color.textColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              children: [
                HabitCardTitle(title: habit.name, date: 'All Time'),
                const SizedBox(height: 21),
                StreakDots(weekCount: weekCount, date: today, habit: habit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
