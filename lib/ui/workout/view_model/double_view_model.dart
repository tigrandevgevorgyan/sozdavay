import 'package:flutter/cupertino.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:provider/provider.dart';

class DoubleViewModel extends BaseViewModel {
  late TextEditingController repeatsFirstController;
  late TextEditingController repeatsSecondController;

  late TextEditingController weightFirstController;
  late TextEditingController weightSecondController;

  bool _isUpdatingFirstExercise = false;

  bool get isUpdatingFirstExercise => _isUpdatingFirstExercise;

  bool _isUpdatingSecondExercise = false;

  bool get isUpdatingSecondExercise => _isUpdatingSecondExercise;

  DoubleViewModel(BuildContext context) {
    repeatsFirstController = TextEditingController();
    repeatsSecondController = TextEditingController();
    weightFirstController = TextEditingController();
    weightSecondController = TextEditingController();
  }

  void updateFirstExercise() {
    _isUpdatingFirstExercise = true;
    notifyListeners();
    //Provider.of(context, listen: false).
  }

  void onFirstIdSelected(BuildContext context, int id) {
    super.onResultSelected(context, id);
    final value = findResultById(context, id);
    if (value != null) {
      weightFirstController.text = value.weight.toString();
      repeatsFirstController.text = value.repeats.toString();
    }
    notifyListeners();
  }

  void onSecondIdSelected(BuildContext context, int id) {
    super.onResultSelected(context, id);
    final value = findResultById(context, id);
    if (value != null) {
      weightSecondController.text = value.weight.toString();
      repeatsSecondController.text = value.repeats.toString();
    }
    notifyListeners();
  }

  void onFirstPlusClicked(BuildContext context) {
    if (repeatsFirstController.text.isEmpty || weightFirstController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    super.addOrUpdateSetResult(context, workout.items.first.id, int.parse(repeatsFirstController.text), double.parse(weightFirstController.text).toInt(), 0);
    _resetText();
  }

  void onSecondPlusClicked(BuildContext context) {
    if (repeatsSecondController.text.isEmpty || weightSecondController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    super.addOrUpdateSetResult(context, workout.items.last.id, int.parse(repeatsSecondController.text), double.parse(weightSecondController.text).toInt(), 0);
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
    weightFirstController.clear();
    repeatsFirstController.clear();
    weightSecondController.clear();
    repeatsSecondController.clear();
  }

  @override
  void dispose() {
    repeatsFirstController.dispose();
    repeatsSecondController.dispose();
    weightFirstController.dispose();
    weightSecondController.dispose();
    super.dispose();
  }
}
