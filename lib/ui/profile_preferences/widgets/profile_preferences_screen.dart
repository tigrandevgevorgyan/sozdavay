import 'package:flutter/material.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/core/ui/level_up_button.dart';
import 'package:level_up/ui/core/ui/level_up_text_field.dart';
import 'package:level_up/ui/profile_preferences/view_model/profile_preferences_view_model.dart';
import 'package:level_up/ui/profile_preferences/widgets/options_input_field.dart';
import 'package:level_up/ui/profile_preferences/widgets/subscription_banner.dart';
import 'package:provider/provider.dart';

class ProfilePreferencesScreen extends StatelessWidget {
  const ProfilePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfilePreferencesViewModel(),
      child: Consumer<ProfilePreferencesViewModel>(builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: SizedBox(
              height: 40,
              child: Image.asset(Assets.logo),
            ),
            centerTitle: true,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SubscriptionBanner(validUntilDate: "1.11.2025"),
                        SizedBox(height: 12),
                        NameInputField(controller: provider.nameController),
                        SizedBox(height: 14),
                        OptionsBlocWidget(
                          title: 'Выберите ваш пол и вес',
                          value: provider.genderWeightSelection,
                          onClick: () => provider.onGenderWeightClicked(context),
                        ),
                        SizedBox(height: 12),
                        OptionsBlocWidget(
                          title: 'Выберите свой уровень подготовки',
                          value: provider.levelSelection,
                          onClick: () => provider.onLevelClicked(context),
                        ),
                        SizedBox(height: 12),
                        OptionsBlocWidget(
                          title: 'Выберите свою цель',
                          value: provider.goalSelection,
                          onClick: () => provider.onGoalClicked(context),
                        ),
                        SizedBox(height: 12),
                        OptionsBlocWidget(
                          title: 'Выберите приоритет',
                          value: provider.prioritySelection,
                          onClick: () => provider.onPriorityClicked(context),
                        ),
                        SizedBox(height: 12),
                        OptionsBlocWidget(
                          title: 'Выберите кол-во тренировок в неделю',
                          value: provider.trainingWeeklySelection,
                          onClick: () => provider.onTrainingWeeklyClicked(context),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                LevelUpButton(
                  text: 'Сохранить и продолжить',
                  buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                  onClick: () => provider.onSaveClicked(context),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class NameInputField extends StatelessWidget {
  const NameInputField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Как вас зовут?', style: Style.raleway14w400.copyWith(color: AppColors.primaryTextColor)),
        SizedBox(height: 4),
        LevelUpTextField(controller: controller, hintText: 'Имя'),
      ],
    );
  }
}

class OptionsBlocWidget extends StatelessWidget {
  const OptionsBlocWidget({
    super.key,
    required this.title,
    this.value,
    required this.onClick,
  });

  final String title;
  final String? value;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Style.raleway14w400.copyWith(color: AppColors.primaryTextColor)),
        SizedBox(height: 8),
        OptionsInputField(
          hint: 'Не выбрано',
          value: value,
          onClick: onClick,
          isArrowVisible: true,
        )
      ],
    );
  }
}
