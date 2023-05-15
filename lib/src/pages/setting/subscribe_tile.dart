import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/res/res_color.dart';

class SubscribeTile extends StatelessWidget {
  const SubscribeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: ListTile(
        tileColor: ResColor.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {},
        leading: const Icon(
          BoxIcons.bxs_extension,
          size: 32,
          color: ResColor.grey,
        ),
        isThreeLine: true,
        horizontalTitleGap: 12,
        title: const Text.rich(
          TextSpan(
            style: TextStyle(
              color: ResColor.grey,
              fontSize: 16,
            ),
            children: [
              TextSpan(text: 'Subscribe to '),
              TextSpan(text: 'Bit'),
              TextSpan(
                text: 'Habit',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: ' Pro'),
            ],
          ),
        ),
        subtitle: const Text(
          style: TextStyle(color: ResColor.grey, fontSize: 12),
          'Export/Import Data, Unlimited saved day, Charts, Restore Archived',
        ),
      ),
    );
  }
}
