import 'package:bithabit/src/model/habit.dart';
import 'package:flutter/material.dart';

import '../../utils/view/app_bar_title.dart';

class ChartPage extends StatelessWidget {
  final Habit habit;

  const ChartPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Visual Progress'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.amber,
    );
  }
}
