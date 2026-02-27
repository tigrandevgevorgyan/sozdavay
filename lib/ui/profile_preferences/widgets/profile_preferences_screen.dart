import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
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
  const ProfilePreferencesScreen({super.key, required this.hasWorkoutPlan, required this.isFirstLogin, required this.isAfterLogin});
  final bool hasWorkoutPlan;
  final bool isFirstLogin;
  final bool isAfterLogin;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfilePreferencesViewModel(context, dataRepository: GetIt.I<IDataRepository>(), profileRepository: GetIt.I<IProfileRepository>(), hasWorkoutPlan: hasWorkoutPlan, isFirstLogin: isFirstLogin, isAfterLogin: isAfterLogin),
      child: Consumer<ProfilePreferencesViewModel>(builder: (context, provider, _) {
        return WillPopScope(
          onWillPop: () async {
            // Pass current lock state back to caller when using system back
            GoRouter.of(context).pop();
            return false; // prevent default pop since we already popped with result
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: Image.asset(
                Assets.logo,
                height: 40, // или 32–36
                width: 57, // или 32–36
                fit: BoxFit.contain,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              // Custom back to pass result when pressing the AppBar back button
              leading: (isFirstLogin || isAfterLogin)
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                    ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: provider.isLoading
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
                                  // SubscriptionBanner(
                                  //   title: provider.isSubscriptionExpired
                                  //       ? "Продлить в чате с тренером"
                                  //       : "Активна до ${provider.validUntilDate}",
                                  //   subtitle: provider.isSubscriptionExpired
                                  //       ? "Подписка закончилась"
                                  //       : "Подписка",
                                  // ),
                                  SizedBox(height: 12),
                                  Consumer<ProfilePreferencesViewModel>(
                                    builder: (context, provider, _) {
                                      return Focus(
                                        onFocusChange: (hasFocus) {
                                          if (hasFocus && provider.shouldBlockFocus) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        child: LevelUpTextField(
                                          controller: provider.nameController,
                                          focusNode: provider.nameFocusNode,
                                          hintText: 'Имя',
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 14),
                                  OptionsBlocWidget(
                                    title: 'Выберите ваш пол',
                                    value: provider.categorySelection,
                                    onClick: () => provider.onGenderWeightClicked(context),
                                  ),
                                  SizedBox(height: 12),
                                  if (!hasWorkoutPlan)
                                  Column(
                                    children: [
                                      // OptionsBlocWidget(
                                      //   title: 'Выберите сложность',
                                      //   value: provider.levelSelection,
                                      //   onClick: () => provider.onLevelClicked(context),
                                      // ),
                                      // SizedBox(height: 12),
                                      OptionsBlocWidget(
                                        title: 'Выберите свою цель',
                                        value: provider.goalSelection,
                                        onClick: () => provider.onGoalClicked(context),
                                      ),
                                      SizedBox(height: 12),
                                      if (provider.isPriorityAvailable)
                                        OptionsBlocWidget(
                                          title: 'Выберите место тренировки',
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
                          // CheckboxListTile(
                          //   title: Text("Запретить изменения",
                          //       style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor)),
                          //   value: provider.lockChanges,
                          //   onChanged: (val) {
                          //     if (val != null) {
                          //     //  provider.setLockChanges(val);
                          //     }
                          //   },
                          //   controlAffinity: ListTileControlAffinity.leading,
                          // ),
                          // SizedBox(height: 12),
                          if (provider.error != null) InfoAndErrorTextWidget(text: provider.error, isError: true),
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
            ),
          ),
        );
      }),
    );
  }
}

class NameInputField extends StatelessWidget {
  const NameInputField({super.key, required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Как вас зовут?', style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor)),
        SizedBox(height: 4),
        LevelUpTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: 'Имя'),
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
