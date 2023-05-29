import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/database_service.dart';

class ExporterService {
  final DatabaseService _dbService;

  const ExporterService(this._dbService);

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
    final jsonString = jsonEncode(await _dbService.dump());

    return (await file.writeAsString(jsonString)).path;
  }

  Future<ImportResult> importFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    // User canceled the picker
    if (result == null) return ImportResult.cancel;
    if (result.files.length > 1) return ImportResult.tooMuchFile;
    if (result.files.first.extension != 'json') return ImportResult.wrongFileFormat;

    if (kIsWeb) {
      try {
        final byte = result.files.first.bytes;
        final encondedData = utf8.decode(byte!, allowMalformed: true);
        final json = jsonDecode(encondedData);
        final isSuccess = await _dbService.import(json as Map<String, dynamic>);
        return isSuccess ? ImportResult.success : ImportResult.empty;
      } catch (e) {
        return ImportResult.fileCorrupt;
      }
    } else {
      final file = File(result.files.first.path!);

      // if file actually empty
      final isExist = file.existsSync();
      if (!isExist) return ImportResult.fileCorrupt;

      final encondedData = await file.readAsString();
      try {
        final json = jsonDecode(encondedData);
        final isSuccess = await _dbService.import(json as Map<String, dynamic>);
        return isSuccess ? ImportResult.success : ImportResult.empty;
      } catch (e) {
        return ImportResult.fileCorrupt;
      }
    }
  }
}

enum ImportResult {
  cancel,
  tooMuchFile,
  wrongFileFormat,
  fileCorrupt,
  empty,
  success,
}
