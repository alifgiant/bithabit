import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/view/title_view.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Habit? habit;
  const DetailPage({super.key, this.habit});

  bool get isNewHabit => habit == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: ListView(
        children: [
          TitleView(text: isNewHabit ? 'Create Habit' : 'Update Habit'),
        ],
      ),
    );
  }
}
