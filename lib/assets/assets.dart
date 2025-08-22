import '../brand/brand_config.dart';


class Assets {
  static late String _brandBase;
  static const String _commonBase = 'assets/common/images/';

  static void init(BrandConfig c) {
    _brandBase = 'assets/brands/${c.code}/images/';
  }

  static String get brandBase => _brandBase;

  /// ОБЩИЕ
  static String get arrowDownSvgIcon => "${_commonBase}arrow_down_icon.svg";
  static String get logoutIcon => "${_commonBase}logout_icon.png";
  static String get settingsIcon => "${_commonBase}settings_icon.png";
  static String get leftArrowIcon => "${_commonBase}left_arrow_icon.svg";
  static String get rightArrowIcon => "${_commonBase}right_arrow_icon.svg";
  static String get homeIcon => "${_commonBase}home_icon.svg";
  static String get refreshIcon => "${_commonBase}refresh_icon.svg";
  static String get enlargeIcon => "${_commonBase}enlarge_icon.svg";
  static String get playIcon => "${_commonBase}play_icon.svg";
  static String get pauseIcon => "${_commonBase}pause_icon.svg";
  static String get stopIcon => "${_commonBase}stop_icon.svg";
  static String get plusIcon => "${_commonBase}plus_icon.svg";
  static String get minusIcon => "${_commonBase}minus_icon.svg";
  static String get pencilIcon => "${_commonBase}pencil_icon.svg";
  static String get videoPreview => "${_commonBase}video_preview.png";
  static String get closeIcon => "${_commonBase}close_icon.svg";
  static String get rewindIcon => "${_commonBase}rewind_icon.svg";
  static String get forwardIcon => "${_commonBase}forward_icon.svg";
  static String get ratingFirstIcon => "${_commonBase}rating_1st_icon.png";
  static String get ratingSecondIcon => "${_commonBase}rating_2nd_icon.png";
  static String get ratingThirdIcon => "${_commonBase}rating_3rd_icon.png";

  /// БРЕНДОВЫЕ
  static String get logo => "${_brandBase}logo.png";
  static String get subscriptionBanner => "${_brandBase}subscription_banner.png";
  static String get startTrainingBanner => "${_brandBase}start_training_banner.png";
  static String get measurementsBanner => "${_brandBase}measurements_banner.png";
  static String get chatBanner => "${_brandBase}chat_banner.png";
  static String get training1 => "${_brandBase}training_1.jpg";
  static String get training2 => "${_brandBase}training_2.jpg";
  static String get training3 => "${_brandBase}training_3.jpg";
  static String get training4 => "${_brandBase}training_4.jpg";
  static String get training5 => "${_brandBase}training_5.jpg";
  static String get measurements1 => "${_brandBase}measurements_1.jpg";
  static String get measurements2 => "${_brandBase}measurements_2.jpg";
  static String get measurements3 => "${_brandBase}measurements_3.jpg";
  static String get measurements4 => "${_brandBase}measurements_4.jpg";
  static String get measurements5 => "${_brandBase}measurements_5.jpg";
  static String get chat1 => "${_brandBase}chat_1.jpg";
  static String get chat2 => "${_brandBase}chat_2.jpg";
  static String get chat3 => "${_brandBase}chat_3.jpg";
}
