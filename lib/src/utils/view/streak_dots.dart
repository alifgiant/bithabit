import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../model/habit_color.dart';
import '../../service/timeline_service.dart';

class StreakDots extends StatelessWidget {
  final int weekCount;
  final Habit habit;
  final double horizontalPadding;
  late final DateTime today;

  StreakDots({
    required this.habit,
    this.weekCount = 27,
    this.horizontalPadding = 0,
    DateTime? date,
    super.key,
  }) {
    today = date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();
    return LayoutBuilder(
      builder: (ctx, constraints) {
        const buttonSpacing = 2.0;
        final totalHSpacing = (weekCount - 1) * buttonSpacing;
        final buttonSize = (constraints.maxWidth - totalHSpacing - 1) / weekCount;

        const totalVSpacing = 7 * buttonSpacing;
        final verticalSpan = buttonSize * 7 + totalVSpacing;

        return SizedBox(
          height: verticalSpan,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  spacing: buttonSpacing,
                  runSpacing: buttonSpacing - 0.2,
                  children: streakDates,
                ),
              );
            },
          ),
        );
      },
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
