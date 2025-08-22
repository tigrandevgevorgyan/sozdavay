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
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onClick,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(
                color: AppColors.overlayColor1,
              ),
              Container(
                color: AppColors.overlayColor2,
              ),
              Positioned(
                bottom: 12,
                left: 16,
                child: Text(text, style: Style.ablation15w900.copyWith(color: AppColors.primaryTextColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
