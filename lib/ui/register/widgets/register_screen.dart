import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/ui/core/common_widgets/error_text_widget.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/register/view_model/register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:level_up/data/services/auth/models/register_options_response.dart';
import 'package:level_up/utils/phone_formatter.dart';
import 'package:level_up/utils/phone_mask_formatter.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(authRepository: GetIt.I<IAuthRepository>()),
      child: Consumer<RegisterViewModel>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'Регистрация',
                style: Style.ablation18w900.copyWith(color: Colors.white),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LevelUpTextField(
                        controller: provider.phoneController,
                        hintText: 'Введите номер телефона',
                        focusedHintText: '000 000 00 00',
                        keyboardType: TextInputType.number,
                        maxLength: 15,
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text('+7', style: Style.ablation15w900),
                        ),
                        inputFormatters: [
                          PhoneFormatter(),
                          FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')),
                          PhoneMaskFormatter(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LevelUpTextField(
                        controller: provider.nicknameController,
                        hintText: 'Введите никнейм',
                      ),
                      const SizedBox(height: 12),
                      LevelUpTextField(
                        controller: provider.passwordController,
                        hintText: 'Введите пароль',
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                      const SizedBox(height: 12),
                      LevelUpTextField(
                        controller: provider.referrerCodeController,
                        hintText: 'Код друга (необязательно)',
                        keyboardType: TextInputType.text,
                        maxLength: 16,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (provider.isLoadingOptions)
                        const LevelUpLoader()
                      else ...[
                        _dropdownField<GenderOption>(
                          hint: 'Пол',
                          value: provider.selectedGender,
                          getSelectedLabel: (g) => g?.label ?? '',
                          items: (provider.options?.genders ?? [])
                              .map(
                                (g) => DropdownMenuItem<GenderOption>(
                                  value: g,
                                  child: Text(g.label, style: Style.outfit16w300),
                                ),
                              )
                              .toList(),
                          onChanged: provider.setGender,
                        ),
                        const SizedBox(height: 12),

                        _dropdownField<TrainingGoalOption>(
                          hint: 'Цель',
                          value: provider.selectedTrainingGoal,
                          getSelectedLabel: (g) => g?.name ?? '',
                          items: (provider.options?.training_goals ?? [])
                              .map(
                                (g) => DropdownMenuItem<TrainingGoalOption>(
                                  value: g,
                                  child: Text(g.name, style: Style.outfit16w300),
                                ),
                              )
                              .toList(),
                          onChanged: provider.setTrainingGoal,
                        ),
                        const SizedBox(height: 12),

                        _dropdownField<TrainingPerWeekOption>(
                          hint: 'Тренировок в неделю',
                          value: provider.selectedTrainingPerWeek,
                          getSelectedLabel: (g) => g?.title ?? '',
                          items: (provider.options?.training_per_week ?? [])
                              .map(
                                (g) => DropdownMenuItem<TrainingPerWeekOption>(
                                  value: g,
                                  child: Text(g.title, style: Style.outfit16w300),
                                ),
                              )
                              .toList(),
                          onChanged: provider.setTrainingPerWeek,
                        ),
                        const SizedBox(height: 12),

                        // training_places can be empty: show only if there are items
                        if ((provider.options?.training_places ?? []).isNotEmpty) ...[
                          _dropdownField<TrainingPlaceOption>(
                            hint: 'Место тренировок',
                            value: provider.selectedTrainingPlace,
                            getSelectedLabel: (p) => p?.name ?? '',
                            items: (provider.options?.training_places ?? [])
                                .map(
                                  (p) => DropdownMenuItem<TrainingPlaceOption>(
                                    value: p,
                                    child: Text(p.name, style: Style.outfit16w300),
                                  ),
                                )
                                .toList(),
                            onChanged: provider.setTrainingPlace,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],

                      const SizedBox(height: 8),
                      InfoAndErrorTextWidget(
                        text: provider.message,
                        isError: provider.isErrorMessage,
                      ),

                      provider.isSubmitting
                          ? const LevelUpLoader()
                          : LevelUpButton(
                              isEnabled: provider.isFormValid,
                              text: 'зарегистрироваться',
                              buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                              onClick: () => provider.isFormValid ? provider.submit(context) : null,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _dropdownField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required String Function(T?) getSelectedLabel,
  }) {
    // When value == null, DropdownButtonFormField will show "hint"
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return items.map((item) {
          final label = item.value != null ? getSelectedLabel(item.value) : hint.toUpperCase();
          return LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth.isFinite ? constraints.maxWidth : 200,
                child: Text(
                  label ?? hint.toUpperCase(),
                  style: Style.outfit16w300.copyWith(
                    color: item.value == value ? Colors.white : const Color(0xFF6E6E6E),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            },
          );
        }).toList();
      },
      dropdownColor: AppColors.backgroundContentColor,
      decoration: _dropdownDecoration(),
      hint: Text(
        hint.toUpperCase(),
        style: Style.outfit16w300.copyWith(color: const Color(0xFF6E6E6E)),
      ),
      iconEnabledColor: Colors.white,
      style: Style.outfit16w300.copyWith(color: Colors.white),
    );
  }

  static InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundContentColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3C3C3C), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3C3C3C), width: 0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
