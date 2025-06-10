import 'package:flutter/material.dart';
import 'package:level_up/ui/workout/widgets/day_measurements_result.dart';

class SimpleResultsWidget extends StatelessWidget {
  const SimpleResultsWidget({super.key, required this.results, this.selectedId, required this.onResultSelected, required this.onNotesClicked});

  final int? selectedId;
  final List<SixResultsDayInfo> results;
  final Function(int id) onResultSelected;
  final Function() onNotesClicked;

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
            return Expanded(
              flex: 1,
              child: DayMeasurementsResult(
                title: results[index].title,
                results: results[index].results,
                selectedId: selectedId,
                onResultSelected: onResultSelected,
                onNotesClicked: onNotesClicked,
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

class SixResultsDayInfo {
  final String title;
  final List<DayResultInfo> results;

  SixResultsDayInfo(this.title, this.results);
}
