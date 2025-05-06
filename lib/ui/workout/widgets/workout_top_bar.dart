import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class WorkoutTopBar extends StatelessWidget {
  const WorkoutTopBar({
    super.key,
    required this.firstExerciseName,
    this.secondExerciseName,
    required this.onFirstExerciseRefresh,
    this.onSecondExerciseRefresh,
    required this.isUpdatingFirstExercise,
    this.isUpdatingSecondExercise,
  });

  final bool isUpdatingFirstExercise;
  final bool? isUpdatingSecondExercise;
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
            SizedBox(height: 20),
            ExerciseRow(isUpdating: isUpdatingFirstExercise, title: firstExerciseName, onRefreshClicked: onFirstExerciseRefresh),
            if (secondExerciseName != null) Divider(color: Color(0x80242425)),
            if (secondExerciseName != null) ExerciseRow(isUpdating: isUpdatingSecondExercise!, title: secondExerciseName!, onRefreshClicked: onSecondExerciseRefresh!),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class ExerciseRow extends StatelessWidget {
  const ExerciseRow({super.key, required this.title, required this.onRefreshClicked, required this.isUpdating});

  final bool isUpdating;
  final String title;
  final Function() onRefreshClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //  SizedBox(height: 6),
        GestureDetector(
          onTap: onRefreshClicked,
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 14),
            child: isUpdating ? LevelUpLoader() : SvgPicture.asset(Assets.refreshIcon),
          ),
        ),
        Expanded(
          child: Text(title, style: Style.raleway17w700.copyWith(color: AppColors.primaryTextColor)),
        ),
      ],
    );
  }
}
