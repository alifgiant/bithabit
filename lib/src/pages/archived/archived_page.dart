import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/service/sorting_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/habit_service.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/simple_habit_view.dart';

class ArchivedPage extends StatelessWidget {
  const ArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;

    final habitService = context.watch<HabitService>();
    final habits = habitService.getHabits(state: HabitState.archieved).sortByName();

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Habit Archive'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: habits.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(screenPadding).copyWith(
                top: 21,
                bottom: kBottomNavigationBarHeight * 2,
              ),
              itemBuilder: (_, index) => SimpleHabitView(
                key: ValueKey(habits[index].id),
                habit: habits[index],
                isCheckable: false,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: screenPadding),
              itemCount: habits.length,
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(BoxIcons.bxs_badge_check, size: 52),
                    SizedBox(height: 18),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'You Rocks!\n', style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: 'Every habit are active'),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
