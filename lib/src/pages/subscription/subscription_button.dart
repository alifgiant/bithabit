import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/subs_service.dart';
import '../../utils/res/res_color.dart';

class SubscriptionButton extends StatelessWidget {
  final SubsKind kind;

  const SubscriptionButton({
    super.key,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final subsService = context.watch<SubsService>();
    final priceText = subsService.subsKind == kind ? 'Subscribed' : subsService.getPrice(kind);

    final double buttonLength = (priceText.length * 10) + 12;

    return InkWell(
      onTap: subsService.subsKind == kind ? null : () => subsService.subscribe(kind),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: subsService.subsKind == kind ? ResColor.darkGreen.withOpacity(0.9) : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        width: subsService.isLoading ? 50 : buttonLength,
        height: 42,
        child: Center(
          child: subsService.isLoading
              ? SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.background),
                  ),
                )
              : FittedBox(
                  child: Text(
                    priceText,
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                  ),
                ),
        ),
      ),
    );
  }
}
