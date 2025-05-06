import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/workout_repository/workout_repository.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class WorkoutViewModel extends ChangeNotifier {
  WorkoutViewModel(BuildContext context, this.workoutRepository) {
    _init(context);
  }

  final IWorkoutRepository workoutRepository;
  int index = 0;
  List<WorkoutInfo>? _workout;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  WorkoutInfo get currentWorkout => _workout![index];

  void _init(BuildContext context) async {
    _isLoading = true;
    final result = await workoutRepository.loadWorkout();
    _isLoading = false;
    switch (result) {
      case Ok<List<WorkoutInfo>>():
        _workout = result.value;
        notifyListeners();
      case Error<List<WorkoutInfo>>():
        if (context.mounted) {
          notifyListeners();
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  Future<void> updateExercise(BuildContext context, int id) async {
    final result = await workoutRepository.changeExercise(id, _isSecondWorkout(id));
    _isLoading = false;
    switch (result) {
      case Ok<List<WorkoutInfo>>():
        _workout = result.value;
        notifyListeners();
      case Error<List<WorkoutInfo>>():
        if (context.mounted) {
          notifyListeners();
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  Future<void> addSetResult(BuildContext context, int exerciseId, int weight, int repeats, int difficult, int time) async {
    final result = await workoutRepository.addSetResult(exerciseId, weight, repeats, difficult, time);
    switch (result) {
      case Ok<List<WorkoutInfo>>():
        _workout = result.value;
        notifyListeners();
      case Error<List<WorkoutInfo>>():
        if (context.mounted) {
          notifyListeners();
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  void onNextClicked(BuildContext context) {
    index++;
    if (index >= _workout!.length) {
      index = _workout!.length - 1;
    }
    if (index > 2) {
      _showFinalDialog(context);
    }
    notifyListeners();
  }

  void onPreviousClicked() {
    index--;
    if (index < 0) {
      index = 0;
    }
    notifyListeners();
  }

  void _showFinalDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierColor: Colors.black.withOpacity(0.5), // Semi-transparent barrier
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF141414),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF3C3C3C), width: 0.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30),
                    Text('Последнее упражнение', style: Style.ablation18w900.copyWith(color: Colors.white)),
                    SizedBox(height: 24),
                    LevelUpButton(text: 'Закончить тренировку', buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium), onClick: () {}),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(onTap: () => GoRouter.of(context).pop(), child: Text('Продолжить', style: Style.ablation14w900.copyWith(color: Colors.white))),
                    ),
                    SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSecondWorkout(int id) {
    if (_workout == null) {
      return false;
    }
    for (WorkoutInfo workout in _workout!) {
      if (!workout.isDouble) {
        continue;
      }
      return workout.items.last.id == id;
    }
    return false;
  }
}
