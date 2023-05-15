import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/habit_card_title.dart';

class StreakRecap extends StatelessWidget {
  final Habit habit;
  final int weekCount;
  late final DateTime today;
  late final List<DateTime> streakDates;

  StreakRecap({
    super.key,
    required this.habit,
    this.weekCount = 27,
  }) {
    today = DateTime.now();

    final totalDays = weekCount * 7 /* 7 days in a week */;
    final dayWeek = today.weekday;

    streakDates = List.generate(
      totalDays,
      (index) {
        final row = index ~/ weekCount;
        final column = index % weekCount;
        final flipPos = row + (column * 7);

        final addedDay = (totalDays - (7 - dayWeek) - 1) - flipPos;
        return today.add(Duration(days: -addedDay));
      },
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
                  date: [streakDates.first, today].format(),
                ),
                const SizedBox(height: 21),
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    const buttonSpacing = 2.0;
                    final buttonSize = (constraints.maxWidth - ((weekCount - 1) * buttonSpacing) - 1) / weekCount;

                    return Wrap(
                      spacing: buttonSpacing,
                      runSpacing: buttonSpacing,
                      children: streakDates
                          .map(
                            (day) => SizedBox.square(
                              dimension: buttonSize,
                              child: _StreakBox(
                                date: day,
                                habitColor: habit.color,
                                isChecked: timelineService.isHabitChecked(
                                  habit,
                                  day,
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
