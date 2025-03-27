import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';

class SixResultsWidget extends StatelessWidget {
  const SixResultsWidget({super.key, required this.results});

  final List<SixResultsDayInfo> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++)
              Expanded(
                flex: 1,
                child: DayMeasurementsResult(title: results[i].title, result: results[i].results),
              ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            for (int i = 3; i < 6; i++)
              Expanded(
                flex: 1,
                child: DayMeasurementsResult(title: results[i].title, result: results[i].results),
              ),
          ],
        ),
      ],
    );
  }
}

class SixResultsDayInfo {
  final String title;
  final List<String> results;

  SixResultsDayInfo(this.title, this.results);
}
