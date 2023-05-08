import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/app_bar_title.dart';
import 'completed_count.dart';
import 'today_habit.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;

    final today = DateTime.now();
    final habitService = context.watch<HabitService>();
    final habits = habitService.getHabits(day: today).toList();

    final timelineService = context.watch<TimelineService>();
    final completed = habits
        .where(
          (habit) => timelineService.isHabitChecked(habit, today),
        )
        .length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/detail'),
                tooltip: 'Add Habit',
                icon: const Icon(Icons.add_rounded),
              ),
              IconButton(
                onPressed: () {},
                tooltip: 'Sort Habit',
                icon: const Icon(Icons.sort_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).viewPadding.top),
                    CompletedCount(
                      completed: completed,
                      total: habits.length,
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.all(16),
              title: const AppBarTitle(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: screenPadding,
                  vertical: 6,
                ),
                child: TodayHabit(habit: habits[index]),
              ),
              childCount: habits.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: kBottomNavigationBarHeight + screenPadding),
          )
        ],
      ),
    );
  }
}
