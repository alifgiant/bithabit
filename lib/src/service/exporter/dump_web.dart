import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;

import 'package:file_picker/file_picker.dart';

Future<String?> saveTextFile(String text, String filename) async {
  final href = Uri.dataFromString(
    text,
    mimeType: 'text/plain',
    encoding: utf8,
  );
  AnchorElement()
    ..href = '$href'
    ..download = filename
    ..style.display = 'none'
    ..click()
    ..remove();

  return 'Download/$filename';
}

Future<String?> readTextFile(PlatformFile platformFile) async {
  final byte = platformFile.bytes;
  return utf8.decode(byte!, allowMalformed: true);
}
