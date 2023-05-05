import 'package:bithabit/src/utils/view/title_view.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: ListView(
        children: [
          TitleView(text: 'Create Habit'),
        ],
      ),
    );
  }
}
