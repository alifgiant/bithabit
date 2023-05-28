import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import '../model/habit.dart';
import '../model/timeline.dart';

class ExporterService {
  final Isar isar;

  const ExporterService(this.isar);

  static ExporterService of(BuildContext context) {
    return context.read<ExporterService>();
  }

  Future<String?> dumpFile() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();

    // User canceled the picker
    if (selectedDirectory == null) return null;

    final path = '$selectedDirectory/export-${DateTime.now().millisecondsSinceEpoch}.json';

    // TODO: handle web file
    final file = File(path);

    // Write the file
    final jsonString = jsonEncode({
      'habits': await isar.habits.where().exportJson(),
      'timeline': await isar.timelines.where().exportJson(),
    });

    return (await file.writeAsString(jsonString)).path;
  }

  Future<ImportResult> importFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
    );

    // User canceled the picker
    if (result == null) return ImportResult.cancel;
    if (result.files.length > 1) return ImportResult.tooMuchFile;
    if (result.files.first.extension != 'json') return ImportResult.wrongFileFormat;

    if (kIsWeb) {
      // TODO: handle web pick file
      return ImportResult.cancel;
    } else {
      final file = File(result.files.first.path!);

      // if file actually empty
      final isExist = file.existsSync();
      if (!isExist) return ImportResult.fileCorrupt;

      final encondedData = await file.readAsString();
      try {
        final json = jsonDecode(encondedData);
        final rawJsonHabit = json['habits'] as List;
        final rawJsonTimeline = json['timeline'] as List;
        final jsonHabit = rawJsonHabit.cast<Map<String, dynamic>>();
        final jsonTimeline = rawJsonTimeline.cast<Map<String, dynamic>>();

        await isar.writeTxn(() async {
          await isar.habits.importJson(jsonHabit);
          await isar.timelines.importJson(jsonTimeline);
        });

        return ImportResult.success;
      } catch (e) {
        return ImportResult.fileCorrupt;
      }
    }
  }
}

enum ImportResult { cancel, tooMuchFile, wrongFileFormat, fileCorrupt, success }
