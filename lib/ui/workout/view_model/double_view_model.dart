import 'package:flutter/cupertino.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';

class DoubleViewModel extends BaseViewModel {
  late TextEditingController repeatsFirstController;
  late TextEditingController repeatsSecondController;

  late TextEditingController weightFirstController;
  late TextEditingController weightSecondController;

  bool _isUpdatingFirstExercise = false;

  bool get isUpdatingFirstExercise => _isUpdatingFirstExercise;

  bool _isUpdatingSecondExercise = false;

  bool get isUpdatingSecondExercise => _isUpdatingSecondExercise;

  DoubleViewModel(BuildContext context, super.workoutInfo) {
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

  void onFirstIdSelected(int id) {}

  void onSecondIdSelected(int id) {}

  @override
  void dispose() {
    repeatsFirstController.dispose();
    repeatsSecondController.dispose();
    weightFirstController.dispose();
    weightSecondController.dispose();
    super.dispose();
  }
}
