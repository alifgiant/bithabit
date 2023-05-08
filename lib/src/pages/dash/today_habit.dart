import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';

class TodayHabit extends StatelessWidget {
  final Habit habit;
  late final List<DateTime> week;

  TodayHabit({
    super.key,
    required this.habit,
  }) {
    final today = DateTime.now().emptyHour();
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit.name.titleCase,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      week.format(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
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
  late final DateTime today;

  _DayCircle({
    required this.date,
    required this.habitColor,
    required this.isChecked,
    required this.onTap,
  }) {
    today = DateTime.now().emptyHour();
  }

  @override
  Widget build(BuildContext context) {
    final isSameAsToday = today.isAtSameMomentAs(date);
    return Column(
      children: [
        Text(
          date.dayName(),
          style: TextStyle(
            fontSize: 10,
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
