import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_setup.dart';
import 'src/service/analytic_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().start();
  Analytic.get().logAppOpen();
  runApp(const MyApp());
}
