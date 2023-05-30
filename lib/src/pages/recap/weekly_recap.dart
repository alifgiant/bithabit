import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../model/habit_color.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/habit_card_title.dart';

class WeeklyRecap extends StatelessWidget {
  final Habit habit;
  late final List<DateTime> week;

  WeeklyRecap({
    required this.habit,
    DateTime? date,
    super.key,
  }) {
    final today = date?.emptyHour() ?? DateTime.now().emptyHour();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    week = List.generate(
      7,
      (day) => startOfWeek.add(Duration(days: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();

    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => AddHabitButton.navToAddHabit(
          context,
          habit: habit,
          source: 'weekly_recap_item',
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: habit.color.textColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitCardTitle(
                  title: habit.name,
                  date: week.format(),
                ),
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: week
                      .map(
                        (day) => _DayCircle(
                          date: day,
                          habitColor: habit.color,
                          isChecked: timelineService.isHabitChecked(habit, day),
                          onTap: () => timelineService.check(habit, day),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  final DateTime date;
  final HabitColor habitColor;
  final bool isChecked;
  final VoidCallback onTap;

  const _DayCircle({
    required this.date,
    required this.habitColor,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSameAsToday = DateTime.now().isSameDay(date);
    return Column(
      children: [
        Text(
          date.dayName(),
          style: TextStyle(
            fontSize: 12,
            color: isSameAsToday ? habitColor.mainColor : null,
            fontWeight: isSameAsToday ? FontWeight.w800 : null,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          shape: CircleBorder(
            side: BorderSide(
              color: habitColor.mainColor,
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          color: isChecked ? habitColor.mainColor : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: SizedBox.square(
              dimension: 28,
              child: isChecked
                  ? Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: habitColor.textColor,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
