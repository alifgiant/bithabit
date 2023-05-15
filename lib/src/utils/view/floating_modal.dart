import 'package:flutter/material.dart';

/// original source
/// https://github.com/jamesblasco/modal_bottom_sheet/blob/main/modal_bottom_sheet/example/lib/modals/floating_modal.dart
class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({
    Key? key,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      child: SafeArea(child: child),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) async {
  final result = await showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (context) => FloatingModal(child: builder(context)),
  );

  return result;
}
