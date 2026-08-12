import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/achievement.dart';
import 'package:level_up/ui/achievements/view_model/achievements_view_model.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/network_asset.dart';
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
    // Only granted achievements open the detail dialog — locked ones don't
    // have share data on the backend, so opening would just show empty state.
    return InkWell(
      onTap: granted
          ? () => showDialog<void>(
                context: context,
                barrierColor: Colors.black87,
                builder: (_) => _AchievementDetailDialog(achievement: achievement),
              )
          : null,
      borderRadius: BorderRadius.circular(10),
      child: _CardBody(achievement: achievement, granted: granted),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.achievement, required this.granted});
  final Achievement achievement;
  final bool granted;

  @override
  Widget build(BuildContext context) {
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
                  ? NetworkAsset(
                      achievement.iconUrl!,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
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

/// Achievement detail modal per Gohar's Achievements design (Figma 47:243).
/// Opens when the user taps a granted achievement card. Fetches the share
/// payload from `/achievements/{id}/share-payload` and lets them copy a
/// pre-composed brag text to the clipboard.
class _AchievementDetailDialog extends StatefulWidget {
  const _AchievementDetailDialog({required this.achievement});

  final Achievement achievement;

  @override
  State<_AchievementDetailDialog> createState() => _AchievementDetailDialogState();
}

class _AchievementDetailDialogState extends State<_AchievementDetailDialog> {
  Map<String, dynamic>? _payload;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = GetIt.I<IGamificationRepository>();
      _payload = await repo.getAchievementSharePayload(widget.achievement.id);
    } catch (_) {
      // Soft-fail: dialog still renders with the data from the card itself.
    }
    if (mounted) setState(() => _loading = false);
  }

  String _composeShareText() {
    final p = _payload;
    final name = (p?['title'] as String?) ?? widget.achievement.name;
    final points = (p?['creator_points_reward'] as int?) ?? widget.achievement.creatorPointsReward;
    final nickname = p?['customer_nickname'] as String?;
    final pointsLine = points > 0 ? ' +$points баллов' : '';
    final nickPart = (nickname != null && nickname.isNotEmpty) ? '$nickname получил' : 'Я получил';
    return '$nickPart достижение «$name» в Создавай!$pointsLine';
  }

  String? _grantedDate() {
    final iso = (_payload?['granted_at'] as String?) ?? widget.achievement.grantedAt;
    if (iso == null) return null;
    final dt = DateTime.tryParse(iso);
    if (dt == null) return null;
    final l = dt.toLocal();
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    return '${l.day} ${months[l.month - 1]} ${l.year}';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievement;
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.primaryTextColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Text(
              a.name.toUpperCase(),
              style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              textAlign: TextAlign.center,
            ),
            if (_grantedDate() != null) ...[
              const SizedBox(height: 4),
              Text(
                _grantedDate()!,
                style: Style.outfit14w400.copyWith(color: AppColors.secondaryTextColor),
              ),
            ],
            const SizedBox(height: 24),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputBackgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: a.iconUrl != null && a.iconUrl!.isNotEmpty
                  ? NetworkAsset(
                      a.iconUrl!,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.emoji_events,
                        color: AppColors.activeButtonColor,
                        size: 64,
                      ),
                    )
                  : Icon(Icons.emoji_events, color: AppColors.activeButtonColor, size: 64),
            ),
            if (a.description != null && a.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                a.description!,
                style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                textAlign: TextAlign.center,
              ),
            ],
            if (a.creatorPointsReward > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.activeButtonColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${a.creatorPointsReward} баллов',
                  style: Style.ablation14w900.copyWith(color: AppColors.errorMessagePositive),
                ),
              ),
            ],
            const SizedBox(height: 24),
            LevelUpButton(
              text: _loading ? 'Загрузка...' : 'Поделиться',
              buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
              onClick: _loading
                  ? () {}
                  : () async {
                      await Clipboard.setData(ClipboardData(text: _composeShareText()));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Текст скопирован — поделитесь с друзьями',
                              style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                            ),
                            backgroundColor: AppColors.backgroundContentColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
