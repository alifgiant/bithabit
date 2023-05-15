import 'package:flutter/material.dart';

import '../res/res_color.dart';

mixin ViewUtils {
  static Future<T?> showFloatingModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(child: builder(context)),
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
    super.key,
    this.confirmText,
    this.declineText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(21.0),
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
                    backgroundColor: ResColor.red.withOpacity(0.9),
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

  static Future<ConfirmationResult?> show<T>(
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
