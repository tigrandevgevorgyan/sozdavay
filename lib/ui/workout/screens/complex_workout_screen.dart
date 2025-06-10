import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_container.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/workout/view_model/complex_view_model.dart';
import 'package:level_up/ui/workout/widgets/empty_video_placeholder.dart';
import 'package:level_up/ui/workout/widgets/level_up_icon_button.dart';
import 'package:level_up/ui/workout/widgets/simple_results_widget.dart';
import 'package:level_up/ui/workout/widgets/video_player_card.dart';
import 'package:level_up/ui/workout/widgets/workout_top_bar.dart';
import 'package:provider/provider.dart';

class ComplexWorkoutScreen extends StatefulWidget {
  const ComplexWorkoutScreen({super.key, required this.workoutInfo});

  final WorkoutInfo workoutInfo;

  @override
  State<ComplexWorkoutScreen> createState() => _ComplexWorkoutScreenState();
}

class _ComplexWorkoutScreenState extends State<ComplexWorkoutScreen> {
  int _currentVideoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sideHorizontalPadding = 12.0;
    final minHorizontalPadding = 4.0;
    return ChangeNotifierProvider(
      create: (context) => ComplexViewModel(context),
      child: Consumer<ComplexViewModel>(builder: (context, provider, _) {
        return Column(
          children: [
            WorkoutTopBar(
                isUpdatingFirstExercise: provider.isUpdatingExercise,
                firstExerciseName: widget.workoutInfo.items.first.name,
                onFirstExerciseRefresh: () => provider.changeExercise(context)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: sideHorizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 16,
                              child: widget.workoutInfo.items.first.getVideoLinks().isNotEmpty
                                  ? VideoPlayerCard(videoUrl: widget.workoutInfo.items.first.getVideoLinks()[_currentVideoIndex])
                                  : EmptyVideoPlaceholder(),
                            ),
                            SizedBox(width: minHorizontalPadding),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: (MediaQuery.of(context).size.width - (sideHorizontalPadding * 2) - minHorizontalPadding) / 2 * 16 / 9,
                                child: GridView.builder(
                                  itemCount: widget.workoutInfo.items.first.getVideoLinks().length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 9 / 16),
                                  itemBuilder: (context, index) => GestureDetector(
                                    onTap: () => setState(() {
                                      _currentVideoIndex = index;
                                    }),
                                    child: VideoPlayerCard(
                                      videoUrl: widget.workoutInfo.items.first.getVideoLinks()[index],
                                      isUIVisible: false,
                                    ),
                                  ),
                                ),
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
                            widget.workoutInfo.items.first.description ?? '',
                            style: Style.outfit16w300.copyWith(color: AppColors.primaryTextColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 46,
                        child: Row(
                          children: [
                            LevelUpIconButton(iconAsset: Assets.minusIcon, onClick: () => provider.onMinusClicked(context)),
                            SizedBox(width: 4),
                            Expanded(
                              child: LevelUpTextField(
                                controller: provider.textController,
                                hintText: provider.isTime ? 'время' : 'раунды',
                                textSize: 15,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                              ),
                            ),
                            SizedBox(width: 4),
                            LevelUpIconButton(iconAsset: Assets.plusIcon, onClick: () => provider.onPlusClicked(context)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      provider.isUpdatingHistory
                          ? Center(child: LevelUpLoader())
                          : SimpleResultsWidget(
                              selectedId: provider.selectedId,
                              results: provider.generateComplexSixDaysResult(widget.workoutInfo.items.first),
                              onResultSelected: (id) => provider.onResultSelected(context, id),
                              onNotesClicked: () => provider.onNotesClicked(context),
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
