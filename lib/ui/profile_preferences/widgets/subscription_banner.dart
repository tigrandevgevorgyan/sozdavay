import 'package:flutter/material.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              Assets.subscriptionBanner,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              width: double.infinity,
            )

          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(subtitle, style: Style.outfit14w400),
          //         SizedBox(height: 4),
          //         Text(title, style: Style.ablation15w900),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
