extension DoubleExt on double {
  String toPercentage({bool withPositiveSign = true}) {
    final percent = this * 100;
    String formattedPercentage = percent.toStringAsFixed(1);
    if (formattedPercentage.endsWith('.0')) {
      formattedPercentage = '${percent.toInt()}%';
    } else {
      formattedPercentage = '$formattedPercentage%';
    }
    final prefix = withPositiveSign && percent > 0 ? '+' : '';
    return '$prefix$formattedPercentage';
  }

  String to2Digit() {
    return toStringAsFixed(0).padLeft(2, '0');
  }
}

extension IntExt on int {
  String to2Digit() {
    return toStringAsFixed(0).padLeft(2, '0');
  }

  int getYearTotalDays() {
    final lastDayOfYear = DateTime(this, 12, 31);
    final firstDayOfYear = DateTime(this, 1, 1);
    return lastDayOfYear.difference(firstDayOfYear).inDays + 1;
  }

  int getMonthTotalDays({int? year}) {
    return DateTime(year ?? DateTime.now().year, this + 1, 0).day;
  }

  String formatShort() {
    if (this < 1000) return toString();
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(1)}k';
    if (this < 1000000000) return '${(this / 1000000).toStringAsFixed(1)}m';
    return '${(this / 1000000000000).toStringAsFixed(1)}b';
  }
}
