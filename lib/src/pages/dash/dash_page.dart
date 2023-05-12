import 'package:bithabit/src/service/habit_service.dart';
import 'package:bithabit/src/service/sorting_service.dart';
import 'package:bithabit/src/service/timeline_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/view/add_habit_button.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/sort_habit_button.dart';
import 'completed_count.dart';
import 'today_habit.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;

    // habit changes watcher
    final today = DateTime.now();
    final habitService = context.watch<HabitService>();
    final sourceHabit = habitService.getHabits(day: today);

    // timeline changes watcher
    final timelineService = context.watch<TimelineService>();
    final completed = sourceHabit.where(
      (habit) => timelineService.isHabitChecked(
        habit,
        today,
      ),
    );

    // sorting changes watcher
    final sortingService = context.watch<SortingService>();
    final habits = sortingService.sort(
      source: sourceHabit,
      completionChecker: timelineService.isHabitChecked,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            actions: const [
              AddHabitButton(),
              SortHabitButton(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompletedCount(
                      total: habits.length,
                      completed: completed.length,
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
                child: TodayHabit(
                  key: ValueKey(habits[index].id),
                  habit: habits[index],
                ),
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
