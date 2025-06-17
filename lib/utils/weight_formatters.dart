
import 'package:flutter/services.dart';

class WeightTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    final isValid = RegExp(r'^\d{0,3}(\.\d{0,1})?$').hasMatch(text);
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

