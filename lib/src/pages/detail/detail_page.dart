import 'package:bithabit/src/pages/detail/habit_frequency_picker.dart';
import 'package:bithabit/src/utils/res/res_color.dart';
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
  late Habit edittedHabit;
  bool get isNewHabit => widget.habit == null;

  bool isTitleEmpty = false;
  late TextEditingController titleCtlr;

  bool isFrequencyEmpty = false;

  @override
  void initState() {
    super.initState();
    edittedHabit = widget.habit?.copy() ?? Habit('', '', HabitColor.values.first);
    titleCtlr = TextEditingController(text: edittedHabit.name);
  }

  @override
  void dispose() {
    titleCtlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(elevation: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: screenPadding).copyWith(
          bottom: kBottomNavigationBarHeight + screenPadding,
        ),
        children: [
          AppBarTitle(text: isNewHabit ? 'Create Habit' : 'Update Habit'),
          const SizedBox(height: 21),
          TextField(
            controller: titleCtlr,
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
          const SizedBox(height: 10),
          HabitColorPicker(
            screenPadding: 16,
            selectedColor: edittedHabit.color,
            onColorSelected: (color) {
              setState(() {
                edittedHabit = edittedHabit.copy(color: color);
              });
            },
          ),
          const SizedBox(height: 30),
          const SectionTitle(text: 'Repeat'),
          const SizedBox(height: 10),
          HabitFrequencyPicker(
            selectedFrequency: edittedHabit.frequency,
            onFrequencySelected: (frequency) {
              setState(() {
                edittedHabit = edittedHabit.copy(frequency: frequency);
              });
            },
          ),
          const SizedBox(height: 30),
          SectionTitle(text: frequencyValueDetail(edittedHabit.frequency.runtimeType)),
          const SizedBox(height: 10),
          HabitFrequencyValuePicker(
            selectedFrequency: edittedHabit.frequency,
            screenPadding: screenPadding,
            onFrequencySelected: (frequency) {
              setState(() {
                edittedHabit = edittedHabit.copy(frequency: frequency);
              });
            },
          ),
          const SizedBox(height: 30),
          const SectionTitle(text: 'Reminder'),
          const SizedBox(height: 10),
          const Text('data'),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12).copyWith(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
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
    );
  }

  String frequencyValueDetail(Type selectionType) {
    switch (selectionType) {
      case DailyFrequency:
        return 'On These Day';
      case MonthlyFrequency:
        return 'On These Date';
      default:
        return 'On These Day';
    }
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
