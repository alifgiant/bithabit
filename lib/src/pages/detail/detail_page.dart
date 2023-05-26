import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../model/habit.dart';
import '../../model/habit_color.dart';
import '../../model/habit_frequency.dart';
import '../../model/habit_reminder.dart';
import '../../service/habit_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/const/app_route.dart';
import '../../utils/view/app_bar_title.dart';
import '../../utils/view/section_title.dart';
import '../../utils/view/view_utils.dart';
import 'habit_color_picker.dart';
import 'habit_frequency_picker.dart';
import 'reminder_list.dart';

class DetailPage extends StatefulWidget {
  final Habit? habit;
  final HabitService habitService;
  final TimelineService timelineService;

  const DetailPage({
    required this.habitService,
    required this.timelineService,
    this.habit,
    super.key,
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
    edittedHabit = widget.habit?.copy() ??
        Habit(
          '',
          '',
          HabitColor.values.first,
          reminder: List.empty(growable: true),
        );
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            centerTitle: false,
            actions: [
              if (!isNewHabit) ...[
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Charts',
                  onPressed: onChartClick,
                  icon: const Icon(Icons.bar_chart_rounded),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: edittedHabit.isEnabled ? 'Archive' : 'Delete',
                  onPressed: onDeleteClick,
                  icon: Icon(
                    BoxIcons.bx_trash,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
              ]
            ],
            title: AppBarTitle(text: screenTitle),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: screenPadding).copyWith(
              bottom: kBottomNavigationBarHeight * 2,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TextField(
                    enabled: edittedHabit.isEnabled,
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
                  const SectionTitle(text: 'Color'),
                  HabitColorPicker(
                    enabled: edittedHabit.isEnabled,
                    selectedColor: edittedHabit.color,
                    onColorSelected: (color) {
                      setState(() {
                        edittedHabit = edittedHabit.copy(color: color);
                      });
                    },
                  ),
                  const SectionTitle(text: 'Repeat'),
                  HabitFrequencyPicker(
                    enabled: edittedHabit.isEnabled,
                    selectedFrequency: edittedHabit.frequency,
                    onFrequencySelected: (frequency) {
                      setState(() {
                        edittedHabit = edittedHabit.copy(frequency: frequency);
                      });
                    },
                  ),
                  SectionTitle(text: frequencyValueDetail(edittedHabit.frequency.runtimeType)),
                  HabitFrequencyValuePicker(
                    enabled: edittedHabit.isEnabled,
                    selectedFrequency: edittedHabit.frequency,
                    onFrequencySelected: (frequency) {
                      setState(() {
                        edittedHabit = edittedHabit.copy(frequency: frequency);
                      });
                    },
                  ),
                  SectionTitle(
                    text: 'Reminder',
                    subtitle: edittedHabit.reminder.isNotEmpty ? 'Swipe right to remove' : '',
                    suffix: InkWell(
                      onTap: edittedHabit.isEnabled ? addReminderClick : () => ViewUtils.showHabitArchieved(context),
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
                  ReminderList(
                    enabled: edittedHabit.isEnabled,
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
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12).copyWith(
          bottom: paddingBottom > 0 ? paddingBottom : 12,
        ),
        child: ElevatedButton(
          onPressed: edittedHabit.isEnabled ? onSaveClick : onRestoreClick,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.background,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: edittedHabit.isEnabled ? const Text('Save') : const Text('Restore'),
          ),
        ),
      ),
    );
  }

  String get screenTitle {
    if (edittedHabit.isArchived) return 'Archived Habit';
    return isNewHabit ? 'Create Habit' : 'Update Habit';
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

  Future<void> addReminderClick() async {
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
  }

  void onChartClick() {
    Navigator.of(context).pushNamed(AppRoute.charts, arguments: edittedHabit);
  }

  Future<void> onDeleteClick() async {
    final result = await ConfirmingDialog.show(
      context,
      edittedHabit.isEnabled ? 'Archive this habit?' : 'Permanent delete?',
      edittedHabit.isEnabled ? "Don't worry, you can bring it back on setting page." : "You won't be able to restore this habit anymore",
    );
    if (result == null || result == ConfirmationResult.no) return;
    if (!mounted) return;

    widget.timelineService.resetLastAction();
    widget.habitService.deleteHabit(
      edittedHabit.id,
      permanent: edittedHabit.isEnabled ? false : true,
    );

    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Future<void> onSaveClick() async {
    if (edittedHabit.name.isEmpty) {
      setState(() {
        isTitleEmpty = true;
      });
      return;
    }

    widget.timelineService.resetLastAction();
    await widget.habitService.saveHabit(edittedHabit);

    if (!mounted) return;
    Navigator.of(context).pop(edittedHabit);
  }

  Future<void> onRestoreClick() async {
    // TODO: check subscription

    widget.timelineService.resetLastAction();
    widget.habitService.restoreHabit(edittedHabit.id);

    if (!mounted) return;
    Navigator.of(context).maybePop();
  }
}
