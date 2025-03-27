import 'package:flutter/widgets.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';

class SimpleViewModel extends ChangeNotifier {
  late TextEditingController weightController;
  late TextEditingController repeatsController;

  final List<SixResultsDayInfo> testResults = [
    SixResultsDayInfo('пн 1.04.22', ['120/35', '120/35', '120/35']),
    SixResultsDayInfo('вт 2.04.22', ['120/35', '120/35', '120/35']),
    SixResultsDayInfo('ср 3.04.22', ['120/35', '120/35', '120/35']),
    SixResultsDayInfo('чт 4.04.22', ['120/35', '120/35', '120/35']),
    SixResultsDayInfo('пт 5.04.22', ['120/35', '120/35', '120/35']),
    SixResultsDayInfo('сб 6.04.22', ['120/35', '120/35', '120/35']),
  ];

  SimpleViewModel() {
    weightController = TextEditingController();
    repeatsController = TextEditingController();
  }

  @override
  void dispose() {
    weightController.dispose();
    repeatsController.dispose();
    super.dispose();
  }
}
