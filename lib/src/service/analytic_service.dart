import 'package:firebase_analytics/firebase_analytics.dart';

import '../model/habit.dart';
import '../model/timeline.dart';

class Analytic {
  Analytic._();

  static final Analytic _i = Analytic._();
  static Analytic get() => _i;

  FirebaseAnalytics get _firebase => FirebaseAnalytics.instance;

  void logAppOpen() => _firebase.logAppOpen();

  void logOpenHabit(Habit habit) => _firebase.logEvent(
        name: 'habit_open',
        parameters: habit.toMap(),
      );

  void logCheckTimeline(
    Timeline timeline, {
    bool isCheck = true,
  }) {
    _firebase.logEvent(
      name: 'timeline_update',
      parameters: {
        ...timeline.toMap(),
        'isCheck': isCheck,
      },
    );
  }

  void logScreenView({
    String? screenClass,
    String? screenName,
  }) {
    _firebase.logScreenView(
      screenClass: screenClass,
      screenName: screenName,
    );
  }
}
