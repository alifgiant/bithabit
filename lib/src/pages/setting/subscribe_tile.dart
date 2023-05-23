import 'package:bithabit/src/pages/setting/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/subs_service.dart';
import '../../utils/const/app_route.dart';
import '../../utils/res/res_color.dart';

class SubscribeTile extends StatelessWidget {
  const SubscribeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final subsService = context.watch<SubsService>();
    if (subsService.isPremiumUser) {
      return SettingTile(
        title: 'BitHabit Pro',
        icon: BoxIcons.bx_extension,
        onTap: () => Navigator.of(context).pushNamed(AppRoute.premium),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => Navigator.of(context).pushNamed(AppRoute.premium),
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
          'Export/Import Data, Unlimited tracked day, Charts, Restore Archived',
        ),
      ),
    );
  }
}
