import 'package:flutter/services.dart';

class PhoneMaskFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String unformattedString = newValue.text.replaceAll(" ", "").replaceAll('(', '').replaceAll(')', '');
    String newString = unformattedString;
    if (unformattedString.isNotEmpty) {
      newString = newString.replaceRange(0, 0, "(");
    }
    if (unformattedString.length > 3) {
      newString = newString.replaceRange(4, 4, ") ");
    }
    if (unformattedString.length > 6) {
      newString = newString.replaceRange(9, 9, " ");
    }
    if (unformattedString.length > 9) {
      newString = newString.replaceRange(12, 12, " ");
    }
    return TextEditingValue(text: newString);
  }
}
