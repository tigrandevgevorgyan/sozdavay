import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/simple_results_widget.dart';
import 'package:level_up/utils/misc_utils.dart';
import 'package:provider/provider.dart';
import 'package:level_up/utils/formatters.dart';
import '../../../data/repositories/workout_repository/workout_repository.dart';
import '../../../data/services/workout/models/workout_response.dart';

class ComplexViewModel extends BaseViewModel {
  late TextEditingController textController;

  bool _isTime = false;

  bool get isTime => _isTime;

  final BuildContext _context;

  ComplexViewModel(BuildContext context)
      : _context = context,
        super(GetIt.I<IProfileRepository>(), GetIt.I<IWorkoutRepository>()) {
    textController = TextEditingController();
    final currentWorkout = Provider.of<WorkoutViewModel>(_context, listen: false).currentWorkout;
    _isTime = currentWorkout.isTime;
  }

  ExerciseInfo get currentExercise {
    final workout = Provider.of<WorkoutViewModel>(_context, listen: false).currentWorkout;
    return workout.items.first;
  }

  void onPlusClicked(BuildContext context) {
    if (textController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    final now = DateTime.now().toIso8601String();
    super.addOrUpdateSetResult(
        context, workout.items.first.id, workout.items.first.itemId, !isTime ? int.parse(textController.text) : 0, 0, isTime ? double.parse(textController.text) : 0, now);
    textController.clear();
    notifyListeners();
  }

  void onMinusClicked(BuildContext context) {
    if (super.selectedId == null) {
      textController.clear();
    } else {
      super.deleteSetResult(context);
      textController.clear();
    }
    notifyListeners();
  }

  @override
  void onResultSelected(BuildContext context, int id) {
    super.onResultSelected(context, id);

    final result = findResultById(context, id);
    if (result != null) {
      textController.text = isTime ? result.time.toString() : result.repeats.toString();
      notifyListeners();
    }
  }

  List<SimpleResultsDayInfo> generateComplexSixDaysResult() {
    final exerciseInfo = currentExercise;

    List<SimpleResultsDayInfo> result = [];
    String? title;
    for (HistoryInfo history in exerciseInfo.history) {
      List<DayResultInfo> resultStrings = [];
      for (ResultValue value in history.values.reversed) {
        resultStrings.add(DayResultInfo(
          value.id,
          isTime ? DoubleFormatter(value.time).formatDouble() : value.repeats.toString(),
        ));
        title = value.date.toWeekdayWithDate();
      }
      result.add(SimpleResultsDayInfo(title ?? '${history.day} ${history.date}', resultStrings, history));
    }
    return result;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
