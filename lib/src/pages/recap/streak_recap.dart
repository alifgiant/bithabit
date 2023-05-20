import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/habit_card_title.dart';

class StreakRecap extends StatelessWidget {
  final Habit habit;
  final int weekCount;
  late final DateTime today;

  StreakRecap({
    super.key,
    required this.habit,
    this.weekCount = 27,
    DateTime? date,
  }) {
    today = date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();

    final dotsSection = LayoutBuilder(
      builder: (ctx, constraints) {
        const buttonSpacing = 2.0;
        final totalHSpacing = (weekCount - 1) * buttonSpacing;
        final buttonSize = (constraints.maxWidth - totalHSpacing - 1) / weekCount;

        const totalVSpacing = 7 * buttonSpacing;
        final verticalSpan = buttonSize * 7 + totalVSpacing;

        return SizedBox(
          height: verticalSpan,
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int hIndex) {
              final totalDays = weekCount * 7 /* 7 days in a week */;
              final day = today.subtract(Duration(days: totalDays * hIndex));
              final dayWeek = day.weekday;
              final streakDates = List.generate(
                totalDays,
                (index) {
                  final boxDay = day.subtract(
                    Duration(days: (totalDays - (7 - dayWeek) - 1) - index),
                  );
                  return SizedBox.square(
                    dimension: buttonSize,
                    child: _StreakBox(
                      date: boxDay,
                      habitColor: habit.color,
                      isChecked: timelineService.isHabitChecked(habit, boxDay),
                    ),
                  );
                },
              );
              return Padding(
                padding: const EdgeInsets.only(left: buttonSpacing - 0.2),
                child: Wrap(
                  direction: Axis.vertical,
                  verticalDirection: VerticalDirection.down,
                  spacing: buttonSpacing,
                  runSpacing: buttonSpacing - 0.2,
                  children: streakDates,
                ),
              );
            },
            itemCount: null,
          ),
        );
      },
    );

    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
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
                dotsSection,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakBox extends StatelessWidget {
  const _StreakBox({
    required this.date,
    required this.habitColor,
    required this.isChecked,
  });

  final DateTime date;
  final HabitColor habitColor;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final isAfterToday = date.isAfter(DateTime.now());
    if (isAfterToday) return const SizedBox.shrink();

    return Material(
      shape: CircleBorder(
        side: BorderSide(color: habitColor.mainColor, width: 1.2),
      ),
      color: isChecked ? habitColor.mainColor : habitColor.mainColor.withOpacity(0.2),
    );
  }
}
