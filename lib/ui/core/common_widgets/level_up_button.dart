import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class LevelUpButton extends StatelessWidget {
  const LevelUpButton({super.key, this.isEnabled, required this.text, required this.buttonStyle, required this.onClick});

  final LevelUpButtonStyle buttonStyle;
  final bool? isEnabled;
  final String text;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(buttonStyle.height.toDouble())),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonStyle.radius))),
          backgroundColor: isEnabled == false ? WidgetStatePropertyAll(buttonStyle.inactiveColor) : WidgetStatePropertyAll(buttonStyle.activeColor),
        ),
        onPressed: onClick,
        child: Text(text, style: Style.ablation15w900));
  }
}

class LevelUpButtonStyle {
  final double height;
  final TextStyle textStyle;
  final Color activeColor;
  final Color inactiveColor;
  final double radius = 4;

  LevelUpButtonStyle({required this.height, required this.textStyle, required this.activeColor, required this.inactiveColor});

  factory LevelUpButtonStyle.defaultStyle(ButtonHeight height) {
    return LevelUpButtonStyle(height: height.height, textStyle: height.textStyle, activeColor: AppColors.activeButtonColor, inactiveColor: AppColors.inActiveButtonColor);
  }

  factory LevelUpButtonStyle.darkStyle(ButtonHeight height) {
    return LevelUpButtonStyle(height: height.height, textStyle: height.textStyle, activeColor: AppColors.backgroundContentColor, inactiveColor: AppColors.backgroundContentColor);
  }
}

enum ButtonHeight {
  medium(44, Style.ablation14w900),
  tall(53, Style.ablation15w900);

  const ButtonHeight(this.height, this.textStyle);

  final double height;
  final TextStyle textStyle;
}
