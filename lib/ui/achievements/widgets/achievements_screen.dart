import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';
import 'package:level_up/ui/achievements/view_model/achievements_view_model.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:provider/provider.dart';

/// Достижения — full wall of every available achievement, with locked/earned
/// state and an "Все / Получены / Доступны" filter row.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AchievementsViewModel>(
      create: (_) => AchievementsViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<AchievementsViewModel>(
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
                'Достижения',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : RefreshIndicator(
                    color: AppColors.activeButtonColor,
                    onRefresh: vm.refresh,
                    child: vm.all.isEmpty
                        ? _emptyState(context)
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            children: [
                              _SummaryHeader(earned: vm.earnedCount, total: vm.all.length),
                              const SizedBox(height: 16),
                              _FilterRow(filter: vm.filter, onChange: vm.setFilter),
                              const SizedBox(height: 16),
                              _Grid(items: vm.filtered),
                            ],
                          ),
                  ),
          );
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Center(
          child: Text(
            'Пока нет доступных достижений',
            style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
          ),
        ),
      ],
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.earned, required this.total});
  final int earned;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events_outlined, color: AppColors.activeButtonColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Получено $earned из $total',
                  style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'Выполняйте задачи, чтобы открыть новые',
                  style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.filter, required this.onChange});
  final AchievementsFilter filter;
  final ValueChanged<AchievementsFilter> onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Все', AchievementsFilter.all),
        const SizedBox(width: 8),
        _chip('Получены', AchievementsFilter.earned),
        const SizedBox(width: 8),
        _chip('Доступны', AchievementsFilter.available),
      ],
    );
  }

  Widget _chip(String label, AchievementsFilter value) {
    final active = filter == value;
    return Expanded(
      child: InkWell(
        onTap: () => onChange(value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.activeButtonColor : AppColors.inActiveButtonColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: Style.outfit14w400.copyWith(
              color: active ? AppColors.primaryTextColor : AppColors.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items});
  final List<Achievement> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Нет элементов в этой категории',
            style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _Card(achievement: items[i]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final granted = achievement.isGranted;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: granted ? AppColors.activeButtonColor.withValues(alpha: 0.5) : AppColors.inputBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: granted ? 1.0 : 0.4,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputBackgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: achievement.iconUrl != null && achievement.iconUrl!.isNotEmpty
                  ? Image.network(
                      achievement.iconUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.emoji_events,
                        color: AppColors.secondaryTextColor,
                        size: 28,
                      ),
                    )
                  : Icon(
                      granted ? Icons.emoji_events : Icons.lock_outline,
                      color: granted ? AppColors.activeButtonColor : AppColors.secondaryTextColor,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            achievement.name,
            style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (achievement.description != null && achievement.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                achievement.description!,
                style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          if (achievement.creatorPointsReward > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.activeButtonColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '+${achievement.creatorPointsReward} ₽',
                style: Style.ablation12w900.copyWith(color: AppColors.errorMessagePositive),
              ),
            ),
        ],
      ),
    );
  }
}
