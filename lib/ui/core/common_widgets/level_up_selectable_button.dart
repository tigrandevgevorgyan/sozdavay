import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class LevelUpSelectableButton extends StatelessWidget {
  const LevelUpSelectableButton({super.key, required this.value, required this.groupValue, this.isCheckbox = false, required this.onClick});

  final String value;
  final String groupValue;
  final Function() onClick;
  final bool isCheckbox;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = isCheckbox
        ? groupValue.split('|').contains(value)
        : value == groupValue;
    return GestureDetector(
      onTap: onClick,
      child: Row(
        children: [
          InkWell(
            onTap: onClick,
            child: isCheckbox
                ? _buildCheckbox(isSelected)
                : _buildRadio(isSelected),
          ),
          SizedBox(width: 14),
          Text(value, style: Style.outfit14w400),
        ],
      ),
    );
  }
}

Widget _buildRadio(bool isSelected) {
  return Stack(
    alignment: Alignment.center,
    children: [
      ColoredCircle(
        color: isSelected ? AppColors.activeButtonColor : const Color(0xFF3B3B3C),
        size: 20,
      ),
      ColoredCircle(
        color: isSelected ? Colors.white : AppColors.backgroundContentColor,
        size: isSelected ? 9 : 17,
      ),
    ],
  );
}

Widget _buildCheckbox(bool isSelected) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: isSelected ? AppColors.activeButtonColor : Colors.transparent,
      border: Border.all(
        color: isSelected ? AppColors.activeButtonColor : const Color(0xFF3B3B3C),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: isSelected
        ? const Icon(Icons.check, size: 14, color: Colors.white)
        : null,
  );
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
