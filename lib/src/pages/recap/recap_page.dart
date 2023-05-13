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
        elevation: 0,
        title: AppBarTitle(text: '${recapService.currentView.title} Recap'),
        actions: const [
          AddHabitButton(),
          RecapOptionButton(),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(
          recapService.currentView == RecapOption.byMonth ? 24 : 16,
        ).copyWith(
          bottom: kBottomNavigationBarHeight * 2,
        ),
        itemBuilder: (_, index) => recapService.createView(habits[index]),
        separatorBuilder: (_, __) => SizedBox(
          height: recapService.currentView == RecapOption.byMonth ? 24 : 16,
        ),
        itemCount: habits.length,
      ),
    );
  }
}
