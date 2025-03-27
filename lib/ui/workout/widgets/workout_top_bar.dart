import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class WorkoutTopBar extends StatelessWidget {
  const WorkoutTopBar({super.key, required this.firstExerciseName, this.secondExerciseName, required this.onFirstExerciseRefresh, this.onSecondExerciseRefresh});

  final String firstExerciseName;
  final String? secondExerciseName;

  final Function() onFirstExerciseRefresh;
  final Function()? onSecondExerciseRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            SizedBox(height: 14),
            ExerciseRow(title: firstExerciseName, onRefreshClicked: onFirstExerciseRefresh),
            if (secondExerciseName != null) Divider(color: Color(0x80242425)),
            if (secondExerciseName != null) ExerciseRow(title: secondExerciseName!, onRefreshClicked: onSecondExerciseRefresh!),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class ExerciseRow extends StatelessWidget {
  const ExerciseRow({super.key, required this.title, required this.onRefreshClicked});

  final String title;
  final Function() onRefreshClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //  SizedBox(height: 6),
        Expanded(
          child: Text(title, style: Style.raleway15w400.copyWith(color: AppColors.primaryTextColor)),
        ),
        GestureDetector(
          onTap: onRefreshClicked,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(Assets.refreshIcon),
          ),
        ),
      ],
    );
  }
}
