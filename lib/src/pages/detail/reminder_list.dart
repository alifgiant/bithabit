import 'package:bithabit/src/utils/text/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../model/habit_reminder.dart';
import '../../utils/res/res_color.dart';

class ReminderList extends StatelessWidget {
  final List<HabitReminder> reminder;
  final void Function(HabitReminder prev, HabitReminder item) onUpdate;
  final void Function(HabitReminder item) onRemove;
  final bool enabled;

  const ReminderList({
    required this.reminder,
    required this.onUpdate,
    required this.onRemove,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (reminder.isEmpty) return const Text('No Reminder Set');

    return Column(
      children: reminder.map((item) {
        final tile = SwitchListTile(
          value: item.enabled,
          dense: true,
          contentPadding: EdgeInsets.zero,
          onChanged: enabled ? (state) => onUpdate(item, item.copyWith(enabled: state)) : null,
          title: Text('${item.hour.to2Digit()}:${item.minute.to2Digit()}'),
        );
        if (!enabled) return tile;
        return Dismissible(
          key: ValueKey('${item.hour}:${item.minute}'),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) => onRemove(item),
          background: Row(
            children: const [
              SizedBox(width: 4),
              Icon(BoxIcons.bx_trash, size: 21, color: ResColor.red),
              SizedBox(width: 4),
              Text('Remove', style: TextStyle(color: ResColor.red)),
            ],
          ),
          child: tile,
        );
      }).toList(),
    );
  }
}
