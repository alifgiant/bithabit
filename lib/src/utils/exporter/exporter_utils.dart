import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../model/habit.dart';

class ExporterUtils {
  Future<File?> dumpFile(BundleData data) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();

    // User canceled the picker
    if (selectedDirectory == null) return null;

    // TODO: handle web file
    final file = File('$selectedDirectory/export-${DateTime.now().millisecondsSinceEpoch}.json');

    final time = data.timelines.map(
      (key, value) => MapEntry(
        key.toString(),
        value.map((time) => time.millisecondsSinceEpoch).toList(),
      ),
    );

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

  Future<ImportResult> importFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
    );

    // User canceled the picker
    if (result == null) return ErrorImportResult(ErrorType.cancel);
    if (result.files.length > 1) return ErrorImportResult(ErrorType.tooMuchFile);
    if (result.files.first.extension != 'json') return ErrorImportResult(ErrorType.wrongFileFormat);

    if (kIsWeb) {
      // TODO: handle web pick file
      return ErrorImportResult(ErrorType.cancel);
    } else {
      final file = File(result.files.first.path!);

      // if file actually empty
      final isExist = file.existsSync();
      if (!isExist) return ErrorImportResult(ErrorType.fileCorrupt);

      final encondedData = await file.readAsString();
      try {
        final json = jsonDecode(encondedData);
        final rawJsonHabit = json['habits'] as List<dynamic>?;
        final habits = rawJsonHabit?.cast<Map<String, dynamic>>().map(
                  Habit.fromJson,
                ) ??
            [];
        final timelines = <int, Set<DateTime>>{};
        final rawJsonTimeline = json['timeline'] as Map<String, dynamic>;
        for (final element in rawJsonTimeline.entries) {
          timelines[int.parse(element.key)] = (element.value as List<dynamic>)
              .cast<int>()
              .map(
                DateTime.fromMillisecondsSinceEpoch,
              )
              .toSet();
        }

        return SuccessImportResult(BundleData(habits, timelines));
      } catch (e) {
        return ErrorImportResult(ErrorType.fileCorrupt);
      }
    }
  }
}

class BundleData {
  final Iterable<Habit> habits;
  final Map<int, Set<DateTime>> timelines;

  BundleData(this.habits, this.timelines);
}

abstract class ImportResult {}

class ErrorImportResult extends ImportResult {
  final ErrorType type;

  ErrorImportResult(this.type);
}

enum ErrorType { cancel, tooMuchFile, wrongFileFormat, fileCorrupt }

class SuccessImportResult extends ImportResult {
  final BundleData data;

  SuccessImportResult(this.data);
}
