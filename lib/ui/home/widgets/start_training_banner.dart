import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/assets.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';

class StartTrainingBanner extends StatelessWidget {
  const StartTrainingBanner({super.key, required this.imagePath, required this.text, required this.onClick, required this.isActive});

  final String imagePath;
  final String text;
  final Function() onClick;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onClick,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: isActive
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(text, style: Style.ablation15w900.copyWith(color: AppColors.primaryTextColor)),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.activeButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              minimumSize: const Size(42, 42),
                              padding: const EdgeInsets.all(11),
                            ),
                            onPressed: onClick,
                            child: SvgPicture.asset(
                              Assets.playIcon,
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
