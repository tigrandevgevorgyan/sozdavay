import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class OptionsInputField extends StatelessWidget {
  const OptionsInputField({super.key, required this.hint, this.value, this.isArrowVisible, required this.onClick});

  final String hint;
  final String? value;
  final bool? isArrowVisible;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inputBorderColor),
          borderRadius: BorderRadius.circular(4),
          color: AppColors.inputBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: value == null
                    ? Text(
                        hint,
                        style: Style.ablation15w900.copyWith(color: AppColors.tertiaryHintColor),
                      )
                    : Text(value!, style: Style.ablation15w900),
              ),
              if (isArrowVisible ?? false) SvgPicture.asset(Assets.arrowDownSvgIcon),
            ],
          ),
        ),
      ),
    );
  }
}
