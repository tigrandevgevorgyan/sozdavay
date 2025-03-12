import 'package:flutter/services.dart';

class PhoneMaskFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String unformattedString = newValue.text.replaceAll(" ", "");
    String newString = unformattedString;
    if (unformattedString.length > 3) {
      newString = newString.replaceRange(3, 3, " ");
    }
    if (unformattedString.length > 6) {
      newString = newString.replaceRange(7, 7, " ");
    }
    if (unformattedString.length > 8) {
      newString = newString.replaceRange(10, 10, " ");
    }
    return TextEditingValue(text: newString);
  }
}
