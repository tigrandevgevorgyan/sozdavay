import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/workout/view_model/double_view_model.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/horizontal_timer.dart';
import 'package:level_up/ui/workout/widgets/plus_minus_button.dart';
import 'package:level_up/ui/workout/widgets/video_player_card.dart';
import 'package:level_up/ui/workout/widgets/workout_top_bar.dart';
import 'package:provider/provider.dart';

class DoubleWorkoutScreen extends StatelessWidget {
  const DoubleWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DoubleViewModel>(
      create: (context) => DoubleViewModel(context),
      child: Consumer<DoubleViewModel>(builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              WorkoutTopBar(
                firstExerciseName: 'Горизонтальный жим сидя параллельным хватом на тренажере',
                secondExerciseName: 'Горизонтальный жим сидя параллельным хватом на тренажере',
                onFirstExerciseRefresh: () {},
                onSecondExerciseRefresh: () {},
              ),
              SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  VideoPlayerCard(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                                  SizedBox(height: 4),
                                  LevelUpContainer(
                                    height: 62,
                                    child: Text('4 по 12', style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  VideoPlayerCard(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
                                  SizedBox(height: 4),
                                  LevelUpContainer(
                                      height: 62,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('3 по 10-12', style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor)),
                                          Text('1 в отказ', style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor)),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        HorizontalTimer(title: 'Отдых 4 по 12', secondsToCount: 4),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 84,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: DoubleResultsRecording(
                                    weightEditingController: provider.weightFirstController,
                                    repeatsEditingController: provider.repeatsFirstController,
                                    onPlusClicked: () {},
                                    onMinusClicked: () {}),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                flex: 1,
                                child: DoubleResultsRecording(
                                    weightEditingController: provider.weightSecondController,
                                    repeatsEditingController: provider.repeatsSecondController,
                                    onPlusClicked: () {},
                                    onMinusClicked: () {}),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DayMeasurementsResult(title: provider.resultsTitle, result: provider.resultsOptions),
                            ),
                            Expanded(
                              flex: 1,
                              child: DayMeasurementsResult(title: provider.resultsTitle, result: provider.resultsOptions),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class DoubleResultsRecording extends StatelessWidget {
  const DoubleResultsRecording(
      {super.key, required this.weightEditingController, required this.repeatsEditingController, required this.onPlusClicked, required this.onMinusClicked});

  final TextEditingController weightEditingController;
  final TextEditingController repeatsEditingController;

  final Function() onPlusClicked;
  final Function() onMinusClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              LevelUpTextField(
                controller: weightEditingController,
                hintText: 'Вес',
                textSize: 12,
                height: TextFieldHeight.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))],
              ),
              SizedBox(height: 4),
              LevelUpTextField(
                controller: repeatsEditingController,
                hintText: 'Повторы',
                textSize: 12,
                height: TextFieldHeight.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))],
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
        PlusMinusButton(onMinusClicked: onMinusClicked, onPlusClicked: onPlusClicked)
      ],
    );
  }
}
