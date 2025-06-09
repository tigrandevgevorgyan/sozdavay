const weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

extension NumberParsing on double {
  String formatDouble() {
    return toStringAsFixed(truncateToDouble() == this ? 0 : 2);
  }
}

String getToday() {
  final now = DateTime.now();
  return now.toIso8601String().split('T').first;
}

String getWeekday() {
  final now = DateTime.now();
  return weekDays[now.weekday - 1];
}

extension DateFormatting on String {
  String toWeekdayWithDate() {
    final parsedDate = DateTime.parse(this);
    final weekday = weekDays[parsedDate.weekday - 1];
    final formatted = '${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}';
    return '$weekday $formatted';
  }
}
