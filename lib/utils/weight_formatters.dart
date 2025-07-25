
import 'package:flutter/services.dart';

class WeightTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;

    final isValid = RegExp(r'^\d{1,3}(\.\d{0,1})?$|^\d{1,3}\.$').hasMatch(text);
    return isValid ? newValue : oldValue;
  }
}

extension DoubleFormatter on double {
  String formatDouble() {
    if (this == this.roundToDouble()) {
      return toStringAsFixed(0);
    } else {
      return toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
    }
  }
}

String cleanLastDotDelete(String value) {
  if (value.endsWith('.')) {
    return value.substring(0, value.length - 1);
  }
  return value;
}


