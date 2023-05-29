import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_setup.dart';
import 'src/service/analytic_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().start();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    ),
  );
}
