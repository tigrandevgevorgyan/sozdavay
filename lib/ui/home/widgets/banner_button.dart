import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class BannerButton extends StatelessWidget {
  const BannerButton({super.key, required this.imagePath, required this.text, required this.onClick});

  final String imagePath;
  final String text;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Stack(
        children: [
          Image.asset(imagePath),
          Positioned(
            bottom: 12,
            left: 16,
            child: Text(text, style: Style.ablation15w900.copyWith(color: AppColors.primaryTextColor)),
          ),
        ],
      ),
    );
  }
}
