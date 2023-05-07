import 'package:flutter/material.dart';

import '../../model/habit.dart';

class HabitColorPicker extends StatelessWidget {
  final HabitColor selectedColor;
  final void Function(HabitColor) onColorSelected;

  const HabitColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: HabitColor.values
          .map(
            (e) => Material(
              color: e.mainColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => onColorSelected(e),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: selectedColor == e
                      ? Icon(
                          Icons.check_rounded,
                          size: 21,
                          color: e.textColor,
                        )
                      : null,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
