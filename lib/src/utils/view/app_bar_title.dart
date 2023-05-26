import 'package:flutter/material.dart';

import '../res/res_color.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({
    this.text = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final splitted = text.split(' ');

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 24,
          color: ResColor.black,
        ),
        children: text.isNotEmpty
            ? splitted
                .map(
                  (e) => TextSpan(
                    text: '$e ',
                    style: e == splitted.last ? const TextStyle(fontWeight: FontWeight.w700) : null,
                  ),
                )
                .toList()
            : const [
                TextSpan(text: 'Bit'),
                TextSpan(
                  text: 'Habit',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
      ),
    );
  }
}
