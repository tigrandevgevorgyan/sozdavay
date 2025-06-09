import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/core/common_widgets/error_text_widget.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/profile_preferences/view_model/profile_preferences_view_model.dart';
import 'package:level_up/ui/profile_preferences/widgets/options_input_field.dart';
import 'package:level_up/ui/profile_preferences/widgets/subscription_banner.dart';
import 'package:provider/provider.dart';

class ProfilePreferencesScreen extends StatelessWidget {
  const ProfilePreferencesScreen({super.key, required this.hasWorkoutPlan});
  final bool hasWorkoutPlan;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfilePreferencesViewModel(context, profileRepository: GetIt.I<IProfileRepository>(), hasWorkoutPlan: hasWorkoutPlan),
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
          body: provider.isLoading
              ? Center(
                  child: LevelUpLoader(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SubscriptionBanner(validUntilDate: provider.validUntilDate),
                              SizedBox(height: 12),
                              NameInputField(controller: provider.nameController),
                              SizedBox(height: 14),
                              OptionsBlocWidget(
                                title: 'Выберите ваш пол и вес',
                                value: provider.categorySelection,
                                onClick: () => provider.onGenderWeightClicked(context),
                              ),
                              SizedBox(height: 12),
                              if (!hasWorkoutPlan)
                              Column(
                                children: [
                                  OptionsBlocWidget(
                                    title: 'Выберите сложность',
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
                                  if (provider.isPriorityAvailable)
                                    OptionsBlocWidget(
                                      title: 'Выберите приоритет',
                                      value: provider.prioritySelection,
                                      onClick: () => provider.onPriorityClicked(context),
                                    ),
                                  if (provider.isPriorityAvailable) SizedBox(height: 12),
                                  OptionsBlocWidget(
                                    title: 'Выберите кол-во тренировок в неделю',
                                    value: provider.trainingWeeklySelection,
                                    onClick: () => provider.onTrainingWeeklyClicked(context),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (provider.error != null) ErrorTextWidget(error: provider.error),
                      provider.isUpdating
                          ? LevelUpLoader()
                          : LevelUpButton(
                              text: 'Сохранить и продолжить',
                              buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                              onClick: () => provider.onSaveClicked(context),
                            ),
                      SizedBox(height: 16),
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
        Text('Как вас зовут?', style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor)),
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
        Text(title, style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor)),
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
