import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/view_model/base_view_model.dart';

class ComplexViewModel extends BaseViewModel {
  late TextEditingController textController;

  ComplexViewModel() {
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
