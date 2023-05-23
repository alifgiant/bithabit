import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../model/habit.dart';

class ExporterUtils {
  Future<File?> dumpFile(ImportExportData data) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) return null;
    // final directory = await getApplicationDocumentsDirectory();

    // TODO: handle web file
    final file = File('$selectedDirectory/export-${DateTime.now().millisecondsSinceEpoch}.json');

    // Write the file
    final jsonString = jsonEncode({
      'habits': data.habits.map((e) => e.toMap()).toList(),
      'timeline': data.timelines.map(
        (key, value) => MapEntry(
          key,
          value.map((time) => time.millisecondsSinceEpoch).toList(),
        ),
      )
    });

    return file.writeAsString(jsonString);
  }

  Future<ImportExportData?> importFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && !kIsWeb) {
      // result.files.first.
      // print('path: ${result.files.single.path}');
      final file = File(result.files.single.path!);
      // final isExist = file.existsSync();
      // print('isExist : $isExist');
      final encondedData = await file.readAsString();

      final json = jsonDecode(encondedData);
      final habits = (json['habits'] as List?)?.map((e) => Habit.fromJson(e)) ?? [];
      Map<String, Set<DateTime>> timelines = {};
      for (final element in (json['timeline'] as Map).entries) {
        timelines[element.key] = (element.value as List)
            .cast<int>()
            .map(
              (e) => DateTime.fromMillisecondsSinceEpoch(e),
            )
            .toSet();
      }

      return ImportExportData(habits, timelines);
    } else if (kIsWeb) {
      // TODO: handle web pick file
      return null;
    } else {
      // User canceled the picker or
      return null;
    }
  }
}

class ImportExportData {
  final Iterable<Habit> habits;
  final Map<String, Set<DateTime>> timelines;

  ImportExportData(this.habits, this.timelines);
}
