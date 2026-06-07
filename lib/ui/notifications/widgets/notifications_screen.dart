import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/notification.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/notifications/view_model/notifications_view_model.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationsViewModel>(
      create: (_) => NotificationsViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<NotificationsViewModel>(
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
                'Уведомления',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
              actions: [
                if (vm.unreadCount > 0)
                  TextButton(
                    onPressed: vm.markAllRead,
                    child: Text(
                      'Прочитать всё',
                      style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive),
                    ),
                  ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : RefreshIndicator(
                    color: AppColors.activeButtonColor,
                    onRefresh: vm.refresh,
                    child: vm.items.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'Пока нет уведомлений',
                                  style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: vm.items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) => _NotificationTile(
                              notification: vm.items[i],
                              onTap: () => vm.markRead(vm.items[i]),
                            ),
                          ),
                  ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});
  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: unread ? AppColors.activeButtonColor.withValues(alpha: 0.6) : AppColors.inputBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unread)
              Container(
                margin: const EdgeInsets.only(top: 6, right: 10),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.errorMessagePositive,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.title != null && notification.title!.isNotEmpty)
                    Text(
                      notification.title!,
                      style: Style.ablation14w900.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  if (notification.body != null && notification.body!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      notification.body!,
                      style: Style.outfit14w300.copyWith(color: AppColors.primaryTextColor),
                    ),
                  ],
                  if (notification.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification.createdAt!),
                      style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final local = dt.toLocal();
    return '${_two(local.day)}.${_two(local.month)}.${local.year} '
        '${_two(local.hour)}:${_two(local.minute)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
