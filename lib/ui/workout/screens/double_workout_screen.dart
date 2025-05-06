import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
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
  const DoubleWorkoutScreen({super.key, required this.workoutInfo});

  final WorkoutInfo workoutInfo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DoubleViewModel>(
      create: (context) => DoubleViewModel(context, workoutInfo),
      child: Consumer<DoubleViewModel>(builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              WorkoutTopBar(
                isUpdatingFirstExercise: provider.isUpdatingFirstExercise,
                isUpdatingSecondExercise: provider.isUpdatingSecondExercise,
                firstExerciseName: workoutInfo.items.first.name,
                secondExerciseName: workoutInfo.items.last.name,
                onFirstExerciseRefresh: () {},
                onSecondExerciseRefresh: () {},
              ),
              SizedBox(height: 12),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
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
                                        child: Text(provider.getWorkoutString(workoutInfo.items.first), style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor)),
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
                                              Text(provider.getWorkoutString(workoutInfo.items.last), style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor)),
                                            ],
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            HorizontalTimer(title: provider.getRestString(workoutInfo.items.last), secondsToCount: 4),
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
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: max(workoutInfo.items.first.history.length, workoutInfo.items.last.history.length),
                      itemBuilder: (context, index) {
                        final firstHistoryItem = workoutInfo.items.first.history.elementAtOrNull(index);
                        final secondHistoryItem = workoutInfo.items.last.history.elementAtOrNull(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: firstHistoryItem != null
                                    ? DayMeasurementsResult(
                                        title: '${firstHistoryItem.day} ${firstHistoryItem.date}',
                                        results: generateSingleDayResult(firstHistoryItem),
                                        onResultSelected: provider.onFirstIdSelected,
                                      )
                                    : SizedBox.shrink(),
                              ),
                              Expanded(
                                child: secondHistoryItem != null
                                    ? DayMeasurementsResult(
                                        title: '${secondHistoryItem.day} ${secondHistoryItem.date}',
                                        results: generateSingleDayResult(secondHistoryItem),
                                        onResultSelected: provider.onFirstIdSelected,
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<DayResultInfo> generateSingleDayResult(HistoryInfo historyInfo) {
    List<DayResultInfo> result = [];
    for (ResultValue value in historyInfo.values) {
      result.add(DayResultInfo(value.id, '${value.weight}/${value.repeats}'));
    }
    return result;
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
