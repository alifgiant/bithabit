import 'package:bithabit/src/utils/res/res_color.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String text;

  const AppBarTitle({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    final splitted = text.split(' ');

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: ResColor.black, fontSize: 24),
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
                TextSpan(
                  text: 'Bit',
                ),
                TextSpan(
                  text: 'Habit',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
      ),
    );
  }
}
