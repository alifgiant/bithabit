import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<String?> saveTextFile(String text, String filename) async {
  final selectedDirectory = await FilePicker.platform.getDirectoryPath();

  // User canceled the picker
  if (selectedDirectory == null) return null;

  // Write the file
  final file = File('$selectedDirectory/$filename');
  return (await file.writeAsString(text)).path;
}

Future<String?> readTextFile(PlatformFile platformFile) async {
  final file = File(platformFile.path!);

  // if file actually empty
  final isExist = file.existsSync();
  if (!isExist) return null;

  return file.readAsString();
}
