import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class DayMeasurementsResult extends StatelessWidget {
  const DayMeasurementsResult({super.key, required this.title, required this.results, this.selectedId, required this.onResultSelected});

  final String title;
  final int? selectedId;
  final List<DayResultInfo> results;
  final Function(int id) onResultSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.pencilIcon),
            SizedBox(width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: AutoSizeText(title, style: Style.raleway15w500.copyWith(color: AppColors.tertiaryHintColor), maxLines: 1),
              ),
            ),
          ],
        ),
        for (DayResultInfo result in results)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onResultSelected(result.id),
            child: Padding(
              padding: const EdgeInsets.only(left: 18, top: 1.5, bottom: 1.5),
              child: AutoSizeText(
                result.result,
                style: Style.raleway15w400.copyWith(color: ((selectedId ?? -1) != result.id) ? AppColors.primaryTextColor : AppColors.activeButtonColor),
              ),
            ),
          ),
      ],
    );
  }
}

class DayResultInfo {
  final int id;
  final String result;

  DayResultInfo(this.id, this.result);
}
