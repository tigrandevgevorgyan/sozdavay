import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    final prefixesToRemove = {
      '+7': 2,
      '8': 1,
    };

    for (final entry in prefixesToRemove.entries) {
      final prefix = entry.key;
      final lengthToRemove = entry.value;

      if (text.startsWith(prefix)) {
        final newText = text.substring(lengthToRemove);
        final newOffset = (newValue.selection.baseOffset - lengthToRemove)
            .clamp(0, newText.length);

        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: newOffset,
          ),
        );
      }
    }
    return newValue;
  }
}
