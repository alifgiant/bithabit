import 'package:bithabit/src/service/timeline_service.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../model/habit.dart';
import '../../service/habit_service.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/section_title.dart';
import 'habit_color_picker.dart';
import 'habit_frequency_picker.dart';
import 'reminder_list.dart';

class DetailPage extends StatefulWidget {
  final Habit? habit;
  final HabitService habitService;
  final TimelineService timelineService;

  const DetailPage({
    super.key,
    this.habit,
    required this.habitService,
    required this.timelineService,
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
    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(slivers: [
        SliverAppBar.medium(
          pinned: true,
          title: AppBarTitle(text: isNewHabit ? 'Create Habit' : 'Update Habit'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: screenPadding).copyWith(
            bottom: kBottomNavigationBarHeight + screenPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                TextField(
                  controller: titleCtlr,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Habit Name',
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
                SectionTitle(
                  text: 'Reminder',
                  subtitle: edittedHabit.reminder.isNotEmpty ? 'Swipe right to remove' : '',
                  suffix: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (!mounted || time == null) return;

                      final timeExist = edittedHabit.reminder.any((element) => element.time.compareTo(time) == 0);

                      if (timeExist) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You already added that time')),
                        );
                        return;
                      }

                      edittedHabit.reminder.add(HabitReminder(time, enabled: true));
                      edittedHabit.reminder.sort((a, b) => a.time.compareTo(b.time));
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox.square(
                      dimension: 28,
                      child: Icon(
                        BoxIcons.bx_alarm_add,
                        color: Theme.of(context).buttonTheme.colorScheme!.primary,
                        size: 21,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ReminderList(
                  reminder: edittedHabit.reminder,
                  onUpdate: (prev, item) => setState(() {
                    final index = edittedHabit.reminder.indexOf(prev);
                    edittedHabit.reminder.remove(prev);
                    edittedHabit.reminder.insert(index, item);
                  }),
                  onRemove: (item) => setState(() {
                    edittedHabit.reminder.remove(item);
                  }),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        )
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12).copyWith(
          bottom: paddingBottom > 0 ? paddingBottom : 12,
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
    widget.timelineService.lastActionIsCheck = false;

    if (!mounted) return;
    Navigator.of(context).pop(edittedHabit);
  }
}
