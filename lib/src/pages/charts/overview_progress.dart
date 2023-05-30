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

  double calculateRatio(
    TimelineService timelineService,
    int year, {
    int? month,
  }) {
    final monthCount = timelineService.counter.completionIn(
      habit,
      year: year,
      month: month,
    );

    final totalDays = month != null
        ? month.getMonthTotalDays(year: year)
        : year.getYearTotalDays();

    return monthCount / totalDays;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().emptyHour();

    final timelineService = context.watch<TimelineService>();
    final prevMonthRatio = calculateRatio(
      timelineService,
      today.year,
      month: today.month - 1,
    );
    final curMonthRatio = calculateRatio(
      timelineService,
      today.year,
      month: today.month,
    );
    final monthDiff = curMonthRatio - prevMonthRatio;

    final prevYearRatio = calculateRatio(timelineService, today.year - 1);
    final curYearRatio = calculateRatio(timelineService, today.year);
    final yearDiff = curYearRatio - prevYearRatio;

    final bestStreak = timelineService.counter.bestStreak(habit);

    const paddingH = 12.0;
    const spaceH = 6.0;

    return LayoutBuilder(builder: (ctx, cons) {
      final maxWidth = cons.maxWidth - paddingH * 2 - spaceH * 3;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingH),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _DetailOverview(
              width: maxWidth / 4,
              bgColor: habit.color.mainColor.withOpacity(0.2),
              value: curMonthRatio.toString(),
              text: 'Current\nMonth',
              mode: _OverviewMode.circleProgress,
            ),
            _DetailOverview(
              width: maxWidth / 4,
              bgColor: habit.color.mainColor.withOpacity(0.2),
              value: monthDiff.toPercentage(),
              text: 'Prev\nMonth',
              mode: _OverviewMode.text,
            ),
            _DetailOverview(
              width: maxWidth / 4,
              bgColor: habit.color.mainColor.withOpacity(0.2),
              value: yearDiff.toPercentage(),
              text: 'Prev\nYear',
              mode: _OverviewMode.text,
            ),
            _DetailOverview(
              width: maxWidth / 4,
              bgColor: habit.color.mainColor.withOpacity(0.2),
              value: bestStreak.formatShort(),
              text: 'Best\nStreak',
              mode: _OverviewMode.text,
            ),
          ],
        ),
      );
    });
  }
}

class _DetailOverview extends StatelessWidget {
  final double width;
  final Color bgColor;
  final String value;
  final String text;
  final _OverviewMode mode;

  const _DetailOverview({
    required this.width,
    required this.bgColor,
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
            if (doubleValue == 1)
              const Icon(
                Icons.star_rounded,
                color: ResColor.lightPurple,
              )
          ],
        );
      } else {
        return Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: width / 4 - 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: width,
            child: getVisual(),
          ),
          FittedBox(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

enum _OverviewMode { circleProgress, text }
