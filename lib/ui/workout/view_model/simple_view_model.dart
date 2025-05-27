import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:provider/provider.dart';

class SimpleViewModel extends BaseViewModel {
  late TextEditingController weightController;
  late TextEditingController repeatsController;

  SimpleViewModel() : super(GetIt.I<IProfileRepository>()) {
    weightController = TextEditingController();
    repeatsController = TextEditingController();
  }

  @override
  void onResultSelected(BuildContext context, int id) {
    super.onResultSelected(context, id);
    final value = findResultById(context, id);
    if (value != null) {
      weightController.text = value.weight.toString();
      repeatsController.text = value.repeats.toString();
    }
    notifyListeners();
  }

  void onPlusClicked(BuildContext context) {
    if (repeatsController.text.isEmpty || weightController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    try {
      super.addOrUpdateSetResult(context, workout.items.first.id, workout.items.first.itemId, int.parse(repeatsController.text), double.parse(weightController.text).toInt(), 0);
    } on Exception {}
    _resetText();
  }

  void onMinusClicked(BuildContext context) {
    if (super.selectedId == null) {
      _resetText();
    } else {
      super.deleteSetResult(context);
      _resetText();
    }
  }

  void _resetText() {
    weightController.clear();
    repeatsController.clear();
  }

  @override
  void dispose() {
    weightController.dispose();
    repeatsController.dispose();
    super.dispose();
  }
}
