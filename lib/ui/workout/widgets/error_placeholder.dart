import 'package:flutter/material.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import '../../../config/assets.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';

class ErrorPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const ErrorPlaceholder({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: SizedBox(
          height: 40,
          child: Image.asset(Assets.logo),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Что-то пошло не так",
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: LevelUpButton(
                  text: "Попробовать заново",
                  buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                  onClick: onTap,
              ),
            )
          ],
        ),
      ),
    );
  }
}