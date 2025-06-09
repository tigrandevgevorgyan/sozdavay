import 'dart:math';

import 'assets.dart';

class HomeBannersAssets {
  static final _random = Random();

  static final _trainingImages = [
    Assets.training1,
    Assets.training2,
    Assets.training3,
    Assets.training4,
  ];

  static final _measurementsImages = [
    Assets.measurements1,
    Assets.measurements2,
    Assets.measurements3,
  ];

  static final _chatImages = [
    Assets.chat1,
    Assets.chat2,
    Assets.chat3,
  ];

  static String getRandomTrainingImage() {
    return _trainingImages[_random.nextInt(_trainingImages.length)];
  }

  static String getRandomMeasurementsImage() {
    return _measurementsImages[_random.nextInt(_measurementsImages.length)];
  }

  static String getRandomChatImage() {
    return _chatImages[_random.nextInt(_chatImages.length)];
  }
}
