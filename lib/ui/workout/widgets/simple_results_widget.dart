import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';

import '../../../data/services/workout/models/workout_response.dart';

class SimpleResultsWidget extends StatelessWidget {
  const SimpleResultsWidget({super.key, required this.results, this.selectedId, required this.onResultSelected, required this.onNotesClicked});

  final int? selectedId;
  final List<SimpleResultsDayInfo> results;
  final void Function(int id) onResultSelected;
  final void Function(HistoryInfo history) onNotesClicked;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int i = 0; i < results.length; i += 3) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (j) {
            int index = i + j;
            if (index >= results.length) {
              return const Expanded(child: SizedBox());
            }
            final item = results[index];
            return Expanded(
              flex: 1,
              child: DayMeasurementsResult(
                title: results[index].title,
                results: results[index].results,
                selectedId: selectedId,
                onResultSelected: onResultSelected,
                onNotesClicked: onNotesClicked,
                history: item.history,
              ),
            );
          }),
        ),
      );

      rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
  }

class SimpleResultsDayInfo {
  final String title;
  final HistoryInfo history;
  final List<DayResultInfo> results;

  SimpleResultsDayInfo(this.title, this.results, this.history);
}
