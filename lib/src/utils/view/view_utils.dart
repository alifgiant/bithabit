import 'package:flutter/material.dart';

mixin ViewUtils {
  static Future<T?> showOptionListBottomSheet<T>({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  static void showHabitArchieved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restore this habit to edit')),
    );
  }
}

class ConfirmingDialog extends StatelessWidget {
  final String title;
  final String desc;
  final String? confirmText;
  final String? declineText;

  const ConfirmingDialog(
    this.title,
    this.desc, {
    this.confirmText,
    this.declineText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 21),
            ),
            const SizedBox(height: 16),
            Text(desc),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.maybePop(context, ConfirmationResult.no),
                  child: Text(declineText ?? 'No'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.maybePop(context, ConfirmationResult.yes),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(confirmText ?? 'Okay'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Future<ConfirmationResult?> show(
    BuildContext context,
    String title,
    String desc, {
    String? confirmText,
    String? declineText,
  }) {
    return showDialog<ConfirmationResult>(
      context: context,
      builder: (context) {
        return ConfirmingDialog(
          title,
          desc,
          confirmText: confirmText,
          declineText: declineText,
        );
      },
    );
  }
}

enum ConfirmationResult { yes, no }
