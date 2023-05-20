import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/view/add_habit_button.dart';
import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../utils/view/calendar_box.dart';
import '../../utils/view/habit_card_title.dart';

class MonthlyRecap extends StatelessWidget {
  final Habit habit;
  const MonthlyRecap({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();
    return LayoutBuilder(
      builder: (ctx, cons) => SizedBox(
        height: cons.maxWidth * 0.75,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.8),
          reverse: true,
          itemCount: null,
          itemBuilder: (BuildContext context, int index) {
            final firstDayOfMonth = DateTime(today.year, today.month - index, 1);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SingleMonth(habit: habit, firstDayOfMonth: firstDayOfMonth),
            );
          },
        ),
      ),
    );
  }
}

class SingleMonth extends StatelessWidget {
  final Habit habit;
  late final String monthName;

  final DateTime firstDayOfMonth;

  SingleMonth({
    super.key,
    required this.habit,
    required this.firstDayOfMonth,
  }) {
    monthName = firstDayOfMonth.monthName();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => AddHabitButton.navToAddHabit(context, habit: habit),
        child: DefaultTextStyle(
          style: TextStyle(color: habit.color.textColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitCardTitle(title: habit.name, date: monthName),
                const SizedBox(height: 21),
                CalendarBox(habit: habit, firstDayOfMonth: firstDayOfMonth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
