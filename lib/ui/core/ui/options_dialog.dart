import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/core/ui/level_up_button.dart';
import 'package:level_up/ui/core/ui/level_up_radio_button.dart';
import 'package:level_up/ui/core/ui/measurable_widget.dart';

const maxAllowedHeightRatio = 0.95;
const minAllowedHeightRatio = 0.13;

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({super.key, required this.selectedValue, required this.title, required this.options});

  final String? selectedValue;
  final String title;
  final List<String> options;

  @override
  State<OptionsDialog> createState() => _OptionsDialogState();

  static Future<String?> showDialog(BuildContext context, String? selectedValue, String title, List<String> options) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      backgroundColor: AppColors.backgroundContentColor,
      builder: (context) => OptionsDialog(selectedValue: selectedValue, title: title, options: options),
    );
  }
}

class _OptionsDialogState extends State<OptionsDialog> {
  double heightRatio = maxAllowedHeightRatio;
  double maxHeightRatio = maxAllowedHeightRatio;

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      minChildSize: minAllowedHeightRatio,
      maxChildSize: maxHeightRatio,
      initialChildSize: heightRatio,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: MeasurableWidget(
            onChange: (Size size) {
              var screenHeight = MediaQuery.of(context).size.height;
              var padding = MediaQuery.of(context).padding;
              var newRatio = (size.height + 10) / (screenHeight - padding.bottom);
              setState(() {
                if (newRatio < minAllowedHeightRatio) {
                  newRatio = minAllowedHeightRatio;
                }
                if (newRatio > maxAllowedHeightRatio) {
                  newRatio = maxAllowedHeightRatio;
                }
                heightRatio = newRatio;
                // if (!widget.isScrollAllowed){
                maxHeightRatio = heightRatio;
                // }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 36,
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Divider(height: 4, thickness: 4, color: Color(0xFF3B3B3C)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(widget.title, style: Style.ablation18w900),
                  ),
                  for (String option in widget.options) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: LevelUpRadioButton(
                          value: option,
                          groupValue: _selectedValue ?? "",
                          onClick: () {
                            setState(() {
                              _selectedValue = option;
                            });
                          }),
                    ),
                  ],
                  LevelUpButton(text: 'Сохранить', buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium), onClick: () => Navigator.of(context).pop(_selectedValue)),
                  SizedBox(height: 4),
                  LevelUpButton(text: 'Отмена', buttonStyle: LevelUpButtonStyle.darkStyle(ButtonHeight.medium), onClick: () => Navigator.of(context).pop(null))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
