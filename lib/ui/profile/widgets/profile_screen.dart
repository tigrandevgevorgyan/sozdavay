import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
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
                        _SectionHeader(title: 'СЧЕТ'),
                        _AccountLinkRow(
                          icon: Icons.person_outline,
                          label: 'Редактировать профиль',
                          onTap: () => vm.onEditProfileTap(context),
                        ),
                        const SizedBox(height: 24),
                        _SectionHeader(title: 'ОБЩИЙ'),
                        _AccountLinkRow(
                          icon: Icons.support_agent_outlined,
                          label: 'Поддержка',
                          onTap: vm.onSupportTap,
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

class _AccountLinkRow extends StatelessWidget {
  const _AccountLinkRow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.primaryTextColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.secondaryTextColor),
          ],
        ),
      ),
    );
  }
}
