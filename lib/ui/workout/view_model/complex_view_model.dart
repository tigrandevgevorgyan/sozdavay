import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';
import 'package:level_up/ui/workout/view_model/workout_view_model.dart';
import 'package:provider/provider.dart';

class ComplexViewModel extends BaseViewModel {
  late TextEditingController textController;

  bool _isTime = false;

  bool get isTime => _isTime;

  ComplexViewModel(BuildContext context) {
    textController = TextEditingController();
    final currentWorkout = Provider.of<WorkoutViewModel>(context, listen: false).currentWorkout;
    _isTime = currentWorkout.isTime;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
