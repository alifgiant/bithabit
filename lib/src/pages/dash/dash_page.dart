import 'package:bithabit/src/service/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../service/sorting_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/simple_habit_view.dart';
import '../home/sort_habit_button.dart';
import 'completed_count.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    final mediaQuery = MediaQuery.of(context);
    final halfScreen = mediaQuery.size.height / 2;

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

    int id = 0;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            actions: const [
              SizedBox(width: 8),
              AddHabitButton(source: 'dash_page'),
              SizedBox(width: 8),
              SortHabitButton(),
              SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
          if (habits.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: screenPadding,
                    vertical: 6,
                  ),
                  child: SimpleHabitView(
                    key: ValueKey(habits[index].id),
                    habit: habits[index],
                  ),
                ),
                childCount: habits.length,
              ),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: halfScreen - 152 /* app bar sie */ - 21),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<NotificationManager>()
                          .showNotification(id++);
                    },
                    child: const Icon(Icons.offline_bolt_rounded, size: 52),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<NotificationManager>()
                          .scheduleNotification(id++);
                    },
                    child: const Text('No Schedule for Today'),
                  ),
                ],
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: kBottomNavigationBarHeight * 2),
          )
        ],
      ),
    );
  }
}
