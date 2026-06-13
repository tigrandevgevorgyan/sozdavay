import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

/// "Ваш прогресс" row from Gohar's Home design (Figma 30:151).
///
/// Four stats with circular-icon prefix:
///   Время (clock), Тренировок (gym), Калории (fire), Дни Подряд (medal).
///
/// Backend currently exposes only the workouts count (via MainInfo). Time,
/// calories, and streak require new aggregations on the server. Until those
/// land, those stats render as "—" — section still appears so the layout
/// matches Figma; data turns on when backend lands.
class YourProgressRow extends StatelessWidget {
  const YourProgressRow({
    super.key,
    required this.workoutsCount,
    this.timeText,
    this.calories,
    this.streakDays,
  });

  /// Workouts done in the selected period — comes from MainInfo.workout.season.
  final int workoutsCount;

  /// Human-formatted time, e.g. "12ч 24м". Null → renders as "—".
  final String? timeText;

  /// Calories burned. Null → "—".
  final int? calories;

  /// Streak length. Null → "—".
  final int? streakDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(child: _StatTile(value: timeText ?? '—', label: 'Время', icon: Icons.access_time)),
          Expanded(child: _StatTile(value: '$workoutsCount', label: 'Тренировок', icon: Icons.fitness_center)),
          Expanded(
            child: _StatTile(
              value: calories != null ? _formatNumber(calories!) : '—',
              label: 'Калории',
              icon: Icons.local_fire_department_outlined,
            ),
          ),
          Expanded(
            child: _StatTile(
              value: streakDays != null ? '$streakDays' : '—',
              label: 'Дни Подряд',
              icon: Icons.emoji_events_outlined,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.secondaryTextColor),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
