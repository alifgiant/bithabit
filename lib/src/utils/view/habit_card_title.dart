import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class HabitCardTitle extends StatelessWidget {
  final String title;
  final String date;

  const HabitCardTitle({
    required this.title,
    this.date = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.titleCase,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        if (date.isNotEmpty)
          Text(
            date,
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }
}
