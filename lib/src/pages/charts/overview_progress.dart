import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:bithabit/src/utils/text/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/res/res_color.dart';

class OverviewProgress extends StatelessWidget {
  final Habit habit;

  const OverviewProgress({
    required this.habit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();

    final timelineService = context.watch<TimelineService>();

    final prevMonthRatio = timelineService.habitCompletion(habit, today.year, month: today.month - 1);
    final curMonthRatio = timelineService.habitCompletion(habit, today.year, month: today.month);
    final monthDiff = curMonthRatio - prevMonthRatio;

    final prevYearRatio = timelineService.habitCompletion(habit, today.year - 1);
    final curYearRatio = timelineService.habitCompletion(habit, today.year);
    final yearDiff = curYearRatio - prevYearRatio;

    final bestStreak = timelineService.countBestStreak(habit);

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
          _DetailOverview(
            habit: habit,
            value: bestStreak.formatShort(),
            text: 'Best\nStreak',
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
    required this.mode,
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
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
