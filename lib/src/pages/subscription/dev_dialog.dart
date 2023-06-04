import 'package:flutter/material.dart';

import '../../service/navigation_service.dart';

class DevDialog extends StatelessWidget {
  const DevDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String pass = '';
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temp Access',
              style: TextStyle(fontSize: 21),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              onChanged: (value) => pass = value,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => NavigationService.of(context).maybePop(pass),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('OK'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
