import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.position, required this.name, required this.score, required this.tierName, required this.isMyProfile});

  final int position;
  final String name;
  final int score;
  final String tierName;
  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          border: Border.all(color: isMyProfile ? AppColors.activeButtonColor : AppColors.backgroundContentColor),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Container(
              width: 41,
              height: 48,
              decoration: BoxDecoration(
                color: isMyProfile ? AppColors.activeButtonColor : AppColors.secondaryDefaultColor,
              ),
              child: Center(
                child: Text(position.toString(), style: Style.ablation16w900.copyWith(color: AppColors.primaryTextColor)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(name, style: Style.raleway16w400.copyWith(color: AppColors.primaryTextColor)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(score.toString(), style: Style.ablation14w900),
                Text(tierName, style: Style.raleway11w300.copyWith(color: AppColors.primaryTextColor)),
              ],
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
