import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/recap_service.dart';

class RecapOptionButton extends StatelessWidget {
  const RecapOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final recapService = context.read<RecapService>();
    return PopupMenuButton(
      icon: const Icon(Icons.calendar_month_outlined),
      tooltip: 'Recap Option',
      itemBuilder: (context) => RecapOption.values
          .map(
            (e) => PopupMenuItem(
              child: Text(e.menuTitle),
              onTap: () => recapService.updateOption(e, 'RecapOptionButton'),
            ),
          )
          .toList(),
    );
  }
}
