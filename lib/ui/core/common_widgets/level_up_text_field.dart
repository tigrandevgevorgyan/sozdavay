import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

class LevelUpTextField extends StatefulWidget {
  const LevelUpTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLength,
      this.maxLines,
      this.keyboardType,
      this.inputFormatters,
      this.prefix,
      this.focusedHintText,
      this.textSize = 15,
      this.height = TextFieldHeight.tall});

  final TextEditingController controller;
  final String hintText;
  final String? focusedHintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final double textSize;
  final TextFieldHeight height;

  @override
  State<LevelUpTextField> createState() => _LevelUpTextFieldState();
}

class _LevelUpTextFieldState extends State<LevelUpTextField> {
  FocusNode? _focus = FocusNode();

  late String _hintText = widget.hintText;

  @override
  void initState() {
    super.initState();
    _focus?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      if (_focus?.hasFocus ?? false) {
        if (widget.focusedHintText != null) {
          _hintText = widget.focusedHintText!;
        }
      } else {
        _hintText = widget.hintText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height.value,
      child: TextField(
        focusNode: _focus,
        controller: widget.controller,
        expands: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 1, top: 1),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputBorderColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.inputBorderColor)),
          hintText: _hintText,
          isDense: true,
          hintStyle: Style.ablation15w900.copyWith(color: AppColors.tertiaryHintColor, fontSize: widget.textSize),
          filled: true,
          fillColor: AppColors.inputBackgroundColor,
          prefix: (_focus?.hasFocus ?? false) || widget.controller.text.isNotEmpty ? widget.prefix : null,
          counterText: "",
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        autocorrect: false,
        style: Style.ablation15w900.copyWith(fontSize: widget.textSize),
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focus?.removeListener(_onFocusChange);
    _focus?.dispose();
    _focus = null;
  }
}

enum TextFieldHeight {
  tall(46),
  medium(40);

  const TextFieldHeight(this.value);

  final double value;
}
