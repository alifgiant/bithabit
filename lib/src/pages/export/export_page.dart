import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../service/exporter_service.dart';
import '../../service/habit_service.dart';
import '../../service/timeline_service.dart';
import '../../utils/view/app_bar_title.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  final path = await ExporterService.of(context).dumpFile();
                  if (path == null) return;

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Habit Data Exported on $path'),
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
                  final habitService = context.read<HabitService>();
                  final timelineService = context.read<TimelineService>();

                  final result = await ExporterService.of(context).importFile();
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
    switch (result) {
      case ImportResult.success:
        scaffold.showSnackBar(
          const SnackBar(content: Text('Habit Successfully Imported')),
        );

        habitService.loadHabit();
        timelineService.loadTimeline();
        break;
      case ImportResult.fileCorrupt:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('Data File is Corrupt'),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      case ImportResult.tooMuchFile:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text('Please only select one file'),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      case ImportResult.wrongFileFormat:
        scaffold.showSnackBar(
          SnackBar(
            content: const Text("You're selecting wrong backup file"),
            backgroundColor: colorScheme.error,
          ),
        );
        break;
      case ImportResult.cancel:
        // do nothing
        break;
    }
  }
}
