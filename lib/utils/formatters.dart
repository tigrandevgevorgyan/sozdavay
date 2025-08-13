
import 'package:flutter/services.dart';

class WeightTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;

    text = text.replaceAll(',', '.');

    final isValid = RegExp(r'^\d{1,3}(\.\d{0,1})?$|^\d{1,3}\.$').hasMatch(text);

    if (!isValid) return oldValue;

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
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

class ComplexTimeWithSecondsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final normalized = newValue.text.replaceAll(',', '.');

    if (normalized.isEmpty) {
      return newValue.copyWith(text: normalized);
    }

    if (!RegExp(r'^\d+(\.\d{0,2})?$').hasMatch(normalized)) {
      return oldValue;
    }

    final dot = normalized.indexOf('.');
    if (dot != -1) {
      final frac = normalized.substring(dot + 1);

      if (frac.isNotEmpty) {
        final first = frac.codeUnitAt(0) - 48;

        if (first > 5) return oldValue;
      }
    }

    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
      composing: TextRange.empty,
    );
  }
}
