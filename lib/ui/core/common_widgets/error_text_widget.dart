import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class InfoAndErrorTextWidget extends StatelessWidget {
  const InfoAndErrorTextWidget({super.key, required this.text, required this.isError});

  final String? text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
          text!,
          style: Style.outfit16w400.copyWith(
              color: isError
            ? Colors.red
            : AppColors.errorMessagePositive,
          )),
    );
  }
}
