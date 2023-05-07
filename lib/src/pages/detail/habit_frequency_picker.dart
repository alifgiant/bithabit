import 'package:bithabit/src/model/habit.dart';
import 'package:flutter/material.dart';

class HabitFrequencyPicker extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final void Function(HabitFrequency frequency) onFrequencySelected;

  const HabitFrequencyPicker({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        hintText: 'Frequency',
      ),
    );
  }
}
