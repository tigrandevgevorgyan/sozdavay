const weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

extension NumberParsing on double {
  String formatDouble() {
    return toStringAsFixed(truncateToDouble() == this ? 0 : 2);
  }
}
