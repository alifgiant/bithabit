import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../model/habit.dart';
import '../../service/timeline_service.dart';

class TodayHabit extends StatelessWidget {
  final Habit habit;
  late final DateTime today;

  TodayHabit({
    super.key,
    required this.habit,
  }) {
    today = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timelineService = context.watch<TimelineService>();
    final isChecked = timelineService.isHabitChecked(habit, today);

    return Material(
      color: habit.color.mainColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed(
          '/detail',
          arguments: habit,
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: habit.color.textColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit.name.titleCase,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    _CheckCircle(
                      habitColor: habit.color,
                      isChecked: isChecked,
                      onTap: () => timelineService.check(habit, today),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  final HabitColor habitColor;
  final bool isChecked;
  final VoidCallback onTap;

  const _CheckCircle({
    required this.habitColor,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(
        side: BorderSide(
          color: habitColor.mainColor,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      color: isChecked ? habitColor.mainColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox.square(
          dimension: 28,
          child: isChecked
              ? Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: habitColor.textColor,
                )
              : null,
        ),
      ),
    );
  }
}