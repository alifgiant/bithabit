import 'package:intl/intl.dart';

mixin AppDateFormat {
  static final dayNameFormat = DateFormat('EEE');
  static final monthDateFormat = DateFormat('MMM d');
  static final onlyDateFormat = DateFormat('d');
}

extension DateTimeExt on DateTime {
  String dayName() => AppDateFormat.dayNameFormat.format(this);
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
