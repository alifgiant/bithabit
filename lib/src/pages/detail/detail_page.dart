import 'package:flutter/material.dart';

import '../../model/habit.dart';
import '../../service/habit_service.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/section_title.dart';
import 'habit_color_picker.dart';

class DetailPage extends StatefulWidget {
  final Habit? habit;
  final HabitService habitService;

  const DetailPage({
    super.key,
    this.habit,
    required this.habitService,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool get isNewHabit => widget.habit == null;

  bool isTitleEmpty = false;
  late Habit edittedHabit;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    edittedHabit = widget.habit?.copy() ?? Habit('', '', HabitColor.values.first);
    controller = TextEditingController(text: edittedHabit.name);
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
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Title',
                errorText: isTitleEmpty ? 'Please fill the title' : null,
              ),
              onChanged: (value) {
                setState(() {
                  isTitleEmpty = false;
                  edittedHabit = edittedHabit.copy(name: value);
                });
              },
            ),
            const SizedBox(height: 30),
            const SectionTitle(text: 'Color'),
            const SizedBox(height: 12),
            HabitColorPicker(
              selectedColor: edittedHabit.color,
              onColorSelected: (color) {
                setState(() {
                  edittedHabit = edittedHabit.copy(color: color);
                });
              },
            ),
            const SizedBox(height: 30),
            const SectionTitle(text: 'Repeat'),
            const SizedBox(height: 12),
            const Text('data'),
            const SizedBox(height: 30),
            const SectionTitle(text: 'On These Day'),
            const SizedBox(height: 12),
            const Text('data'),
            const SizedBox(height: 30),
            const SectionTitle(text: 'Reminder'),
            const SizedBox(height: 12),
            const Text('data'),
            const SizedBox(height: 30),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: onSaveClick,
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

  void onSaveClick() async {
    if (edittedHabit.name.isEmpty) {
      setState(() {
        isTitleEmpty = true;
      });
      return;
    }

    await widget.habitService.saveHabit(edittedHabit);

    if (!mounted) return;
    Navigator.of(context).pop(edittedHabit);
  }
}
