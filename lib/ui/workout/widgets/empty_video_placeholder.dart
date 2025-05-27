import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class EmptyVideoPlaceholder extends StatelessWidget {
  const EmptyVideoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.backgroundContentColor),
      child: Center(
        child: Text('Нет видео!', style: Style.ablation14w800),
      ),
    );
  }
}
