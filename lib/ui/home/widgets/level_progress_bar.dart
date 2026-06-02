import 'package:flutter/material.dart';
import 'package:level_up/data/services/gamification/models/rating_level_summary.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

/// "Уровень N из 34" header strip with a linear progress bar.
///
/// Pulled from Gohar's Home design (figma node 1:1419) but rendered with
/// the existing app's tokens — Ablation font, AppColors.activeButtonColor
/// for the filled portion, AppColors.inActiveButtonColor for the track.
///
/// Hidden (returns SizedBox.shrink) when the customer's profile hasn't
/// loaded the gamification block yet — no flicker.
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key, required this.level});

  final RatingLevelSummary? level;

  static const int _maxLevel = 34;
  static const double _barHeight = 6;

  @override
  Widget build(BuildContext context) {
    final l = level;
    if (l == null) return const SizedBox.shrink();

    final progress = l.progressInLevel.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Уровень ${l.level} из $_maxLevel · ${l.label}',
            style: Style.ablation13w700.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(_barHeight / 2),
          child: Stack(
            children: [
              Container(
                height: _barHeight,
                width: double.infinity,
                color: AppColors.inActiveButtonColor,
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: _barHeight,
                  color: AppColors.activeButtonColor,
                ),
              ),
            ],
          ),
        ),
        if (!l.isMaxLevel)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'До «${l.nextLevelLabel}»: ${l.pointsToNextLevel}',
              style: Style.ablation12w900.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
