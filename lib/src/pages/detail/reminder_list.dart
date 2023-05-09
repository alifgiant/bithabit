import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../model/habit.dart';
import '../../utils/res/res_color.dart';

class ReminderList extends StatelessWidget {
  final List<HabitReminder> reminder;
  final void Function(HabitReminder prev, HabitReminder item) onUpdate;
  final void Function(HabitReminder item) onRemove;

  const ReminderList({
    super.key,
    required this.reminder,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (reminder.isEmpty) return const Text('No Reminder Set');

    return Column(
      children: reminder.map((item) {
        return Dismissible(
          key: ValueKey(item.time),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) => onRemove(item),
          background: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 4),
              Icon(BoxIcons.bx_trash, size: 21, color: ResColor.red),
              SizedBox(width: 4),
              Text('Remove', style: TextStyle(color: ResColor.red)),
            ],
          ),
          child: SwitchListTile(
            value: item.enabled,
            dense: true,
            contentPadding: EdgeInsets.zero,
            onChanged: (enabled) => onUpdate(item, item.copyWith(enabled: enabled)),
            title: Text(item.time.format(context)),
          ),
        );
      }).toList(),
    );
  }
}
