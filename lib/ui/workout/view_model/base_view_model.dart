import 'package:flutter/cupertino.dart';
import 'package:level_up/data/services/workout/models/workout_response.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';
import 'package:provider/provider.dart';

class BaseViewModel extends ChangeNotifier {
  BaseViewModel();

  bool _isUpdatingHistory = false;

  bool get isUpdatingHistory => _isUpdatingHistory;

  bool isUpdatingExercise = false;

  int? _selectedId;

  int? get selectedId => _selectedId;

  void onResultSelected(BuildContext context, int id) {
    _selectedId = id;
  }

  void deselectResult() {
    _selectedId = null;
  }

  void changeExercise(BuildContext context) async {
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    isUpdatingExercise = true;
    notifyListeners();
    await Provider.of<WorkoutViewModel>(context, listen: false).updateExercise(context, workout.items.first.id);
    isUpdatingExercise = false;
    notifyListeners();
  }

  void addOrUpdateSetResult(BuildContext context, int exerciseId, int repeats, int weight) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_selectedId != null) {
      _isUpdatingHistory = true;
      notifyListeners();
      await Provider.of<WorkoutViewModel>(context, listen: false).updateSetResult(context, selectedId!, exerciseId, weight, repeats, 1, 1);
      _isUpdatingHistory = false;
      notifyListeners();
    } else {
      _isUpdatingHistory = true;
      notifyListeners();
      await Provider.of<WorkoutViewModel>(context, listen: false).addSetResult(context, exerciseId, weight, repeats, 1, 1);
      _isUpdatingHistory = false;
      notifyListeners();
    }
    deselectResult();
  }

  void deleteSetResult(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_selectedId != null) {
      _isUpdatingHistory = true;
      notifyListeners();
      await Provider.of<WorkoutViewModel>(context, listen: false).deleteSetResult(context, selectedId!);
      _isUpdatingHistory = false;
      notifyListeners();
    }
    deselectResult();
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

  List<SixResultsDayInfo> generateSixDaysResult(ExerciseInfo exerciseInfo) {
    List<SixResultsDayInfo> result = [];
    for (HistoryInfo history in exerciseInfo.history) {
      List<DayResultInfo> resultStrings = [];
      for (ResultValue value in history.values) {
        resultStrings.add(DayResultInfo(value.id, '${value.weight}/${value.repeats}'));
      }
      result.add(SixResultsDayInfo('${history.day} ${history.date}', resultStrings));
    }
    return result;
  }

  String getRestString(ExerciseInfo exerciseInfo) {
    if (exerciseInfo.minRest == 0 && exerciseInfo.maxRest == 0) {
      return 'Без отдыха';
    }
    if (exerciseInfo.minRest != 0 && exerciseInfo.maxRest == 0) {
      return 'Отдых от ${exerciseInfo.maxRest} мин';
    }
    if (exerciseInfo.minRest == 0 && exerciseInfo.maxRest != 0) {
      return 'Отдых до ${exerciseInfo.maxRest} мин';
    }
    if (exerciseInfo.minRest != 0 && exerciseInfo.maxRest != 0) {
      return 'Отдых ${exerciseInfo.minRest} - ${exerciseInfo.maxRest} мин';
    }
    return '';
  }

  String getWorkoutString(ExerciseInfo exerciseInfo) {
    String result = '';
    if (exerciseInfo.minSets != 0 || exerciseInfo.maxSets != 0) {
      result += getRangeString(exerciseInfo.minSets, exerciseInfo.maxSets);
      result += ' по ';
    }
    result += getRangeString(exerciseInfo.minRepeats, exerciseInfo.maxRepeats);
    if (exerciseInfo.lastSetsFull) {
      result += '\n1 в отказ';
    }

    return result;
  }

  String getRangeString(int minValue, int maxValue) {
    if (minValue != 0 && maxValue != 0) {
      return '$minValue - $maxValue';
    } else {
      return minValue == 0 ? maxValue.toString() : minValue.toString();
    }
  }
}
