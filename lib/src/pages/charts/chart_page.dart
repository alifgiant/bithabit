import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/view/section_title.dart';
import 'package:flutter/material.dart';

import '../../utils/view/app_bar_title.dart';
import '../recap/monthly_recap.dart';
import '../recap/streak_recap.dart';
import '../recap/weekly_recap.dart';

class ChartPage extends StatelessWidget {
  final Habit habit;

  const ChartPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    final views = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Weekly Progress'),
      ),
      WeeklyProgress(habit: habit),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Monthly Progress'),
      ),
      MonthlyProgress(habit: habit),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Streak Progress'),
      ),
      StreakProgress(habit: habit),
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

class WeeklyProgress extends StatelessWidget {
  final Habit habit;
  const WeeklyProgress({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();
    return SizedBox(
      height: 116,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        reverse: true,
        itemCount: null,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: WeeklyRecap(
              habit: habit,
              date: today.subtract(Duration(days: (7 * index))),
            ),
          );
        },
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
    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        reverse: true,
        itemCount: null,
        itemBuilder: (BuildContext context, int index) {
          final firstDayOfMonth = DateTime(today.year, today.month - index, 1);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: MonthlyRecap(habit: habit, date: firstDayOfMonth),
          );
        },
      ),
    );
  }
}

class StreakProgress extends StatelessWidget {
  final Habit habit;
  const StreakProgress({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        reverse: true,
        itemCount: null,
        itemBuilder: (BuildContext context, int index) {
          const weekCount = 27;
          final day = today.subtract(Duration(days: index * 7 * weekCount));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: StreakRecap(habit: habit, date: day, weekCount: weekCount),
          );
        },
      ),
    );
  }
}
