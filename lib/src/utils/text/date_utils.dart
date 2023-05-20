import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

mixin AppDateFormat {
  static final dayNameFormat = DateFormat('EEE');
  static final monthDateFormat = DateFormat('MMM d');
  static final monthYearFormat = DateFormat('MMM y');
  static final onlyMonthFormat = DateFormat('MMM');
  static final onlyDateFormat = DateFormat('d');
  static final hourMinuteFormat = DateFormat('hh:mm');

  static final dayNames = [
    ...DateFormat.EEEE().dateSymbols.STANDALONESHORTWEEKDAYS.sublist(1),
    DateFormat.EEEE().dateSymbols.STANDALONESHORTWEEKDAYS[0],
  ];
}

extension DateTimeExt on DateTime {
  String monthName({bool withYear = true}) {
    if (withYear) return AppDateFormat.monthYearFormat.format(this);
    return AppDateFormat.onlyMonthFormat.format(this);
  }

  String dayName() => AppDateFormat.dayNameFormat.format(this);
  String hourMinute() => AppDateFormat.hourMinuteFormat.format(this);

  DateTime emptyHour() => copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  bool isSameDay(DateTime other) => emptyHour().isAtSameMomentAs(other.emptyHour());
  bool isSameMonth(DateTime other) => month == other.month;
}

extension WeekTimeExt on List<DateTime> {
  String format() {
    if (isEmpty) return '';
    if (length == 1) return AppDateFormat.monthDateFormat.format(first);
    final startWeek = first;
    final endWeek = last;
    if (startWeek.month == endWeek.month) {
      return '${AppDateFormat.monthDateFormat.format(startWeek)} - ${AppDateFormat.onlyDateFormat.format(endWeek)}';
    } else {
      return '${AppDateFormat.monthDateFormat.format(startWeek)} - ${AppDateFormat.monthDateFormat.format(endWeek)}';
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}
