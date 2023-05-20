import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/view/section_title.dart';
import 'package:flutter/material.dart';

import '../../utils/view/app_bar_title.dart';
import '../../utils/view/streak_dots.dart';
import 'monthly_progress.dart';
import 'overview_progress.dart';

class ChartPage extends StatelessWidget {
  final Habit habit;

  const ChartPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    final views = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Overview'),
      ),
      OverviewProgress(habit: habit),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'All Time Streak', topPadding: 40),
      ),
      StreakDots(habit: habit, horizontalPadding: 12),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Monthly Score'),
      ),
      Text('Monthly Score'),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Monthly Progress'),
      ),
      MonthlyProgress(habit: habit),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Visual Progress'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => views[index],
        itemCount: views.length,
      ),
    );
  }
}
