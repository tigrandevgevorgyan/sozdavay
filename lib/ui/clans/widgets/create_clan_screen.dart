import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/clans/view_model/clans_view_model.dart';
import 'package:level_up/ui/core/common_widgets/error_text_widget.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:provider/provider.dart';

class CreateClanScreen extends StatelessWidget {
  const CreateClanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateClanViewModel>(
      create: (_) => CreateClanViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<CreateClanViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => GoRouter.of(context).pop(),
              ),
              title: Text(
                'Создать клан',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Название',
                    style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                  ),
                  const SizedBox(height: 6),
                  LevelUpTextField(
                    controller: vm.nameController,
                    hintText: 'Например, Огненные волки',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Описание',
                    style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                  ),
                  const SizedBox(height: 6),
                  LevelUpTextField(
                    controller: vm.descriptionController,
                    hintText: 'Расскажите о вашем клане',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Кто может вступать',
                    style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                  ),
                  const SizedBox(height: 6),
                  _PolicyChoice(
                    value: 'open',
                    current: vm.joinPolicy,
                    label: 'Открытый — все могут вступить',
                    onTap: vm.setJoinPolicy,
                  ),
                  _PolicyChoice(
                    value: 'request',
                    current: vm.joinPolicy,
                    label: 'По заявке — нужно одобрение',
                    onTap: vm.setJoinPolicy,
                  ),
                  _PolicyChoice(
                    value: 'closed',
                    current: vm.joinPolicy,
                    label: 'Закрытый — только по приглашению',
                    onTap: vm.setJoinPolicy,
                  ),
                  const SizedBox(height: 16),
                  if (vm.error != null)
                    InfoAndErrorTextWidget(text: vm.error, isError: true),
                  const SizedBox(height: 8),
                  LevelUpButton(
                    text: vm.busy ? '...' : 'Создать',
                    buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                    onClick: () async {
                      final clan = await vm.submit();
                      if (clan != null && context.mounted) {
                        GoRouter.of(context).pop();
                        GoRouter.of(context).push(
                          LevelUpRouter.homePath + LevelUpRouter.clanDetailPath,
                          extra: clan.id,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PolicyChoice extends StatelessWidget {
  const _PolicyChoice({
    required this.value,
    required this.current,
    required this.label,
    required this.onTap,
  });
  final String value;
  final String current;
  final String label;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final active = current == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onTap(value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundContentColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? AppColors.activeButtonColor : AppColors.inputBorderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                active ? Icons.radio_button_checked : Icons.radio_button_off,
                color: active ? AppColors.errorMessagePositive : AppColors.secondaryTextColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
