import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final String subtitle;
  final Widget? suffix;

  const SectionTitle({
    super.key,
    required this.text,
    this.subtitle = '',
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}
