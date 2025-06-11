import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:provider/provider.dart';

class DoubleViewModel extends BaseViewModel {
  late TextEditingController repeatsFirstController;
  late TextEditingController repeatsSecondController;

  late TextEditingController weightFirstController;
  late TextEditingController weightSecondController;

  bool _isUpdatingSecondExercise = false;

  bool get isUpdatingSecondExercise => _isUpdatingSecondExercise;

  DoubleViewModel(BuildContext context) : super(GetIt.I<IProfileRepository>()) {
    repeatsFirstController = TextEditingController();
    repeatsSecondController = TextEditingController();
    weightFirstController = TextEditingController();
    weightSecondController = TextEditingController();
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
    final now = DateTime.now().toIso8601String();
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    super.addOrUpdateSetResult(
        context, workout.items.first.id, workout.items.first.itemId, int.parse(repeatsFirstController.text), double.parse(weightFirstController.text).toInt(), 0, now);
    _resetText();
  }

  void onSecondPlusClicked(BuildContext context) {
    if (repeatsSecondController.text.isEmpty || weightSecondController.text.isEmpty) {
      return;
    }
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    final now = DateTime.now().toIso8601String();
    super.addOrUpdateSetResult(
        context, workout.items.last.id, workout.items.last.itemId, int.parse(repeatsSecondController.text), double.parse(weightSecondController.text).toInt(), 0, now);
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

  void onChangeSecondExercise(BuildContext context) async {
    _isUpdatingSecondExercise = true;
    notifyListeners();
    final workout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    await changeExercise(context, exerciseIndex: workout.index, second: true);
    _isUpdatingSecondExercise = false;
    notifyListeners();
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
