import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database_service.dart';
import 'dump_stub.dart'
    if (dart.library.io) 'dump_io.dart'
    if (dart.library.js) 'dump_web.dart';

class ExporterService {
  final DatabaseService _dbService;

  const ExporterService(this._dbService);

  static ExporterService of(BuildContext context) {
    return context.read<ExporterService>();
  }

  Future<String?> dumpFile() async {
    final jsonString = jsonEncode(await _dbService.dump());
    final filename = 'export-${DateTime.now().millisecondsSinceEpoch}.json';
    return saveTextFile(jsonString, filename);
  }

  Future<ImportResult> importFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    // User canceled the picker
    if (result == null) return ImportResult.cancel;
    if (result.files.length > 1) return ImportResult.tooMuchFile;
    final file = result.files.first;
    if (file.extension != 'json') return ImportResult.wrongFileFormat;

    try {
      final encondedData = await readTextFile(file);
      if (encondedData == null) return ImportResult.fileCorrupt;

      final json = jsonDecode(encondedData);
      final isSuccess = await _dbService.import(json as Map<String, dynamic>);
      return isSuccess ? ImportResult.success : ImportResult.empty;
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(exception: e));
      return ImportResult.fileCorrupt;
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
