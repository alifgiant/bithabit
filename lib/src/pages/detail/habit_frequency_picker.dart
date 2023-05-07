import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/res/res_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:recase/recase.dart';

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
  late final ValueNotifier<HabitFrequency> segmentNotifier;

  @override
  void initState() {
    super.initState();
    segmentNotifier = ValueNotifier(widget.selectedFrequency);
    segmentNotifier.addListener(
      () => widget.onFrequencySelected(segmentNotifier.value),
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
      backgroundColor: const Color(0xfff2f2f2),
      sliderOffset: 2.5,
      segments: {
        for (var val in HabitFrequency.values) val: val.name.titleCase,
      },
    );
  }
}
