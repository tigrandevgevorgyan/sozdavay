import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class LevelUpRadioButton extends StatelessWidget {
  const LevelUpRadioButton({super.key, required this.value, required this.groupValue, required this.onClick});

  final String value;
  final String groupValue;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: onClick,
      child: Row(
        children: [
          InkWell(
            onTap: onClick,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ColoredCircle(
                  color: isSelected ? AppColors.activeButtonColor : Color(0xFF3B3B3C),
                  size: 20,
                ),
                ColoredCircle(
                  color: isSelected ? Colors.white : AppColors.backgroundContentColor,
                  size: isSelected ? 9 : 17,
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          Text(value, style: Style.outfit14w400),
        ],
      ),
    );
  }
}

class ColoredCircle extends StatelessWidget {
  const ColoredCircle({super.key, required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: size,
      height: size,
    );
  }
}
