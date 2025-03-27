import 'package:flutter/cupertino.dart';

class DoubleViewModel extends ChangeNotifier {
  late TextEditingController repeatsFirstController;
  late TextEditingController repeatsSecondController;

  late TextEditingController weightFirstController;
  late TextEditingController weightSecondController;

  DoubleViewModel(BuildContext context) {
    repeatsFirstController = TextEditingController();
    repeatsSecondController = TextEditingController();
    weightFirstController = TextEditingController();
    weightSecondController = TextEditingController();
  }

  String resultsTitle = 'ПН. 01. 04. 22';
  List<String> resultsOptions = ['120/35', '120/35', '120/35'];

  @override
  void dispose() {
    repeatsFirstController.dispose();
    repeatsSecondController.dispose();
    weightFirstController.dispose();
    weightSecondController.dispose();
    super.dispose();
  }
}
