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