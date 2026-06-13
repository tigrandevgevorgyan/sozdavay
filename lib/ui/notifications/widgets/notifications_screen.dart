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
                        : _GroupedList(items: vm.items, onTap: vm.markRead),
                  ),
          );
        },
      ),
    );
  }
}

/// Groups notifications by day with Russian section headers (Сегодня /
/// Вчера / dd.MM.yyyy) per Gohar's Notifications design (Figma 33:866).
class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.items, required this.onTap});

  final List<AppNotification> items;
  final void Function(AppNotification) onTap;

  @override
  Widget build(BuildContext context) {
    final groups = _groupByDay(items);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: groups.length,
      itemBuilder: (context, gIdx) {
        final g = groups[gIdx];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  g.label,
                  style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
                ),
              ),
              for (var i = 0; i < g.items.length; i++) ...[
                _NotificationTile(
                  notification: g.items[i],
                  onTap: () => onTap(g.items[i]),
                ),
                if (i < g.items.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  List<_DayGroup> _groupByDay(List<AppNotification> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<DateTime, List<AppNotification>> bucket = {};
    for (final n in items) {
      final created = DateTime.tryParse(n.createdAt ?? '');
      if (created == null) continue;
      final local = created.toLocal();
      final dayKey = DateTime(local.year, local.month, local.day);
      bucket.putIfAbsent(dayKey, () => []).add(n);
    }

    final sortedKeys = bucket.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final key in sortedKeys)
        _DayGroup(
          label: _labelFor(key, today, yesterday),
          items: bucket[key]!,
        ),
    ];
  }

  String _labelFor(DateTime day, DateTime today, DateTime yesterday) {
    if (day == today) return 'Сегодня';
    if (day == yesterday) return 'Вчера';
    return '${day.day.toString().padLeft(2, '0')}.${day.month.toString().padLeft(2, '0')}.${day.year}';
  }
}

class _DayGroup {
  _DayGroup({required this.label, required this.items});
  final String label;
  final List<AppNotification> items;
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
            // 48x48 square icon container per Figma — solid darker bg + glyph
            // matched to the notification template_key.
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(notification.templateKey),
                color: AppColors.primaryTextColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (notification.title != null && notification.title!.isNotEmpty)
                    Text(
                      notification.title!,
                      style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
                    ),
                  if (notification.body != null && notification.body!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      notification.body!,
                      style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right column: unread dot + compact time per Figma.
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.errorMessagePositive,
                    ),
                  )
                else
                  const SizedBox(height: 8),
                const SizedBox(height: 4),
                if (notification.createdAt != null)
                  Text(
                    _formatTime(notification.createdAt!),
                    style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String? templateKey) {
    if (templateKey == null) return Icons.notifications_none_rounded;
    if (templateKey.contains('achievement')) return Icons.emoji_events_outlined;
    if (templateKey.contains('clan')) return Icons.groups_outlined;
    if (templateKey.contains('subscription')) return Icons.workspace_premium_outlined;
    if (templateKey.contains('level')) return Icons.trending_up;
    if (templateKey.contains('retention') || templateKey.contains('workout')) return Icons.lightbulb_outline;
    if (templateKey.contains('challenge')) return Icons.flag_outlined;
    return Icons.notifications_none_rounded;
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final l = dt.toLocal();
    return '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}
