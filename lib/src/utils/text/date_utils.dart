import 'package:intl/intl.dart';

final dayNameFormat = DateFormat('EEE');
final monthDateFormat = DateFormat('MMM d');
final onlyDateFormat = DateFormat('d');

extension DateTimeExt on DateTime {
  String dayName() => dayNameFormat.format(this);
}

extension WeekTimeExt on List<DateTime> {
  String format() {
    if (isEmpty) return '';
    if (length == 1) return monthDateFormat.format(first);
    final startWeek = first;
    final endWeek = last;
    if (startWeek.month == endWeek.month) {
      return '${monthDateFormat.format(startWeek)} - ${onlyDateFormat.format(endWeek)}';
    } else {
      return '${monthDateFormat.format(startWeek)} - ${monthDateFormat.format(endWeek)}';
    }
  }
}
