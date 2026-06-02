import 'package:json_annotation/json_annotation.dart';

part 'rating_level_summary.g.dart';

/// Mirrors backend RatingLevelService::summary() output.
/// Returned inside UserProfile (as `rating_level`) and also as `level` in
/// GET /rating/balance.
@JsonSerializable()
class RatingLevelSummary {
  final int points;
  final int level;
  final String label;
  @JsonKey(name: 'points_in_level')
  final int pointsInLevel;
  @JsonKey(name: 'points_to_next_level')
  final int pointsToNextLevel;
  @JsonKey(name: 'next_level')
  final int nextLevel;
  @JsonKey(name: 'next_level_label')
  final String nextLevelLabel;
  @JsonKey(name: 'is_max_level')
  final bool isMaxLevel;
  final String formula; // 'legacy' or 'new'

  RatingLevelSummary({
    required this.points,
    required this.level,
    required this.label,
    required this.pointsInLevel,
    required this.pointsToNextLevel,
    required this.nextLevel,
    required this.nextLevelLabel,
    required this.isMaxLevel,
    required this.formula,
  });

  /// Progress through the current level (0.0–1.0). Useful for progress bars.
  double get progressInLevel {
    final span = pointsInLevel + pointsToNextLevel;
    if (span <= 0) return 1.0;
    return pointsInLevel / span;
  }

  factory RatingLevelSummary.fromJson(Map<String, dynamic> json) =>
      _$RatingLevelSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RatingLevelSummaryToJson(this);
}
