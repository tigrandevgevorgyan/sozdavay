import 'dart:math';
import 'assets.dart';
import 'package:get_it/get_it.dart';
import '../brand/brand_config.dart';

class HomeBannersAssets {
  static final _rand = Random();

  // --- helpers to build full paths from brand base ---
  static List<String> _bannerList(List<String> fromConfig, List<String> defaults) {
    final base = Assets.brandBase;
    final list = (fromConfig.isNotEmpty ? fromConfig : defaults)
        .where((name) => name.trim().isNotEmpty)
        .toList();
    return list.map((name) => '$base$name').toList();
  }

  // --- defaults (relative names without base) ---
  static List<String> get training => _bannerList(
        GetIt.I<BrandConfig>().trainingBanners,
        const [
          'training_1.jpg',
          'training_2.jpg',
          'training_3.jpg',
          'training_4.jpg',
          'training_5.jpg',
          'training_6.jpg',
          'training_7.jpg',
          'training_8.jpg',
          'training_9.jpg',
          'training_10.jpg',
          'training_11.jpg',
          'training_12.jpg',
        ],
      );

  static List<String> get measurements => _bannerList(
        GetIt.I<BrandConfig>().measurementsBanners,
        const ['measurements_1.jpg', 'measurements_2.jpg', 'measurements_3.jpg'],
      );

  static List<String> get chat => _bannerList(
        GetIt.I<BrandConfig>().chatBanners,
        const [
          'training_1.jpg',
          'training_2.jpg',
          'training_3.jpg',
          'training_4.jpg',
          'training_5.jpg',
          'training_6.jpg',
          'training_7.jpg',
          'training_8.jpg',
          'training_9.jpg',
          'training_10.jpg',
          'training_11.jpg',
          'training_12.jpg',
          'measurements_1.jpg',
          'measurements_2.jpg',
          'measurements_3.jpg',
        ],
      );

  // --- unique rotation queues (no repeats until cycle completes) ---
  static final List<String> _trainingQueue = [];
  static final List<String> _measurementsQueue = [];
  static final List<String> _chatQueue = [];

  static final Set<String> _inUse = {};

  static String _nextUnique(List<String> source, List<String> queue) {
    if (source.isEmpty) return '';
    if (queue.isEmpty) {
      // re-fill with a new random order
      queue.addAll(source);
      queue.shuffle(_rand);
    }
    while (queue.isNotEmpty) {
      final candidate = queue.removeLast();
      if (!_inUse.contains(candidate)) {
        _inUse.add(candidate);
        return candidate;
      }
    }
    // If all are in use, reshuffle and try again
    queue.addAll(source.where((img) => !_inUse.contains(img)));
    queue.shuffle(_rand);
    if (queue.isEmpty) return '';
    final candidate = queue.removeLast();
    _inUse.add(candidate);
    return candidate;
  }

  static String getRandomTrainingImage() {
    _inUse.clear();
    return _nextUnique(training, _trainingQueue);
  }

  static String getRandomMeasurementsImage() {
    _inUse.clear();
    return _nextUnique(measurements, _measurementsQueue);
  }

  static String getRandomChatImage() {
    _inUse.clear();
    return _nextUnique(chat, _chatQueue);
  }
}
