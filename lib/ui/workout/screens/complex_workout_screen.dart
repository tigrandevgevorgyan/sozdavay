import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/workout/view_model/complex_view_model.dart';
import 'package:level_up/ui/workout/widgets/level_up_icon_button.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';
import 'package:level_up/ui/workout/widgets/video_player_card.dart';
import 'package:level_up/ui/workout/widgets/workout_top_bar.dart';
import 'package:provider/provider.dart';

class ComplexWorkoutScreen extends StatelessWidget {
  const ComplexWorkoutScreen({super.key, required this.workoutInfo});

  final WorkoutInfo workoutInfo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ComplexViewModel(context),
      child: Consumer<ComplexViewModel>(builder: (context, provider, _) {
        return Column(
          children: [
            WorkoutTopBar(isUpdatingFirstExercise: false, firstExerciseName: 'Комлпекс номер 1', onFirstExerciseRefresh: () {}),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      SizedBox(
                        height: 259,
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 16,
                              child: VideoPlayerCard(videoUrl: 'https://storage.yandexcloud.net/testlevelup/video_2025-04-24_23-19-14.mp4'),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              flex: 1,
                              child: GridView.builder(
                                itemCount: 8,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 1),
                                itemBuilder: (context, index) => VideoPreview(),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      LevelUpContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            workoutInfo.items.first.description ?? '',
                            style: Style.outfit16w300.copyWith(color: AppColors.primaryTextColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      provider.isTime
                          ? SizedBox(
                              height: 46,
                              child: Row(
                                children: [
                                  LevelUpIconButton(iconAsset: Assets.minusIcon, onClick: () {}),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: LevelUpTextField(
                                      controller: provider.textController,
                                      hintText: 'время',
                                      textSize: 15,
                                      keyboardType: TextInputType.datetime,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  LevelUpIconButton(iconAsset: Assets.plusIcon, onClick: () {}),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 46,
                              child: Row(
                                children: [
                                  LevelUpIconButton(iconAsset: Assets.minusIcon, onClick: () {}),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: LevelUpTextField(
                                      controller: provider.textController,
                                      hintText: 'раунды',
                                      textSize: 15,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  LevelUpIconButton(iconAsset: Assets.plusIcon, onClick: () {}),
                                ],
                              ),
                            ),
                      SizedBox(height: 16),
                      SixResultsWidget(
                        results: provider.generateSixDaysResult(workoutInfo.items.first),
                        onResultSelected: (id) {},
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

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(Assets.videoPreview),
    );
  }
}
