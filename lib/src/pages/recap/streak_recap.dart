import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../model/habit.dart';

class StreakRecap extends StatelessWidget {
  final Habit habit;

  const StreakRecap({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

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
                  ],
                ),
                const SizedBox(height: 21),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: week
                //       .map(
                //         (day) => _DayCircle(
                //           date: day,
                //           habitColor: habit.color,
                //           isChecked: timelineService.isHabitChecked(habit, day),
                //           onTap: () => timelineService.check(habit, day),
                //         ),
                //       )
                //       .toList(),
                // ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
