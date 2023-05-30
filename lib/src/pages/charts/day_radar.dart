import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';
import '../../utils/text/date_utils.dart';

class DayRadar extends StatelessWidget {
  final Habit habit;

  const DayRadar({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          dataSets: showingDataSets(context),
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.1,
          getTitle: (day, _) => RadarChartTitle(
            text: getDayNameText(day + 1),
          ),
          tickCount: 2,
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 10,
          ),
          tickBorderData: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets(BuildContext context) {
    final timelineService = context.watch<TimelineService>();
    final rawDataSet = RawDataSet(
      title: "Day's Frequency",
      color: habit.color.mainColor,
      values: List.generate(
        7,
        (day) => timelineService.counter
            .completionIn(
              habit,
              dayOfWeek: day + 1,
            )
            .toDouble(),
      ),
    );

    return [
      RadarDataSet(
        fillColor: rawDataSet.color.withOpacity(0.2),
        borderColor: rawDataSet.color,
        dataEntries: rawDataSet.values
            .map(
              (e) => RadarEntry(value: e),
            )
            .toList(),
        entryRadius: 2.3,
        borderWidth: 2.3,
      )
    ];
  }

  String getDayNameText(int pos) {
    /// dayNames start from sunday, pos start from 1
    /// sunday == 0
    /// monday == 1
    final dayNames = AppDateFormat.dayNameFormat.dateSymbols.SHORTWEEKDAYS;
    return pos < dayNames.length ? dayNames[pos] : dayNames[0];
  }
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}
