import 'package:flutter/widgets.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';

class SimpleViewModel extends BaseViewModel {
  late TextEditingController weightController;
  late TextEditingController repeatsController;

  SimpleViewModel(super.workout) {
    weightController = TextEditingController();
    repeatsController = TextEditingController();
  }

  @override
  void onResultSelected(int id) {
    super.onResultSelected(id);
    final value = findResultById(id);
    if (value != null) {
      weightController.text = value.weight.toString();
      repeatsController.text = value.repeats.toString();
    }
    notifyListeners();
  }

  void onPlusClicked(BuildContext context) {
    super.addOrUpdateSetResult(context, workout.items.first.id, int.parse(repeatsController.text), int.parse(weightController.text));
    _resetText();
  }

  void onMinusClicked() {
    if (super.selectedId == null) {
      _resetText();
    } else {
      //execute delete action
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
