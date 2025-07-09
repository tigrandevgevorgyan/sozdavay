import 'package:flutter/material.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_selectable_button.dart';
import 'package:level_up/ui/core/common_widgets/measurable_widget.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';

const maxAllowedHeightRatio = 0.95;
const minAllowedHeightRatio = 0.13;

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({super.key, required this.selectedValues, required this.title, required this.options, this.maxSelected = 1, this.hasAllOption = false});

  final List<String> selectedValues;
  final String title;
  final List<String> options;
  final int maxSelected;
  final bool hasAllOption;

  @override
  State<OptionsDialog> createState() => _OptionsDialogState();

  static Future<List<String>?> showDialog(BuildContext context, List<String> selectedValues, String title, List<String> options, {int maxSelected = 1, bool hasAllOption = false}) async {
    return await showModalBottomSheet<List<String>>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      context: context,
      backgroundColor: AppColors.backgroundContentColor,
      builder: (context) => OptionsDialog(selectedValues: selectedValues, title: title, options: options, maxSelected: maxSelected, hasAllOption: hasAllOption),
    );
  }
}

class _OptionsDialogState extends State<OptionsDialog> {
  double heightRatio = maxAllowedHeightRatio;
  double maxHeightRatio = maxAllowedHeightRatio;

  late Set<String> _selected;

  String? get allOptionText => widget.hasAllOption && widget.options.isNotEmpty ? widget.options.first : null;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedValues.toSet();
  }

  void _handleOptionClick(String option) {
    setState(() {
      if (widget.maxSelected == 1) {
        _selected
          ..clear()
          ..add(option);
      } else {
        if (widget.hasAllOption && allOptionText != null) {
          if (option == allOptionText) {
            if (_selected.contains(option)) {
              _selected.remove(option);
            } else {
              _selected
                ..clear()
                ..add(option);
            }
          } else {
            if (_selected.contains(allOptionText)) {
              _selected.remove(allOptionText!);
            }

            if (_selected.contains(option)) {
              _selected.remove(option);
            } else {
              if (_selected.length < widget.maxSelected) {
                _selected.add(option);
              }
            }
          }
        } else {
          if (_selected.contains(option)) {
            _selected.remove(option);
          } else {
            if (_selected.length < widget.maxSelected) {
              _selected.add(option);
            }
          }
        }
      }
    });
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
                maxHeightRatio = heightRatio;
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
                  ...widget.options.map((option) {
                    final isSelected = _selected.contains(option);
                    if (widget.maxSelected == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: LevelUpSelectableButton(
                          value: option,
                          groupValue: _selected.isNotEmpty ? _selected.first : "",
                          onClick: () => _handleOptionClick(option),
                        ),
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: LevelUpSelectableButton(
                            value: option,
                            groupValue: _selected.join('|'),
                            isCheckbox: true,
                            onClick: () => _handleOptionClick(option),
                          )
                      );
                    }
                  }),

                  LevelUpButton(text: 'Сохранить', buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium), onClick: () => Navigator.of(context).pop(_selected.toList())),
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
