import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'src/model/habit.dart';
import 'src/model/timeline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [HabitSchema, TimelineSchema],
    directory: dir.path,
  );
  runApp(MyApp(isar: isar));
}
