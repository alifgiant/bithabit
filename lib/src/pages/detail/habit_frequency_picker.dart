import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:recase/recase.dart';

import '../../model/habit.dart';
import '../../utils/res/res_color.dart';
import '../../utils/text/date_utils.dart';

class HabitFrequencyPicker extends StatefulWidget {
  final HabitFrequency selectedFrequency;
  final void Function(HabitFrequency frequency) onFrequencySelected;

  const HabitFrequencyPicker({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencySelected,
  });

  @override
  State<HabitFrequencyPicker> createState() => _HabitFrequencyPickerState();
}

class _HabitFrequencyPickerState extends State<HabitFrequencyPicker> {
  late final ValueNotifier<Type> segmentNotifier;
  HabitFrequency get edittedFrequency => widget.selectedFrequency;

  @override
  void initState() {
    super.initState();
    segmentNotifier = ValueNotifier(edittedFrequency.runtimeType);
    segmentNotifier.addListener(
      () {
        final newFrequency = updateFrequency(frequencyType: segmentNotifier.value);
        widget.onFrequencySelected(newFrequency);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    segmentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedSegment(
      controller: segmentNotifier,
      sliderColor: ResColor.white,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      sliderOffset: 2.5,
      segments: {
        DailyFrequency: DailyFrequency.name.titleCase,
        MonthlyFrequency: MonthlyFrequency.name.titleCase,
      },
    );
  }

  HabitFrequency updateFrequency({required Type frequencyType}) {
    switch (frequencyType) {
      case DailyFrequency:
        return DailyFrequency(selected: edittedFrequency.selected);
      case MonthlyFrequency:
        return MonthlyFrequency(selected: edittedFrequency.selected);
      default:
        return DailyFrequency(selected: edittedFrequency.selected);
    }
  }
}

class HabitFrequencyValuePicker extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final void Function(HabitFrequency frequency) onFrequencySelected;
  final double screenPadding;

  const HabitFrequencyValuePicker({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencySelected,
    this.screenPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSpacing = 8.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth - (6 * buttonSpacing) - (screenPadding * 2)) / 7;

    final isDailyType = selectedFrequency is DailyFrequency;

    return Wrap(
      spacing: buttonSpacing,
      runSpacing: buttonSpacing,
      children: List.generate(
        isDailyType ? 7 : 31,
        (index) => index + 1,
      ).map(
        (pos) {
          final isSelected = selectedFrequency.selected.contains(pos);

          return Material(
            elevation: isSelected ? 2 : 0,
            color: isSelected ? null : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                final newFreq = updateFrequency(selectedDate: pos);
                onFrequencySelected(newFreq);
              },
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: Center(
                  child: Text(
                    isDailyType ? getDayNameText(pos) : pos.toString(),
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  String getDayNameText(int pos) {
    /// dayNames start from sunday, pos start from 1
    /// sunday == 0
    /// monday == 1
    final dayNames = AppDateFormat.dayNameFormat.dateSymbols.SHORTWEEKDAYS;
    return pos < dayNames.length ? dayNames[pos] : dayNames[0];
  }

  HabitFrequency updateFrequency({
    required int selectedDate,
  }) {
    Set<int> newSet = selectedFrequency.selected.toSet();
    if (newSet.contains(selectedDate)) {
      newSet.remove(selectedDate);
    } else {
      newSet.add(selectedDate);
    }

    return selectedFrequency.copyWith(selected: newSet);
  }
}
