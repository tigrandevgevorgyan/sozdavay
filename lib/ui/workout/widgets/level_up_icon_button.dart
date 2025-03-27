import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';

class LevelUpIconButton extends StatelessWidget {
  final String iconAsset;
  final Function() onClick;

  const LevelUpIconButton({super.key, required this.onClick, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 46,
      child: LevelUpContainer(
        color: AppColors.secondaryDefaultColor,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: SvgPicture.asset(iconAsset),
        ),
      ),
    );
  }
}
