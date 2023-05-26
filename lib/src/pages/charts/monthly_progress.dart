import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../utils/res/res_color.dart';
import '../../utils/view/calendar_box.dart';

class MonthlyProgress extends StatelessWidget {
  final Habit habit;
  const MonthlyProgress({
    required this.habit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();
    return AspectRatio(
      aspectRatio: 1.1,
      child: SizedBox(
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.8),
          reverse: true,
          itemCount: null,
          itemBuilder: (BuildContext context, int index) {
            final firstDayOfMonth = DateTime(today.year, today.month - index, 1);
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: habit.color.mainColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Column(
                      children: [
                        Text(
                          firstDayOfMonth.monthName(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CalendarBox(
                          habit: habit,
                          firstDayOfMonth: firstDayOfMonth,
                          unselectedTextColor: ResColor.black,
                          enableClick: true, // todo: set to false
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
