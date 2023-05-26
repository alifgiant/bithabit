import 'package:bithabit/src/service/sorting_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../service/recap_service.dart';
import '../../utils/view/add_habit_button.dart';
import '../../utils/view/app_bar_title.dart';
import 'recap_option_button.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final habits = habitService.getHabits().sortByName();

    final recapService = context.watch<RecapService>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppBarTitle(text: '${recapService.currentView.title} Recap'),
        actions: const [
          SizedBox(width: 8),
          AddHabitButton(),
          SizedBox(width: 8),
          RecapOptionButton(),
          SizedBox(width: 8),
        ],
      ),
      body: habits.isNotEmpty
          ? ListView.separated(
              padding: EdgeInsets.all(
                recapService.currentView == RecapOption.byMonth ? 0 : 16,
              ).copyWith(bottom: kBottomNavigationBarHeight * 2),
              itemBuilder: (_, index) => recapService.createView(habits[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: habits.length,
            )
          : Center(
              child: InkWell(
                onTap: () => AddHabitButton.navToAddHabit(context),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_circle_rounded, size: 52),
                      SizedBox(height: 18),
                      Text("Let's start your first Habit!"),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
