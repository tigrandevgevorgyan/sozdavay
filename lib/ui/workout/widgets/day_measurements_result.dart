import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class DayMeasurementsResult extends StatelessWidget {
  const DayMeasurementsResult({super.key, required this.title, required this.result});

  final String title;
  final List<String> result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(Assets.pencilIcon),
            SizedBox(width: 4),
            Text(title, style: Style.ablation12w900.copyWith(color: AppColors.tertiaryHintColor)),
          ],
        ),
        for (String result in result)
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 1.5, bottom: 1.5),
            child: Text(
              result,
              style: Style.ablation15w800.copyWith(color: AppColors.primaryTextColor),
            ),
          ),
      ],
    );
  }
}
