import 'dart:math';

import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';

class SixResultsWidget extends StatelessWidget {
  const SixResultsWidget({super.key, required this.results, this.selectedId, required this.onResultSelected, required this.onNotesClicked});

  final int? selectedId;
  final List<SixResultsDayInfo> results;
  final Function(int id) onResultSelected;
  final Function() onNotesClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < min(3, results.length); i++)
              Expanded(
                flex: 1,
                child: DayMeasurementsResult(
                  title: results[i].title,
                  results: results[i].results,
                  selectedId: selectedId,
                  onResultSelected: onResultSelected,
                  onNotesClicked: onNotesClicked,
                ),
              ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 3; i < min(6, results.length); i++)
              Expanded(
                flex: 1,
                child: DayMeasurementsResult(
                  title: results[i].title,
                  results: results[i].results,
                  selectedId: selectedId,
                  onResultSelected: onResultSelected,
                  onNotesClicked: onNotesClicked,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class SixResultsDayInfo {
  final String title;
  final List<DayResultInfo> results;

  SixResultsDayInfo(this.title, this.results);
}
