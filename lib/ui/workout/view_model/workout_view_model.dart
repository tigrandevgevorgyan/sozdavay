import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/workout_repository/workout_repository.dart';
import 'package:level_up/data/services/common_models/is_completed_response.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';
import '../../../utils/misc_utils.dart';

class WorkoutViewModel extends ChangeNotifier {
  final int dayIndex;

  WorkoutViewModel(BuildContext context, this.workoutRepository, {required this.dayIndex}) {
    init(context);
  }

  final IWorkoutRepository workoutRepository;
  int index = 0;
  List<WorkoutInfo>? _workout;
  int _workoutId = -1;
  bool _isLoading = true;
  bool hasError = false;

  bool get isLoading => _isLoading;

  WorkoutInfo get currentWorkout => _workout![index];

  bool get isWorkoutEmpty => _workout != null && _workout!.isEmpty;

  void init(BuildContext context) async {
    _isLoading = true;
    hasError = false;
    notifyListeners();
    final result = await workoutRepository.loadWorkout(dayIndex: dayIndex);
    _isLoading = false;
    switch (result) {
      case Ok<WorkoutResponse>():
        _workoutId = result.value.workoutId ?? -1;
        if (result.value.data.isEmpty) {
          if (context.mounted) {
            GoRouter.of(context).pop();
            ErrorUtils.showError(context, 'Отсутствуют упражнения!');
          }
        }
        _workout = result.value.data;
        notifyListeners();
      case Error<WorkoutResponse>():
        if (context.mounted) {
          hasError = true;
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
    notifyListeners();
  }

  Future<void> updateExercise(BuildContext context, bool second, int index) async {
    final result = await workoutRepository.changeExercise(index, second);
    _isLoading = false;
    switch (result) {
      case Ok<List<WorkoutInfo>>():
        _workout = result.value;
        notifyListeners();
      case Error<List<WorkoutInfo>>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
          notifyListeners();
        }
    }
  }

  void deleteWorkout() async {
    final result = await workoutRepository.deleteWorkout(_workoutId);
    _isLoading = false;
    switch (result) {
      case Ok<IsCompletedResponse>():
        break;
      case Error<IsCompletedResponse>():
        break;
    }
  }

  Future<void> addSetResult(BuildContext context, int exerciseId, int itemId, double weight, int repeats, int difficult, int time, String date) async {
    if (_workout == null) return;

    final newResult = ResultValue(DateTime.now().millisecondsSinceEpoch, weight.toDouble(), repeats, difficult, time, date);

    final today = getToday();
    final weekday = getWeekday();

    for (final workout in _workout!) {
      for (final exercise in workout.items) {
        if (exercise.id != exerciseId) continue;

        final existing = exercise.history.firstWhere(
          (h) => h.date == today,
          orElse: () => HistoryInfo(weekday, today, [], '', DateTime.now().millisecondsSinceEpoch),
        );

        existing.values.insert(0, newResult);

        if (!exercise.history.contains(existing)) {
          exercise.history.insert(0, existing);
        }

        notifyListeners();
        break;
      }
    }

    final result = await workoutRepository.addSetResult(exerciseId, itemId, weight, repeats, difficult, time, date);

    if (result case Error()) {
      if (context.mounted) {
        ErrorUtils.showError(context, result.error.getErrorMessage());
      }
    }
  }

  Future<void> updateSetResult(BuildContext context, int id, int exerciseId, double weight, int repeats, int difficult, int time) async {
    if (_workout == null) return;

    for (final workout in _workout!) {
      for (final exercise in workout.items) {
        if (exercise.id != exerciseId) continue;

        for (int h = 0; h < exercise.history.length; h++) {
          final history = exercise.history[h];

          final i = history.values.indexWhere((v) => v.id == id);
          if (i == -1) continue;

          final updatedValue = history.values[i].copyWith(
            weight: weight.toDouble(),
            repeats: repeats,
            time: time,
          );

          final updatedValues = [
            ...history.values.sublist(0, i),
            updatedValue,
            ...history.values.sublist(i + 1),
          ];

          exercise.history[h] = history.copyWith(values: updatedValues);

          notifyListeners();
        }
      }
    }
    final result = await workoutRepository.updateSetResult(id, exerciseId, weight, repeats, difficult, time);

    if (result case Error()) {
      if (context.mounted) {
        ErrorUtils.showError(context, result.error.getErrorMessage());
      }
    }
  }

  Future<void> deleteSetResult(BuildContext context, int id) async {
    if (_workout == null) return;

    for (final workout in _workout!) {
      for (final exercise in workout.items) {
        for (int i = exercise.history.length - 1; i >= 0; i--) {
          final history = exercise.history[i];
          history.values.removeWhere((v) => v.id == id);
          if (history.values.isEmpty) {
            exercise.history.removeAt(i);
          }
        }
      }
    }

    notifyListeners();

    final result = await workoutRepository.deleteSetResult(id);

    if (result case Error()) {
      if (context.mounted) {
        ErrorUtils.showError(context, result.error.getErrorMessage());
      }
    }
  }

  void onNextClicked(BuildContext context) {
    index++;
    if (index >= _workout!.length) {
      index = _workout!.length - 1;
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

  void _finishWorkout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    await workoutRepository.sendOfflineOperations();
    final result = await workoutRepository.finishWorkout();
    _isLoading = false;
    notifyListeners();
    switch (result) {
      case Ok<void>():
        if (context.mounted) {
          GoRouter.of(context).pop(true);
        }
      case Error<void>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  void _showFinalDialog(BuildContext screenContext) {
    showDialog(
      context: screenContext,
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
                    LevelUpButton(
                        text: 'Закончить тренировку',
                        buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
                        onClick: () {
                          GoRouter.of(context).pop();
                          _finishWorkout(screenContext);
                        }),
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
}
