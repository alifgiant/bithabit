import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/res/res_color.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/view/calendar_box.dart';
import 'package:bithabit/src/utils/view/section_title.dart';
import 'package:flutter/material.dart';

import '../../utils/view/app_bar_title.dart';
import '../../utils/view/streak_dots.dart';

class ChartPage extends StatelessWidget {
  final Habit habit;

  const ChartPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    final views = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(
          text: 'Streak Progress',
          bottomPadding: 0,
        ),
      ),
      StreakDots(
        habit: habit,
        horizontalPadding: 12,
      ),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Monthly Progress'),
      ),
      // const SizedBox(height: 21),

      // MonthlyRecap(habit: habit),
      MonthlyProgress(habit: habit),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Visual Progress'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return views[index];
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemCount: views.length,
      ),
    );
  }
}

class MonthlyProgress extends StatelessWidget {
  final Habit habit;
  const MonthlyProgress({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();
    return LayoutBuilder(
      builder: (ctx, cons) => SizedBox(
        height: cons.maxWidth * 1,
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
