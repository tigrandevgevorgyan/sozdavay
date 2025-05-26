import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/workout/view_model/simple_view_model.dart';
import 'package:level_up/ui/workout/widgets/level_up_icon_button.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';
import 'package:level_up/ui/workout/widgets/square_timer.dart';
import 'package:level_up/ui/workout/widgets/video_player_card.dart';
import 'package:level_up/ui/workout/widgets/workout_top_bar.dart';
import 'package:provider/provider.dart';

class SimpleWorkoutScreen extends StatelessWidget {
  const SimpleWorkoutScreen({super.key, required this.workoutInfo});

  final WorkoutInfo workoutInfo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SimpleViewModel(),
      child: Consumer<SimpleViewModel>(builder: (context, provider, _) {
        return Column(
          children: [
            WorkoutTopBar(
              isUpdatingFirstExercise: provider.isUpdatingExercise,
              firstExerciseName: workoutInfo.items.first.name,
              onFirstExerciseRefresh: () => provider.changeExercise(context),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: VideoPlayerCard(videoUrl: 'https://storage.yandexcloud.net/testlevelup/video_2025-04-24_23-19-14.mp4'),
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: LevelUpContainer(
                                          child: Text(provider.getWorkoutString(workoutInfo.items.first), style: Style.ablation14w800.copyWith(color: AppColors.primaryTextColor)),
                                        )),
                                    SizedBox(height: 4),
                                    Expanded(
                                        flex: 1,
                                        child: LevelUpContainer(
                                          child: Column(
                                            children: [
                                              SquareTimer(
                                                title: provider.getRestString(workoutInfo.items.first),
                                                secondsDuration: workoutInfo.items.first.restSeconds,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 46,
                        child: Row(children: [
                          LevelUpIconButton(iconAsset: Assets.minusIcon, onClick: () => provider.onMinusClicked(context)),
                          SizedBox(width: 4),
                          Expanded(
                            flex: 1,
                            child: LevelUpTextField(
                              controller: provider.weightController,
                              hintText: 'Вес',
                              textSize: 12,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]|\.'))],
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            flex: 1,
                            child: LevelUpTextField(
                              controller: provider.repeatsController,
                              hintText: 'Повторы',
                              textSize: 12,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                            ),
                          ),
                          SizedBox(width: 4),
                          LevelUpIconButton(iconAsset: Assets.plusIcon, onClick: () => provider.onPlusClicked(context)),
                        ]),
                      ),
                      SizedBox(height: 16),
                      provider.isUpdatingHistory
                          ? Center(child: LevelUpLoader())
                          : SixResultsWidget(
                              selectedId: provider.selectedId,
                              results: provider.generateSixDaysResult(workoutInfo.items.first),
                              onResultSelected: (id) => provider.onResultSelected(context, id),
                            ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
