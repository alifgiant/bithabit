extension DoubleExt on double {
  String toPercentage() {
    final percent = this * 100;
    String formattedPercentage = percent.toStringAsFixed(1);
    if (formattedPercentage.endsWith('.0')) {
      formattedPercentage = '${percent.toInt()}%';
    } else {
      formattedPercentage = '$formattedPercentage%';
    }
    String prefix = percent > 0 ? '+' : '';
    return '$prefix$formattedPercentage';
  }
}

extension IntExt on int {
  int getYearTotalDays() {
    final lastDayOfYear = DateTime(this, 12, 31);
    final firstDayOfYear = DateTime(this, 1, 1);
    return lastDayOfYear.difference(firstDayOfYear).inDays + 1;
  }
}
