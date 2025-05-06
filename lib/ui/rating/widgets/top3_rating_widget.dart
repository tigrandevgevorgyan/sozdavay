import 'package:flutter/material.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class Top3RatingWidget extends StatelessWidget {
  const Top3RatingWidget({super.key, required this.firstPlace, required this.secondPlace, required this.thirdPlace});

  final PersonsScores? firstPlace;
  final PersonsScores? secondPlace;
  final PersonsScores? thirdPlace;

  final sideFlex = 1;
  final betweenFlex = 4;
  final contentFlex = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: sideFlex,
          child: SizedBox.shrink(),
        ),
        Expanded(
          flex: contentFlex,
          child: Column(
            children: [
              SizedBox(height: 20),
              PodiumPositionWidget(imagePath: Assets.ratingSecondIcon, name: secondPlace?.name, score: secondPlace?.score),
            ],
          ),
        ),
        Expanded(
          flex: betweenFlex,
          child: SizedBox.shrink(),
        ),
        Expanded(
          flex: contentFlex,
          child: PodiumPositionWidget(imagePath: Assets.ratingFirstIcon, name: firstPlace?.name, score: firstPlace?.score),
        ),
        Expanded(
          flex: betweenFlex,
          child: SizedBox.shrink(),
        ),
        Expanded(
          flex: contentFlex,
          child: Column(
            children: [
              SizedBox(height: 20),
              PodiumPositionWidget(imagePath: Assets.ratingThirdIcon, name: thirdPlace?.name, score: thirdPlace?.score),
            ],
          ),
        ),
        Expanded(
          flex: sideFlex,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}

class PodiumPositionWidget extends StatelessWidget {
  const PodiumPositionWidget({super.key, required this.imagePath, required this.name, required this.score});

  final String imagePath;
  final String? name;
  final int? score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(imagePath),
        ),
        SizedBox(height: 4),
        if (name != null && score != null) ...[
          Text(name!, style: Style.raleway16w400.copyWith(color: AppColors.primaryTextColor), textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(score.toString(), style: Style.ablation14w900.copyWith(color: AppColors.activeButtonColor)),
        ]
      ],
    );
  }
}

class PersonsScores {
  final String name;
  final int score;

  PersonsScores(this.name, this.score);
}
