import 'dart:math';

import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class StatisticsTileWidget extends StatelessWidget {
  const StatisticsTileWidget(
      {super.key,
      required this.monthlyValue,
      required this.yearlyValue,
      required this.ratingPercent,
      required this.level,
      required this.onMonthlyClicked,
      required this.onYearlyClicked,
      required this.onRatingClicked,
      required this.rating});

  final int monthlyValue;
  final int yearlyValue;
  final double ratingPercent;
  final int rating;
  final String level;
  final Function() onMonthlyClicked;
  final Function() onYearlyClicked;
  final Function() onRatingClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onMonthlyClicked,
                  child: SmallStatisticsTile(number: monthlyValue, label: 'за месяц', onClick: () {}),
                ),
              ),
              SizedBox(height: 4),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onYearlyClicked,
                  child: SmallStatisticsTile(number: yearlyValue, label: 'за сезон', onClick: () {}),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onRatingClicked,
            child: RatingTile(
              level: level,
              rating: rating,
              ratingPercent: ratingPercent,
            ),
          ),
        ),
      ],
    );
  }
}

class SmallStatisticsTile extends StatelessWidget {
  const SmallStatisticsTile({super.key, required this.number, required this.label, required this.onClick});

  final int number;
  final String label;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number.toString(),
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: Style.ablation32w900.copyWith(color: AppColors.primaryTextColor),
                ),
                // slightly smaller vertical shift to avoid clipping on tight heights
                Transform.translate(
                  offset: const Offset(0, -4),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Style.outfit16w400.copyWith(color: AppColors.secondaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingTile extends StatelessWidget {
  final String level;
  final int rating;
  final double ratingPercent;

  const RatingTile({super.key, required this.level, required this.rating, required this.ratingPercent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backgroundContentColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // compute maximum square that fits; clamp to sane bounds
                        final shortest = constraints.biggest.shortestSide;
                        //   final side = shortest.isFinite ? shortest - 24 : 120; // leave some padding
                        //                         // If there is not enough space (small tile), use smaller radius (80), otherwise use 120
                        //                         final clamped = (side < 120 ? 80.0 : 120.0);
                        final side = shortest.isFinite ? shortest - 24 : 120; // leave some padding
                        // iPhone 8 logical size ~ 375x667. If the screen is smaller, reduce max chart size.
                        final screenSize = MediaQuery.of(context).size;
                        final isSmallScreen = screenSize.width < 375 || screenSize.height < 732;

                        final maxCap = isSmallScreen ? 80.0 : 120.0;
                        final clamped = side.clamp(72.0, maxCap).toDouble();   // 72..maxCap

                        debugPrint('[RatingTile] constraints: ${constraints.biggest}');
                        debugPrint('[RatingTile] screenSizewidth: ${screenSize.width}');
                        debugPrint('[RatingTile]  screenSize.height: ${screenSize.height}');
                        debugPrint('[RatingTile] clamped size: $clamped');
                        // debugPrint('[RatingTile] strokeWidth: $dynamicStroke');

                        final dynamicStroke = max(4.0, clamped * 0.083);      // ~10 when 120

                        return SizedBox(
                          width: clamped,
                          height: clamped,
                          child: CustomPaint(
                            painter: RatingPainter(
                              arcBackgroundColor: AppColors.secondaryDefaultColor,
                              arcForegroundColor: AppColors.activeButtonColor,
                              strokeWidth: dynamicStroke,
                              percent: ratingPercent,
                            ),
                          ),
                        );
                      },
                    ),
                    Text(rating.toString(), style: Style.ablation22w700.copyWith(color: AppColors.primaryTextColor)),
                  ],
                ),
                SizedBox(height: 10),
                Text(level, style: Style.ablation15w900.copyWith(color: AppColors.primaryTextColor)),
              ],
            ),
          )),
    );
  }
}

class RatingPainter extends CustomPainter {
  final Color arcBackgroundColor;
  final Color arcForegroundColor;
  final double strokeWidth;
  final double percent;

  late Paint backgroundArcPaint;
  late Paint foregroundArcPaint;

  RatingPainter({super.repaint, required this.arcBackgroundColor, required this.arcForegroundColor, required this.strokeWidth, required this.percent}) {
    backgroundArcPaint = Paint();
    backgroundArcPaint.color = arcBackgroundColor;
    backgroundArcPaint.strokeCap = StrokeCap.round;
    backgroundArcPaint.style = PaintingStyle.stroke;
    backgroundArcPaint.strokeWidth = strokeWidth;

    foregroundArcPaint = Paint();
    foregroundArcPaint.color = arcForegroundColor;
    foregroundArcPaint.strokeCap = StrokeCap.round;
    foregroundArcPaint.style = PaintingStyle.stroke;
    foregroundArcPaint.strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, 2 * pi, false, backgroundArcPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, (2 * pi) * percent, false, foregroundArcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
