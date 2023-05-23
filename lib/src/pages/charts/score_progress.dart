import 'package:bithabit/src/utils/text/num_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/res/res_color.dart';
import '../../utils/text/date_utils.dart';

class ScoreProgress extends StatelessWidget {
  final Habit habit;
  final now = DateTime.now();

  ScoreProgress({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: LineChart(mainData(context)),
      ),
    );
  }

  LineChartData mainData(BuildContext context) {
    final timelineService = context.watch<TimelineService>();
    final List<Color> gradientColors = [
      habit.color.mainColor.withOpacity(0.3),
      habit.color.mainColor,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 0.25,
        getDrawingHorizontalLine: (_) => FlLine(
          color: Colors.grey,
          strokeWidth: 0.4,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 0.4),
          bottom: BorderSide(color: Colors.grey, width: 0.4),
        ),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 1,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: habit.color.mainColor,
          getTooltipItems: (spot) => spot
              .map(
                (e) => LineTooltipItem(
                  '${e.y.toPercentage(withPositiveSign: false)}\n(${getMonthName((e.x - 1).toInt())})',
                  const TextStyle(color: ResColor.white),
                ),
              )
              .toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            now.month,
            (index) => FlSpot(
              (index + 1).toDouble(),
              timelineService.habitCompletion(habit, now.year, month: index + 1),
            ),
          ),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          preventCurveOverShooting: true,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }

  String getMonthName(int pos) {
    return AppDateFormat.onlyMonthFormat.dateSymbols.STANDALONESHORTMONTHS[pos];
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text = Text(
      getMonthName(value.toInt() - 1),
      style: const TextStyle(fontSize: 12),
    );
    if (value == 1) text = const Text('');

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
