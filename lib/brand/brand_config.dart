import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

const _brand = String.fromEnvironment('BRAND', defaultValue: 'level_up');

class BrandConfig {
  final String code;
  final String appName;
  final Map<String, Color> colors;
  final Uri coachChatUrl;
  final String apiBaseUrl;
  final List<String> trainingBanners;
  final List<String> measurementsBanners;
  final List<String> chatBanners;
  final Map<String, String> strings;
  final Map<String, dynamic> features;

  BrandConfig({
    required this.code,
    required this.appName,
    required this.colors,
    required this.coachChatUrl,
    required this.apiBaseUrl,
    required this.trainingBanners,
    required this.measurementsBanners,
    required this.chatBanners,
    required this.strings,
    required this.features,
  });

  static Color _parseHex(String v) {
    final s = v.startsWith('#') ? v.substring(1) : v;
    if (s.length == 6) {
      return Color(int.parse('FF$s', radix: 16));
    } else if (s.length == 8) {
      return Color(int.parse(s, radix: 16));
    } else {
      throw FormatException('wrong hex color $v');
    }
  }


  static Future<BrandConfig> load() async {
    final raw = await rootBundle.loadString('assets/brands/$_brand/config.json');
    final m = json.decode(raw) as Map<String, dynamic>;
    final c = (m['colors'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, _parseHex(v as String)),
    );
    final banners = (m['banners'] as Map<String, dynamic>?);
    List<String> _list(String key) =>
        (banners?[key] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList();
    final stringsMap = (m['strings'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v as String),
    );
    final featuresMap = (m['features'] as Map<String, dynamic>? ?? {});


    return BrandConfig(
      code: _brand,
      appName: m['appName'] as String,
      coachChatUrl: Uri.parse(m['coachChatUrl'] as String),
      apiBaseUrl: m['apiBaseUrl'] as String,
      colors: c,
      trainingBanners: _list('training'),
      measurementsBanners: _list('measurements'),
      chatBanners: _list('chat'),
      strings: stringsMap,
      features: featuresMap,
    );
  }
}
