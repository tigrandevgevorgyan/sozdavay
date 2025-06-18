import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/repositories/workout_repository/workout_repository.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/simple_results_widget.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/misc_utils.dart';
import 'package:level_up/utils/result.dart';
import 'package:level_up/utils/weight_formatters.dart';
import 'package:provider/provider.dart';

import '../../../data/services/workout/models/workout_comment.dart';

class BaseViewModel extends ChangeNotifier {
  BaseViewModel(this.profileRepository, this.workoutRepository);

  final IProfileRepository profileRepository;

  final IWorkoutRepository workoutRepository;

  bool _isUpdatingHistory = false;

  bool get isUpdatingHistory => _isUpdatingHistory;

  bool isUpdatingExercise = false;

  int? _selectedId;

  int? get selectedId => _selectedId;

  List<WorkoutInfo>? _workout;

  set workout(List<WorkoutInfo>? value) {
    _workout = value;
  }

  set selectedId(int? value) {
    _selectedId = value;
    notifyListeners();
  }


  void onResultSelected(BuildContext context, int id) {
    _selectedId = id;
    notifyListeners();
  }

  void deselectResult() {
    _selectedId = null;
  }

  Future<void> changeExercise(BuildContext context, {int? exerciseIndex, required bool second}) async {
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    if (exerciseIndex == null) {
      // if id is provided, then ui logic is handled somewhere else
      isUpdatingExercise = true;
      notifyListeners();
    }
    await Provider.of<WorkoutViewModel>(context, listen: false).updateExercise(context, second, exerciseIndex ?? workout.index);
    if (exerciseIndex == null) {
      isUpdatingExercise = false;
      notifyListeners();
    }
  }

  void addOrUpdateSetResult(BuildContext context, int exerciseId, int itemId, int repeats, double weight, int time, String date) async {
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final viewModel = Provider.of<WorkoutViewModel>(context, listen: false);

      if (_selectedId != null) {
        await viewModel.updateSetResult(context, _selectedId!, exerciseId, weight, repeats, 1, time);
      } else {
        await viewModel.addSetResult(context, exerciseId, itemId, weight, repeats, 1, time, date);
      }
    } finally {
      notifyListeners();
      deselectResult();
    }
  }

  void deleteSetResult(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_selectedId != null) {
      await Provider.of<WorkoutViewModel>(context, listen: false).deleteSetResult(context, selectedId!);
      notifyListeners();
    }
    deselectResult();
  }

  void onNotesClicked(BuildContext context) async {
    final profileResult = await profileRepository.getProfile();
    switch (profileResult) {
      case Ok<UserProfileExtendedResponse>():
        final now = DateTime.now();
        String dayName = '${weekDays[now.weekday]} ${DateFormat('dd.MM.yy').format(now)}';
        final params = TextEditingScreenParams(title: 'ЗАМЕТКА $dayName', initialText: profileResult.value.data.measurements ?? "", onTextUpdated: _updateRecords);
        if (context.mounted) {
          GoRouter.of(context).push(LevelUpRouter.textEditingPath, extra: params);
        }
      case Error<UserProfileExtendedResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, 'Не удаётся загрузить профиль');
        }
    }
  }

  Future<Result<bool>> _updateRecords(String records) async {
    final result = await profileRepository.updateMeasurements(records);
    switch (result) {
      case Ok<UserProfileShortResponse>():
        await profileRepository.reloadProfile();
        return Result.ok(true);
      case Error<UserProfileShortResponse>():
        return Result.error(result.error);
    }
  }

  void onWorkoutNotesClicked(BuildContext context, HistoryInfo history) async {
    final parsed = DateTime.parse(history.date);
    final dayName = '${history.day} ${DateFormat('dd.MM.yy').format(parsed)}';

    final params = TextEditingScreenParams(
      title: 'ЗАМЕТКА $dayName',
      initialText: history.comment ?? '',
      onTextUpdated: (newText) async {
        _updateNoteComment(history.itemId, newText);
        return Result.ok(true);
      },
    );

    if (context.mounted) {
      GoRouter.of(context).push(LevelUpRouter.textEditingPath, extra: params);
    }
  }


  void _updateNoteComment(int itemId, String newComment) async {
    bool updated = false;
    for (final workout in _workout ?? []) {
      for (final exercise in workout.items) {
        final history = exercise.history.firstWhereOrNull(
              (h) => h.itemId == itemId,
        );
        if (history != null) {
          final updatedHistory = HistoryInfo(history.day, history.date, history.values, newComment, history.itemId);
          final index = exercise.history.indexOf(history);
          exercise.history[index] = updatedHistory;
          updated = true;
          notifyListeners();
          break;
        }
      }
      if (updated) break;
    }
    try {
      await workoutRepository.updateWorkoutComment(
        itemId,
        WorkoutComment(comment: newComment),
      );
    } catch (e) {
      debugPrint('Ошибка при отправке комментария: $e');
    }
  }

  ResultValue? findResultById(BuildContext context, int id) {
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    for (ExerciseInfo exerciseInfo in workout.items) {
      for (HistoryInfo historyInfo in exerciseInfo.history) {
        final result = historyInfo.values
            .where(
              (value) => value.id == id,
            )
            .firstOrNull;
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  List<SimpleResultsDayInfo> generateSimpleDaysResult(ExerciseInfo exerciseInfo) {
    List<SimpleResultsDayInfo> result = [];
    for (HistoryInfo history in exerciseInfo.history) {
      List<DayResultInfo> resultStrings = [];
      String? title;
      for (ResultValue value in history.values) {
        title = value.date.toWeekdayWithDate();
        resultStrings.add(DayResultInfo(value.id, '${DoubleFormatter(value.weight).formatDouble()}/${value.repeats}'));
      }
      result.add(SimpleResultsDayInfo(title ?? '${history.day} ${history.date}', resultStrings, history),
      );
    }
    return result;
  }

  String getRestString(ExerciseInfo exerciseInfo) {
    final restSec = exerciseInfo.restSeconds?.abs();

    if (restSec == null) {
      return 'Без отдыха';
    }

    final minutes = restSec ~/ 60;
    final seconds = restSec % 60;

    if (minutes > 0 && seconds > 0) {
      return 'Отдых $minutes мин $seconds сек';
    } else if (minutes > 0) {
      return 'Отдых $minutes мин';
    } else {
      return 'Отдых $seconds сек';
    }
  }

  String getWorkoutString(ExerciseInfo exerciseInfo) {
    if (exerciseInfo.sets.isEmpty) return '';

    return exerciseInfo.sets
        .map((set) {
          final setsCount = set.setsCount?.abs() ?? 0;
          final from = set.repeatsFrom?.abs();
          final to = set.repeatsTo?.abs();
          final isHard = (set.asMuchAsPossible ?? 0) == 1;

          if (setsCount == 0 || ((from ?? 0) == 0 && (to ?? 0) == 0)) {
            return '';
          }

          String repeatsText;
          if (from != null && to != null) {
            repeatsText = from == to || to == 0 ? '$from' : '$from–$to';
          } else if (from != null) {
            repeatsText = '$from';
          } else if (to != null) {
            repeatsText = '$to';
          } else {
            repeatsText = '-';
          }

          final hardText = isHard ? '\n1 в отказ' : '';

          return '$setsCount по $repeatsText$hardText';
        })
        .where((s) => s.isNotEmpty)
        .join('\n\n');
  }

  String getRangeString(int minValue, int maxValue) {
    if (minValue != 0 && maxValue != 0) {
      return '$minValue - $maxValue';
    } else {
      return minValue == 0 ? maxValue.toString() : minValue.toString();
    }
  }
}
