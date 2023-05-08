import 'package:flutter/material.dart';

class CompletedCount extends StatelessWidget {
  final int completed;
  final int total;

  const CompletedCount({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'Today, ', style: TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(
              text: '$completed of $total is completed',
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 6 / 10,
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
              FractionallySizedBox(
                widthFactor: total > 0 ? completed / total : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
