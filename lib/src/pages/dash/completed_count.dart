import 'package:flutter/material.dart';

class CompletedCount extends StatelessWidget {
  final int total;
  final int completed;

  const CompletedCount({
    super.key,
    required this.total,
    required this.completed,
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
          TextSpan(children: [
            const TextSpan(text: 'Today, ', style: TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(
              text: '$completed of $total completed',
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Container(
          width: width,
          height: 10.0,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              AnimatedContainer(
                width: width * fraction,
                height: 12,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
