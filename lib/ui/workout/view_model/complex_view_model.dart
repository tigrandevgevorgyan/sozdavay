import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';
import 'package:level_up/ui/workout/widgets/six_results_widget.dart';

class ComplexViewModel extends ChangeNotifier {
  late TextEditingController textController;

  final List<SixResultsDayInfo> testResults = [
    SixResultsDayInfo('пн 1.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
    SixResultsDayInfo('вт 2.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
    SixResultsDayInfo('ср 3.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
    SixResultsDayInfo('чт 4.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
    SixResultsDayInfo('пт 5.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
    SixResultsDayInfo('сб 6.04.22', [
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
      DayResultInfo(1, '120/35'),
    ]),
  ];

  ComplexViewModel() {
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
