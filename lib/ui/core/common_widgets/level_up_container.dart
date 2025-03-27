import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';

class LevelUpContainer extends StatelessWidget {
  const LevelUpContainer({super.key, this.color, this.child, this.height});

  final Color? color;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.backgroundContentColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      height: height,
      child: Center(
        child: child ?? SizedBox.fromSize(size: Size(1, 1)),
      ),
    );
  }
}
