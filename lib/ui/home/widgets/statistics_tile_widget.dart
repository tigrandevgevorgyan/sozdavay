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
                  child: SmallStatisticsTile(number: yearlyValue, label: 'за год', onClick: () {}),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number.toString(),
              style: Style.ablation32w900.copyWith(color: AppColors.primaryTextColor),
            ),
            Transform.translate(offset: Offset(0, -6), child: Text(label, style: Style.outfit16w400.copyWith(color: AppColors.secondaryTextColor))),
          ],
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
                    CustomPaint(
                      size: Size(90, 90),
                      painter: RatingPainter(
                          arcBackgroundColor: AppColors.secondaryDefaultColor, arcForegroundColor: AppColors.activeButtonColor, strokeWidth: 10, percent: ratingPercent),
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
    final radius = (size.width - 10) / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, 2 * pi, false, backgroundArcPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, (2 * pi) * percent, false, foregroundArcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
