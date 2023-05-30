import 'package:firebase_analytics/firebase_analytics.dart';

import '../model/habit.dart';
import '../model/timeline.dart';
import 'recap_service.dart';
import 'sorting_service.dart';

class Analytic {
  Analytic._();

  static final Analytic _i = Analytic._();
  static Analytic get() => _i;

  FirebaseAnalytics get _firebase => FirebaseAnalytics.instance;

  void logAppOpen() => _firebase.logAppOpen();

  void logHabitAction(
    Habit habit,
    HabitAction action, {
    Map<String, Object?>? parameters,
  }) {
    _firebase.logEvent(
      name: 'habit_${action.key}',
      parameters: {
        ...habit.toMap(),
        ...?parameters,
      },
    );
  }

  void logCheckTimeline(
    Timeline timeline, {
    required bool isCheck,
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

  void logTabChange(
    int index,
    Type pageType,
  ) {
    _firebase.logEvent(
      name: 'tab_change',
      parameters: {
        'index': index,
        'pageType': pageType.toString(),
      },
    );
  }

  void logSortTypeUpdate(SortingOption option, String source) {
    _firebase.logEvent(
      name: 'sort_habit_update',
      parameters: {
        'option': option.title,
        'source': source,
      },
    );
  }

  void logRecapOptionUpdate(RecapOption option, String source) {
    _firebase.logEvent(
      name: 'recap_habit_update',
      parameters: {
        'option': option.title,
        'source': source,
      },
    );
  }
}

enum HabitAction {
  create('save'),
  update('update'),
  open('open'),
  deleteAttempt('delete_attempt'),
  archived('archived'),
  delete('delete'),
  restore('restore');

  const HabitAction(this.key);
  final String key;
}
