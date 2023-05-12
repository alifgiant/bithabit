import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/sorting_service.dart';

class SortHabitButton extends StatelessWidget {
  const SortHabitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final sortingService = context.read<SortingService>();
    return PopupMenuButton(
      icon: const Icon(Icons.sort_rounded),
      tooltip: 'Sort Habit',
      itemBuilder: (context) => SortingOption.values
          .map(
            (e) => PopupMenuItem(
              child: Text(e.title),
              onTap: () => sortingService.updateOption(e),
            ),
          )
          .toList(),
    );
  }
}
