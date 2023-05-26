import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/section_title.dart';
import '../../utils/view/streak_dots.dart';
import 'day_radar.dart';
import 'monthly_progress.dart';
import 'overview_progress.dart';
import 'score_progress.dart';

class ChartPage extends StatelessWidget {
  final Habit habit;

  const ChartPage({
    required this.habit,
    super.key,
  });

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
        child: SectionTitle(text: 'All Months Score'),
      ),
      ScoreProgress(habit: habit),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Day Frequency'),
      ),
      DayRadar(habit: habit),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: SectionTitle(text: 'Monthly Recap'),
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
