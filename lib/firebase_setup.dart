import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

class FirebaseSetup {
  Future<void> start() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // TODO: enable remote config
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setConfigSettings(
    //   RemoteConfigSettings(
    //     fetchTimeout: const Duration(minutes: 5),
    //     minimumFetchInterval: const Duration(days: 1),
    //   ),
    // );
    // Future(remoteConfig.fetchAndActivate);

    /// crashlytic not supported on WEB Platform
    if (kIsWeb) return;

    /// only send crash log on release version
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

    /// Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    /// Pass all uncaught asynchronous errors
    /// that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
