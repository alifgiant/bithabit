import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/app_bar_title.dart';
import 'weekly_habit.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final habits = habitService.getHabits().toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const AppBarTitle(text: 'Weekly Recap'),
        actions: [
          const AddHabitButton(),
          IconButton(
            onPressed: () {},
            tooltip: 'Sort Habit',
            icon: const Icon(Icons.sort_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16).copyWith(
          bottom: kBottomNavigationBarHeight + 12,
        ),
        itemBuilder: (_, index) => WeeklyHabit(habit: habits[index]),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: habits.length,
      ),
    );
  }
}
