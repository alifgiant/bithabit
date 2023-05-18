import 'package:flutter/material.dart';

class AddHabitButton extends StatelessWidget {
  const AddHabitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => AddHabitButton.navToAddHabit(context),
      tooltip: 'Add Habit',
      icon: const Icon(Icons.add_rounded),
    );
  }

  static Future<T?> navToAddHabit<T>(BuildContext context) {
    return Navigator.of(context).pushNamed('/detail');
  }
}
