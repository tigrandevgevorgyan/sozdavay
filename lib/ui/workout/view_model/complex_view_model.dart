import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/services/workout/models/workout_response.dart';

class ComplexViewModel extends BaseViewModel {
  late TextEditingController textController;

  bool _isTime = false;

  bool get isTime => _isTime;

  ComplexViewModel(BuildContext context) : super(GetIt.I<IProfileRepository>()) {
    textController = TextEditingController();
    final currentWorkout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    _isTime = currentWorkout.isTime;
  }

  void onPlusClicked(BuildContext context) {
    if (textController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    super.addOrUpdateSetResult(context, workout.items.first.id, !isTime ? int.parse(textController.text) : 0, 0, isTime ? double.parse(textController.text).toInt() : 0);
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

  List<SixResultsDayInfo> generateComplexSixDaysResult(ExerciseInfo exerciseInfo) {
    List<SixResultsDayInfo> result = [];
    for (HistoryInfo history in exerciseInfo.history) {
      List<DayResultInfo> resultStrings = [];
      for (ResultValue value in history.values) {
        resultStrings.add(DayResultInfo(value.id, isTime ? value.time.toString() : value.repeats.toString()));
      }
      result.add(SixResultsDayInfo('${history.day} ${history.date}', resultStrings));
    }
    return result;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
