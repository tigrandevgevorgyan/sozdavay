import 'dart:math';
import 'assets.dart';
import 'package:get_it/get_it.dart';
import '../brand/brand_config.dart';

class HomeBannersAssets {
  static final _rand = Random();

  static List<String> _bannerList(List<String> fromConfig, List<String> defaults) {
    final base = Assets.brandBase;
    final list = (fromConfig.isNotEmpty ? fromConfig : defaults)
        .where((name) => name.trim().isNotEmpty)
        .toList();
    return list.map((name) => '$base$name').toList();
  }

  static List<String> get training => _bannerList(
    GetIt.I<BrandConfig>().trainingBanners,
    const ['training_1.jpg', 'training_2.jpg', 'training_3.jpg', 'training_4.jpg'],
  );

  static List<String> get measurements => _bannerList(
    GetIt.I<BrandConfig>().measurementsBanners,
    const ['measurements_1.jpg', 'measurements_2.jpg', 'measurements_3.jpg'],
  );

  static List<String> get chat => _bannerList(
    GetIt.I<BrandConfig>().chatBanners,
    const ['chat_1.jpg', 'chat_2.jpg', 'chat_3.jpg'],
  );

  static String _randomFrom(List<String> list) =>
      list.isNotEmpty ? list[_rand.nextInt(list.length)] : '';

  static String getRandomTrainingImage() => _randomFrom(training);
  static String getRandomMeasurementsImage() => _randomFrom(measurements);
  static String getRandomChatImage() => _randomFrom(chat);
}

