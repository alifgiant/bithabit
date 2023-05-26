import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String subtitle;
  final Widget? suffix;
  final double topPadding;
  final double bottomPadding;

  const SectionTitle({
    required this.text,
    this.subtitle = '',
    this.suffix,
    this.topPadding = 30,
    this.bottomPadding = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
              ],
            ),
            if (suffix != null) suffix!,
          ],
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }
}
