import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/notifications/view_model/notification_prefs_view_model.dart';
import 'package:provider/provider.dart';

class NotificationPrefsScreen extends StatelessWidget {
  const NotificationPrefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationPrefsViewModel>(
      create: (_) => NotificationPrefsViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<NotificationPrefsViewModel>(
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
                'Настройка уведомлений',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      for (final channel in vm.channels) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Text(
                            vm.channelLabel(channel).toUpperCase(),
                            style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundContentColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.inputBorderColor, width: 1),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < vm.types.length; i++) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    color: AppColors.inputBorderColor,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                _PrefRow(
                                  label: vm.typeLabel(vm.types[i]),
                                  enabled: vm.isEnabled(channel, vm.types[i]),
                                  onChanged: (_) => vm.toggle(channel, vm.types[i]),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  const _PrefRow({required this.label, required this.enabled, required this.onChanged});
  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryTextColor,
            activeTrackColor: AppColors.activeButtonColor,
            inactiveThumbColor: AppColors.secondaryTextColor,
            inactiveTrackColor: AppColors.inActiveButtonColor,
          ),
        ],
      ),
    );
  }
}
