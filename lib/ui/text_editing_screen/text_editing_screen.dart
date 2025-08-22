import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class TextEditingScreen extends StatefulWidget {
  const TextEditingScreen({
    super.key,
    required this.params,
  });

  final TextEditingScreenParams params;

  @override
  State<TextEditingScreen> createState() => _TextEditingScreenState();
}

class _TextEditingScreenState extends State<TextEditingScreen> {
  late TextEditingController _controller;

  bool _isActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.params.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params.title, style: Style.ablation18w900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        backgroundColor: AppColors.backgroundContentColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autocorrect: false,
                style: Style.outfit16w400,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _isActionInProgress
                  ? LevelUpLoader()
                  : LevelUpButton(text: 'Сохранить и закрыть', buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall), onClick: () => _updateText()),
            ),
          ],
        ),
      ),
    );
  }

  void _updateText() async {
    setState(() {
      _isActionInProgress = true;
    });
    final result = await widget.params.onTextUpdated(_controller.text);
    switch (result) {
      case Ok<bool>():
        if (context.mounted) {
          GoRouter.of(context).pop();
        }
      case Error<bool>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
    setState(() {
      _isActionInProgress = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class TextEditingScreenParams {
  final String title;
  final String initialText;
  final Future<Result<bool>> Function(String) onTextUpdated;

  TextEditingScreenParams({required this.title, required this.initialText, required this.onTextUpdated});
}
