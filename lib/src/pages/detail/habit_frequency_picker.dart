import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:recase/recase.dart';

import '../../model/habit_frequency.dart';
import '../../utils/res/res_color.dart';
import '../../utils/text/date_utils.dart';
import '../../utils/view/view_utils.dart';

class HabitFrequencyPicker extends StatefulWidget {
  final HabitFrequency selectedFrequency;
  final void Function(HabitFrequency frequency) onFrequencySelected;
  final bool enabled;

  const HabitFrequencyPicker({
    required this.selectedFrequency,
    required this.onFrequencySelected,
    this.enabled = true,
    super.key,
  });

  @override
  State<HabitFrequencyPicker> createState() => _HabitFrequencyPickerState();
}

class _HabitFrequencyPickerState extends State<HabitFrequencyPicker> {
  late final ValueNotifier<FrequencyType> segmentNotifier;
  HabitFrequency get edittedFrequency => widget.selectedFrequency;

  @override
  void initState() {
    super.initState();
    segmentNotifier = ValueNotifier(edittedFrequency.type);
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
      controller: widget.enabled ? segmentNotifier : null,
      sliderColor: ResColor.white,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      sliderOffset: 2.5,
      segments: {
        FrequencyType.daily: FrequencyType.daily.key.titleCase,
        FrequencyType.monthly: FrequencyType.monthly.key.titleCase,
      },
    );
  }

  HabitFrequency updateFrequency({required FrequencyType frequencyType}) {
    return HabitFrequency(
      selected: edittedFrequency.selected,
      type: frequencyType,
    );
  }
}

class HabitFrequencyValuePicker extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final void Function(HabitFrequency frequency) onFrequencySelected;
  final double screenPadding;
  final bool enabled;

  const HabitFrequencyValuePicker({
    required this.selectedFrequency,
    required this.onFrequencySelected,
    this.screenPadding = 16,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSpacing = 8.0;
    final isDailyType = selectedFrequency.type == FrequencyType.daily;

    return LayoutBuilder(
      builder: (ctx, constraint) {
        final buttonSize = (constraint.maxWidth - (6 * buttonSpacing) - 1) / 7;
        return Wrap(
          spacing: buttonSpacing,
          runSpacing: buttonSpacing,
          children: List.generate(
            isDailyType ? 7 : 31,
            (index) {
              final pos = index + 1;
              final isSelected = selectedFrequency.selected.contains(pos);
              return Material(
                elevation: isSelected ? 2 : 0,
                color: isSelected ? null : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: enabled
                      ? () {
                          final newFreq = updateFrequency(selectedDate: pos);
                          onFrequencySelected(newFreq);
                        }
                      : () => ViewUtils.showHabitArchieved(context),
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
          ),
        );
      },
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
    final newSet = selectedFrequency.selected.toSet();
    if (newSet.contains(selectedDate)) {
      newSet.remove(selectedDate);
    } else {
      newSet.add(selectedDate);
    }

    return selectedFrequency.copyWith(selected: newSet.toList());
  }
}
