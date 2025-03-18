import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({super.key, required this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(error!, style: Style.raleway16w400.copyWith(color: Colors.red)),
    );
  }
}
