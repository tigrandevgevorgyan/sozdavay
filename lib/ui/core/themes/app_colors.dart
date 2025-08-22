import 'dart:ui';

import '../../../brand/brand_config.dart';

class AppColors {
  static late Map<String, Color> _c;

  static void init(BrandConfig cfg) {
    _c = cfg.colors;
  }

  static Color get backgroundColor        => _c['backgroundColor']!;
  static Color get backgroundContentColor => _c['backgroundContentColor']!;
  static Color get inActiveButtonColor    => _c['inActiveButtonColor']!;
  static Color get activeButtonColor      => _c['activeButtonColor']!;
  static Color get inputBackgroundColor   => _c['inputBackgroundColor']!;
  static Color get inputBorderColor       => _c['inputBorderColor']!;
  static Color get tertiaryHintColor      => _c['tertiaryHintColor']!;
  static Color get disabledTextColor      => _c['disabledTextColor']!;
  static Color get primaryTextColor       => _c['primaryTextColor']!;
  static Color get secondaryTextColor     => _c['secondaryTextColor']!;
  static Color get secondaryDefaultColor  => _c['secondaryDefaultColor']!;
  static Color get timerDoneOrangeColor   => _c['timerDoneOrangeColor']!;
  static Color get overlayColor1          => _c['overlayColor1']!;
  static Color get overlayColor2          => _c['overlayColor2']!;
  static Color get errorMessagePositive   => _c['errorMessagePositive']!;
}

