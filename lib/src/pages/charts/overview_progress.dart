import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/service/timeline_service.dart';
import 'package:bithabit/src/utils/res/res_color.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/text/double_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewProgress extends StatelessWidget {
  final Habit habit;

  const OverviewProgress({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();

    final timelineService = context.watch<TimelineService>();

    final prevMonthCount = timelineService.countHabit(habit, month: today.month - 1);
    final prevMonthTotalDate = DateTime(today.year, today.month, 0).day;
    final prevMonthRatio = prevMonthCount / prevMonthTotalDate;

    final curMonthCount = timelineService.countHabit(habit, month: today.month);
    final curMonthTotalDate = DateTime(today.year, today.month + 1, 0).day;
    final curMonthRatio = curMonthCount / curMonthTotalDate;

    final monthDiff = curMonthRatio - prevMonthRatio;

    final prevYearCount = timelineService.countHabit(habit, year: today.year - 1);
    final prevYearTotalDay = (today.year - 1).getYearTotalDays();
    final prevYearRatio = prevYearCount / prevYearTotalDay;

    final curYearCount = timelineService.countHabit(habit, year: today.year);
    final curYearTotalDay = today.year.getYearTotalDays();
    final curYearRatio = curYearCount / curYearTotalDay;

    final yearDiff = curYearRatio - prevYearRatio;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _DetailOverview(
            habit: habit,
            value: curMonthRatio.toString(),
            text: 'Current\nMonth',
            mode: _OverviewMode.circleProgress,
          ),
          _DetailOverview(
            habit: habit,
            value: monthDiff.toPercentage(),
            text: 'Prev\nMonth',
            mode: _OverviewMode.text,
          ),
          _DetailOverview(
            habit: habit,
            value: yearDiff.toPercentage(),
            text: 'Prev\nYear',
            mode: _OverviewMode.text,
          ),
        ],
      ),
    );
  }
}

class _DetailOverview extends StatelessWidget {
  final Habit habit;
  final String value;
  final String text;
  final _OverviewMode mode;

  const _DetailOverview({
    required this.habit,
    required this.value,
    required this.text,
    this.mode = _OverviewMode.text,
  });

  @override
  Widget build(BuildContext context) {
    Widget getVisual() {
      if (mode == _OverviewMode.circleProgress) {
        final doubleValue = double.parse(value);
        return Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: doubleValue,
              valueColor: doubleValue == 1
                  ? const AlwaysStoppedAnimation<Color>(
                      ResColor.lightPurple,
                    )
                  : null,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            if (doubleValue == 1) const Icon(Icons.star_rounded, color: ResColor.lightPurple)
          ],
        );
      } else {
        return Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: habit.color.mainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 72,
            width: 86,
            child: getVisual(),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.2,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

enum _OverviewMode { circleProgress, text }
