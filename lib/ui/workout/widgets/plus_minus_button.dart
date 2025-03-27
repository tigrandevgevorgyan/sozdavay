import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';

class PlusMinusButton extends StatelessWidget {
  const PlusMinusButton({super.key, required this.onPlusClicked, required this.onMinusClicked});

  final Function() onPlusClicked;
  final Function() onMinusClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onPlusClicked,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryDefaultColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SvgPicture.asset(Assets.plusIcon),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onMinusClicked,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryDefaultColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SvgPicture.asset(Assets.minusIcon),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
