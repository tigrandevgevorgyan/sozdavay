import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';
import 'package:level_up/data/services/gamification/models/rating_level_summary.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

/// The new Profile hub (mobile-ui(3), Figma node 1:1573 in Gohar's file).
///
/// Layout follows Gohar's structure (header / avatar+name / level card /
/// account links) but renders with the app's own tokens — Ablation/Outfit
/// fonts, AppColors, existing common widgets. No Montserrat.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.hasWorkoutPlan});

  final bool hasWorkoutPlan;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(
        profileRepository: GetIt.I<IProfileRepository>(),
        hasWorkoutPlan: hasWorkoutPlan,
      ),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Image.asset(Assets.logo, height: 40, width: 57, fit: BoxFit.contain),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => GoRouter.of(context).pop(),
              ),
              actions: [
                // Notification bell on the right per Gohar's Profile design
                // (Figma 32:638). Matches the bell on Home — same destination.
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primaryTextColor,
                    size: 24,
                  ),
                  onPressed: () => vm.onNotificationsInboxTap(context),
                ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AvatarAndName(
                          avatarUrl: vm.avatarUrl,
                          displayName: vm.displayName,
                          creatorPoints: vm.creatorPoints,
                        ),
                        const SizedBox(height: 24),
                        _LevelCard(level: vm.ratingLevel),
                        const SizedBox(height: 24),
                        _AchievementsPreview(
                          items: vm.topAchievements,
                          onSeeAll: () => vm.onAchievementsTap(context),
                        ),
                        const SizedBox(height: 24),
                        _SectionHeader(title: 'ИГРОФИКАЦИЯ'),
                        _AccountLinkRow(
                          icon: Icons.emoji_events_outlined,
                          label: 'Достижения',
                          onTap: () => vm.onAchievementsTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.groups_outlined,
                          label: 'Кланы',
                          onTap: () => vm.onClansTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.storefront_outlined,
                          label: 'Магазин',
                          onTap: () => vm.onShopTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.collections_bookmark_outlined,
                          label: 'Мои рамки',
                          onTap: () => vm.onFramesTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.military_tech_outlined,
                          label: 'Боевой пропуск',
                          onTap: () => vm.onBattlePassTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.event_outlined,
                          label: 'Сезон',
                          onTap: () => vm.onSeasonTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.share_outlined,
                          label: 'Рефералы',
                          onTap: () => vm.onReferralsTap(context),
                        ),
                        const SizedBox(height: 24),
                        _SectionHeader(title: 'СЧЕТ'),
                        _AccountLinkRow(
                          icon: Icons.person_outline,
                          label: 'Редактировать профиль',
                          onTap: () => vm.onEditProfileTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.notifications_none_outlined,
                          label: 'Уведомления',
                          onTap: () => vm.onNotificationsInboxTap(context),
                        ),
                        _AccountLinkRow(
                          icon: Icons.tune_outlined,
                          label: 'Настройка уведомлений',
                          onTap: () => vm.onNotificationPrefsTap(context),
                        ),
                        const SizedBox(height: 24),
                        _SectionHeader(title: 'ОБЩИЙ'),
                        _AccountLinkRow(
                          icon: Icons.support_agent_outlined,
                          label: 'Поддержка',
                          onTap: vm.onSupportTap,
                        ),
                        _AccountLinkRow(
                          icon: Icons.logout,
                          label: 'Выйти',
                          color: AppColors.timerDoneOrangeColor,
                          onTap: () => vm.onLogoutTap(context),
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

class _AvatarAndName extends StatelessWidget {
  const _AvatarAndName({
    required this.avatarUrl,
    required this.displayName,
    required this.creatorPoints,
  });

  final String? avatarUrl;
  final String displayName;
  final int creatorPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 89,
          height: 89,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.inputBorderColor, width: 1.5),
            color: AppColors.inputBackgroundColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: avatarUrl != null && avatarUrl!.isNotEmpty
              ? Image.network(
                  avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                )
              : _avatarPlaceholder(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              displayName.toUpperCase(),
              style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
            ),
            if (creatorPoints > 0) ...[
              const SizedBox(width: 12),
              Icon(Icons.workspace_premium, size: 16, color: AppColors.errorMessagePositive),
              const SizedBox(width: 4),
              Text(
                _formatPoints(creatorPoints),
                style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Center(
      child: Icon(Icons.person_outline, size: 40, color: AppColors.secondaryTextColor),
    );
  }

  String _formatPoints(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});

  final RatingLevelSummary? level;

  static const int _maxLevel = 34;

  @override
  Widget build(BuildContext context) {
    final l = level;
    if (l == null) return const SizedBox.shrink();

    final progress = l.progressInLevel.clamp(0.0, 1.0);
    final subtitle = l.isMaxLevel
        ? 'Максимальный уровень'
        : '${l.pointsToNextLevel} баллов до следующего уровня';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'УРОВЕНЬ ${l.level} ИЗ $_maxLevel · ${l.label}',
            style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LevelBadge(label: '${l.level}', active: true),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      Container(height: 8, width: double.infinity, color: AppColors.inActiveButtonColor),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(height: 8, color: AppColors.activeButtonColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _LevelBadge(label: l.isMaxLevel ? '★' : '${l.nextLevel}', active: false),
            ],
          ),
          if (!l.isMaxLevel) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${l.pointsInLevel} / ${l.pointsInLevel + l.pointsToNextLevel}',
                style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.activeButtonColor : AppColors.inActiveButtonColor,
      ),
      child: Text(
        label,
        style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
      ),
    );
  }
}

class _AchievementsPreview extends StatelessWidget {
  const _AchievementsPreview({required this.items, required this.onSeeAll});

  final List<CustomerAchievement> items;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'ДОСТИЖЕНИЯ',
                style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              child: Text(
                'Просмотреть все',
                style: Style.outfit11w300.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              Expanded(child: _AchievementCard(grant: items[i])),
              if (i < items.length - 1) const SizedBox(width: 10),
            ],
            // Pad row to a consistent 3-column shape even when < 3 granted.
            for (var i = items.length; i < 3; i++) ...[
              const Expanded(child: SizedBox()),
              if (i < 2) const SizedBox(width: 10),
            ],
          ],
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.grant});

  final CustomerAchievement grant;

  @override
  Widget build(BuildContext context) {
    final a = grant.achievement;
    return Container(
      height: 118,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.inputBackgroundColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: a?.iconUrl != null && a!.iconUrl!.isNotEmpty
                ? Image.network(
                    a.iconUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.emoji_events, color: AppColors.activeButtonColor, size: 22),
                  )
                : Icon(Icons.emoji_events, color: AppColors.activeButtonColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            a?.name ?? '—',
            style: Style.outfit11w300.copyWith(color: AppColors.primaryTextColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (grant.grantedAt != null)
            Text(
              _shortDate(grant.grantedAt!),
              style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  String _shortDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final l = dt.toLocal();
    return '${l.day.toString().padLeft(2, '0')}.${l.month.toString().padLeft(2, '0')}.${l.year}';
  }
}

class _AccountLinkRow extends StatelessWidget {
  const _AccountLinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.primaryTextColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: tint),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Style.outfit15w400.copyWith(color: tint),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.secondaryTextColor),
          ],
        ),
      ),
    );
  }
}
