import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../model/habit_color.dart';
import '../../service/timeline_service.dart';

class CalendarBox extends StatelessWidget {
  final Habit habit;
  final DateTime firstDayOfMonth;
  final bool enableClick;

  late final List<DateTime> monthDates;

  final Color? unselectedTextColor;

  CalendarBox({
    required this.habit,
    required this.firstDayOfMonth,
    this.unselectedTextColor,
    this.enableClick = true,
    super.key,
  }) {
    // Get first day of month's weekday.
    // to help position date:1 on correct day position
    // final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final lastDayOfMonth = DateTime(
      firstDayOfMonth.year,
      firstDayOfMonth.month + 1,
      0,
    );
    final firstWeekDay = firstDayOfMonth.weekday - 1;
    final lastWeekDay = 7 - lastDayOfMonth.weekday;

    // Get the number of days in the current month
    final totalShowedDays = lastDayOfMonth.day + firstWeekDay + lastWeekDay;
    monthDates = List.generate(
      totalShowedDays,
      (index) => DateTime(
        firstDayOfMonth.year,
        firstDayOfMonth.month,
        index - (firstDayOfMonth.weekday - 1) + 1, // calculate date
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();

    return LayoutBuilder(
      builder: (ctx, constraints) {
        const buttonSpacing = 6.0;
        const horizontalItemCount = 7;
        const totalButtonSpacing = (horizontalItemCount - 1) * buttonSpacing;
        final maxWidth = constraints.maxWidth - totalButtonSpacing - 1;
        final buttonSize = maxWidth / horizontalItemCount;

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
                            color: unselectedTextColor ?? habit.color.textColor,
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
                        monthDate: firstDayOfMonth,
                        date: day,
                        habitColor: habit.color,
                        isChecked: timelineService.isHabitChecked(habit, day),
                        unselectedTextColor: unselectedTextColor,
                        onTap: enableClick
                            ? () => timelineService.maybeCheck(
                                  context,
                                  habit,
                                  day,
                                )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class _MonthDayBox extends StatelessWidget {
  const _MonthDayBox({
    required this.monthDate,
    required this.date,
    required this.habitColor,
    required this.isChecked,
    this.onTap,
    this.unselectedTextColor,
  });

  final DateTime monthDate;
  final DateTime date;
  final HabitColor habitColor;
  final bool isChecked;
  final Color? unselectedTextColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSameMonth = monthDate.isSameMonth(date);
    if (!isSameMonth) return const SizedBox.shrink();

    final today = DateTime.now();
    final isSameAsToday = today.isSameDay(date);

    Color getTextColor() {
      if (isChecked) return habitColor.textColor;
      return unselectedTextColor ?? habitColor.textColor;
    }

    return Material(
      shape: CircleBorder(
        side: BorderSide(
          color: habitColor.mainColor,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      color: isChecked
          ? habitColor.mainColor
          : habitColor.mainColor.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 12,
              color: getTextColor(),
              fontWeight: isSameAsToday ? FontWeight.w800 : null,
            ),
          ),
        ),
      ),
    );
  }
}
