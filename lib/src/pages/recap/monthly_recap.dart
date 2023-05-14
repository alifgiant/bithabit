import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/habit_card_title.dart';

class MonthlyRecap extends StatelessWidget {
  final Habit habit;
  late final String monthName;
  late final List<DateTime> monthDates;

  MonthlyRecap({super.key, required this.habit}) {
    final now = DateTime.now();
    monthName = now.monthName();

    // Get first day of month's weekday. to help position date:1 on correct day position
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstWeekDay = firstDayOfMonth.weekday;
    final lastWeekDay = lastDayOfMonth.weekday;

    // Get the number of days in the current month
    final totalShowedDays = lastDayOfMonth.day + (firstWeekDay - 1) + (7 - lastWeekDay);
    monthDates = List.generate(
      totalShowedDays,
      (index) => DateTime(
        now.year,
        now.month,
        index - (firstDayOfMonth.weekday - 1) + 1, // calculate date
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();

    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed(
          '/detail',
          arguments: habit,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: habit.color.textColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitCardTitle(
                  title: habit.name,
                  desc: habit.desc,
                  date: monthName,
                ),
                const SizedBox(height: 21),
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    const buttonSpacing = 6.0;
                    const horizontalItemCount = 7;
                    final buttonSize = (constraints.maxWidth - ((horizontalItemCount - 1) * buttonSpacing) - 1) / horizontalItemCount;

                    return Column(
                      children: [
                        Wrap(
                          spacing: buttonSpacing,
                          runSpacing: buttonSpacing,
                          children: AppDateFormat.dayNames
                              .map(
                                (e) => SizedBox(
                                  width: buttonSize,
                                  child: Center(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: habit.color.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: buttonSpacing,
                          runSpacing: buttonSpacing,
                          children: monthDates
                              .map(
                                (day) => SizedBox.square(
                                  dimension: buttonSize,
                                  child: _MonthDayBox(
                                    date: day,
                                    habitColor: habit.color,
                                    isChecked: timelineService.isHabitChecked(habit, day),
                                    onTap: () => timelineService.check(habit, day),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthDayBox extends StatelessWidget {
  const _MonthDayBox({
    required this.date,
    required this.habitColor,
    required this.isChecked,
    required this.onTap,
  });

  final DateTime date;
  final HabitColor habitColor;
  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isSameMonth = now.isSameMonth(date);
    if (!isSameMonth) return const SizedBox.shrink();

    final isSameAsToday = now.isSameDay(date);
    return Material(
      shape: CircleBorder(
        side: BorderSide(color: habitColor.mainColor, width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      color: isChecked ? habitColor.mainColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 12,
              color: habitColor.textColor,
              fontWeight: isSameAsToday ? FontWeight.w800 : null,
            ),
          ),
        ),
      ),
    );
  }
}
