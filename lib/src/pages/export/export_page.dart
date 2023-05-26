import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../model/habit_state.dart';
import '../../service/habit_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/exporter/exporter_utils.dart';
import '../../utils/view/app_bar_title.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final habitService = context.watch<HabitService>();
    final enabledHabits = habitService.getHabits();
    final disabledHabits = habitService.getHabits(state: HabitState.archieved);

    final timelineService = context.watch<TimelineService>();

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Export/Import Data'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final file = await ExporterUtils().dumpFile(
                    BundleData(
                      [...enabledHabits, ...disabledHabits],
                      timelineService.timelineMap,
                    ),
                  );
                  if (file == null) return;

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Habit Data Exported on ${file.path}'),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(BoxIcons.bxs_arrow_from_bottom, size: 42),
                    SizedBox(width: 32),
                    Text('Export', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final colorScheme = Theme.of(context).colorScheme;
                  final result = await ExporterUtils().importFile();
                  handleImportResult(
                    scaffoldMessenger,
                    colorScheme,
                    result,
                    habitService,
                    timelineService,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(BoxIcons.bxs_arrow_from_top, size: 42),
                    SizedBox(width: 32),
                    Text('Import', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void handleImportResult(
    ScaffoldMessengerState scaffold,
    ColorScheme colorScheme,
    ImportResult result,
    HabitService habitService,
    TimelineService timelineService,
  ) {
    if (result is ErrorImportResult) {
      return handleErrorResult(scaffold, colorScheme, result, habitService, timelineService);
    } else if (result is SuccessImportResult) {
      return handleSuccessResult(scaffold, colorScheme, result, habitService, timelineService);
    }
  }

  void handleErrorResult(
    ScaffoldMessengerState scaffold,
    ColorScheme colorScheme,
    ErrorImportResult result,
    HabitService habitService,
    TimelineService timelineService,
  ) {
    switch (result.type) {
      case ErrorType.fileCorrupt:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('Data File is Corrupt'),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      case ErrorType.tooMuchFile:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('Please only select one file'),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      case ErrorType.wrongFileFormat:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text("You're selecting wrong backup file"),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      default:
      // case ErrorType.cancel:
    }
  }

  void handleSuccessResult(
    ScaffoldMessengerState scaffold,
    ColorScheme colorScheme,
    SuccessImportResult result,
    HabitService habitService,
    TimelineService timelineService,
  ) {
    final data = result.data;
    if (data.habits.isEmpty) {
      scaffold.showSnackBar(
        const SnackBar(content: Text('Data File is Empty')),
      );
    }

    for (final habit in data.habits) {
      habitService.saveHabit(habit);

      final timeline = data.timelines[habit.id];
      if (timeline == null) continue;

      for (final time in timeline) {
        timelineService.check(habit, time, setAction: false);
      }
    }

    scaffold.showSnackBar(
      const SnackBar(content: Text('Habit Successfully Imported')),
    );
  }
}
