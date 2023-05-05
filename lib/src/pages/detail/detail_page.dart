import 'package:bithabit/src/model/habit.dart';
import 'package:bithabit/src/utils/view/app_bar_title.dart';
import 'package:bithabit/src/utils/view/section_title.dart';
import 'package:flutter/material.dart';

import 'habit_color_picker.dart';

class DetailPage extends StatefulWidget {
  final Habit? habit;
  const DetailPage({super.key, this.habit});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool get isNewHabit => widget.habit == null;

  late HabitColor selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.habit?.color ?? HabitColor.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            AppBarTitle(text: isNewHabit ? 'Create Habit' : 'Update Habit'),
            const SizedBox(height: 21),
            const TextField(
              decoration: InputDecoration(
                filled: true,
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 30),
            const SectionTitle(text: 'Color'),
            const SizedBox(height: 12),
            HabitColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            const SizedBox(height: 30),
            SectionTitle(text: 'Repeat'),
            const SizedBox(height: 12),
            Text('data'),
            const SizedBox(height: 30),
            SectionTitle(text: 'On These Day'),
            const SizedBox(height: 12),
            Text('data'),
            const SizedBox(height: 30),
            SectionTitle(text: 'Reminder'),
            const SizedBox(height: 12),
            Text('data'),
            const SizedBox(height: 30),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}
