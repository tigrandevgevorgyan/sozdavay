import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key, required this.days, required this.height});

  final double height;
  final List<CalendarDayInfo> days;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (CalendarDayInfo day in days)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: _getBackgroundColor(day), borderRadius: BorderRadius.circular(4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.dayName,
                      style: Style.ablation13w700.copyWith(color: _getTextColor(day)),
                    ),
                    SizedBox(height: 1),
                    Text(day.dayNumber.toString(), style: Style.ablation15w900.copyWith(color: _getTextColor(day))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(CalendarDayInfo day) {
    if (day.isToday) {
      return AppColors.activeButtonColor;
    }
    if (day.isTrainingDay) {
      return AppColors.backgroundContentColor;
    }
    return AppColors.backgroundColor;
  }

  Color _getTextColor(CalendarDayInfo day) {
    if (day.isTrainingDay && !day.isToday) {
      return AppColors.tertiaryHintColor;
    }
    return AppColors.primaryTextColor;
  }
}

class CalendarDayInfo {
  final String dayName;
  final int dayNumber;
  final bool isTrainingDay;
  final bool isToday;

  CalendarDayInfo(this.dayName, this.dayNumber, this.isTrainingDay, this.isToday);
}
