import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';

class HomeViewModel extends ChangeNotifier {
  final days = [
    CalendarDayInfo('ПН', 1, true, false),
    CalendarDayInfo('ВТ', 2, false, false),
    CalendarDayInfo('СР', 3, true, false),
    CalendarDayInfo('ЧТ', 4, false, false),
    CalendarDayInfo('ПТ', 5, true, true),
    CalendarDayInfo('СБ', 6, false, false),
    CalendarDayInfo('ВС', 7, false, false),
  ];

  void onRatingClicked(BuildContext context) {
    GoRouter.of(context).go(LevelUpRouter.homePath + LevelUpRouter.ratingPath);
  }
}
