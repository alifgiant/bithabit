import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../model/habit.dart';
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final file = await ExporterUtils().dumpFile(ImportExportData(
                    [...enabledHabits, ...disabledHabits],
                    timelineService.timelineMap,
                  ));
                  if (file == null) return;

                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text('Habit Data Exported on ${file.path}'),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  final data = await ExporterUtils().importFile();
                  if (data == null) return;

                  bool habbitAdded = false;
                  for (final habit in data.habits) {
                    habitService.saveHabit(habit);

                    final timeline = data.timelines[habit.id];
                    if (timeline == null) continue;
                    for (final time in timeline) {
                      timelineService.check(habit, time, setAction: false);
                    }

                    habbitAdded = true;
                  }

                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text(habbitAdded ? 'Habit Successfully Imported' : 'Data File is Empty'),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
}
