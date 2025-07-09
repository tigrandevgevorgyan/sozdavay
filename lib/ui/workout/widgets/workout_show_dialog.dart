import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';

class WorkoutShowDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final VoidCallback onConfirm;
  final String cancelText;
  final VoidCallback? onCancel;

  const WorkoutShowDialog({
    super.key,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = 'Отмена',
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF3C3C3C), width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Center(
                    child: Text(title, style: Style.ablation18w900.copyWith(color: Colors.white),
                        textAlign: TextAlign.center)),
                const SizedBox(height: 24),
                LevelUpButton(
                  text: confirmText,
                  buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
                  onClick: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    child: Text(
                      cancelText,
                      style: Style.ablation14w900.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
