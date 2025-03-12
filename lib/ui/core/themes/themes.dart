import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.backgroundColor,
  );
}
