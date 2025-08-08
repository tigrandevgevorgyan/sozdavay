import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/repositories/workout_repository/workout_repository.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/workout/screens/complex_workout_screen.dart';
import 'package:level_up/ui/workout/screens/double_workout_screen.dart';
import 'package:level_up/ui/workout/screens/simple_workout_screen.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:level_up/ui/workout/widgets/error_placeholder.dart';
import 'package:provider/provider.dart';

import '../../../routing/levelup_router.dart';
import '../../../utils/timer_state_manager.dart';

class WorkoutBaseScreen extends StatefulWidget {
  const WorkoutBaseScreen({super.key});

  @override
  State<WorkoutBaseScreen> createState() => _WorkoutBaseScreenState();
}

class _WorkoutBaseScreenState extends State<WorkoutBaseScreen> {
  int index = 0;
  late final int dayIndex;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      dayIndex = GoRouterState.of(context).extra as int;
      _didInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider<WorkoutViewModel>(
        create: (BuildContext context) => WorkoutViewModel(context, GetIt.I<IWorkoutRepository>(), dayIndex: dayIndex),
        child: Consumer<WorkoutViewModel>(builder: (context, provider, __) {
          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              if (didPop) {
                provider.onHomeClicked();
                if (context.mounted) {
                  GoRouter.of(context).pushReplacement(LevelUpRouter.homePath);
                }
              }
            },
              child: Scaffold(
                appBar: AppBar(backgroundColor: AppColors.backgroundContentColor, toolbarHeight: 0),
                backgroundColor: AppColors.backgroundColor,
                body: SafeArea(
                  child: provider.isLoading || provider.isWorkoutEmpty
                      ? Center(child: LevelUpLoader())
                      : provider.hasError
                    ? ErrorPlaceholder(
                      onTap: (){
                        provider.init(context);
                      },
                  )
                      : provider.finishError
                      ? ErrorPlaceholder(
                    onTap: () {
                      provider.finishWorkout(context);
                    },
                  )
                      : Column(
                          children: [
                            Expanded(
                              child: _getScreenByWorkout(provider.currentWorkout),
                            ),
                            BottomBar(
                              onLeftArrowClicked: provider.onPreviousClicked,
                              onRightArrowClicked: () => provider.onNextClicked(context),
                              onHomeClicked: () {
                                if (context.mounted) {
                                  GoRouter.of(context).pushReplacement(LevelUpRouter.homePath);
                                }
                                provider.onHomeClicked();
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                ),
              ),
            );
        }),
      ),
    );
  }

  Widget _getScreenByWorkout(WorkoutInfo workout) {
    if (workout.isComplex) {
      return ComplexWorkoutScreen(workoutInfo: workout);
    }
    if (workout.isDouble) {
      return DoubleWorkoutScreen(workoutInfo: workout);
    }
    return SimpleWorkoutScreen(workoutInfo: workout);
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.onRightArrowClicked, required this.onLeftArrowClicked, required this.onHomeClicked});

  final Function() onRightArrowClicked;
  final Function() onLeftArrowClicked;
  final Function() onHomeClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      height: 40,
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onLeftArrowClicked,
            child: SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  Assets.leftArrowIcon,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onHomeClicked,
            child: SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  Assets.homeIcon,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onRightArrowClicked,
            child: SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  Assets.rightArrowIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
