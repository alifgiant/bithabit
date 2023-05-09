import 'package:flutter/material.dart';

class AddHabitButton extends StatelessWidget {
  const AddHabitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/detail'),
      tooltip: 'Add Habit',
      icon: const Icon(Icons.add_rounded),
    );
  }
}
