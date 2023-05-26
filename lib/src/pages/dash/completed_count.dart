import 'package:flutter/material.dart';

class CompletedCount extends StatelessWidget {
  final int total;
  final int completed;

  const CompletedCount({
    required this.total,
    required this.completed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width * 5.5 / 10;
    final fraction = total > 0 ? completed / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: mediaQuery.viewPadding.top),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Today, ', style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(
                text: '$completed of $total completed',
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: width,
          height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                width: width * fraction,
                height: 12,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
