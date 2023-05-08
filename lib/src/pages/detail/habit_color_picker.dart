import 'package:flutter/material.dart';

import '../../model/habit.dart';

class HabitColorPicker extends StatelessWidget {
  final HabitColor selectedColor;
  final void Function(HabitColor color) onColorSelected;
  final double screenPadding;

  const HabitColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.screenPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    const buttonSpacing = 8.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = (screenWidth - (6 * buttonSpacing) - (screenPadding * 2)) / 6;
    return Wrap(
      spacing: buttonSpacing,
      runSpacing: buttonSpacing,
      children: HabitColor.values
          .map(
            (e) => Material(
              color: e.mainColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onColorSelected(e),
                child: SizedBox(
                  width: buttonSize,
                  height: buttonSize,
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
