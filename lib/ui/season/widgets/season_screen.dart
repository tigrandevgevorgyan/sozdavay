import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/season_current.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/season/view_model/season_view_model.dart';
import 'package:provider/provider.dart';

class SeasonScreen extends StatelessWidget {
  const SeasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SeasonViewModel>(
      create: (_) => SeasonViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<SeasonViewModel>(
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
                'Сезон',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : vm.season == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Нет активного сезона.',
                            style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : _Body(vm: vm, season: vm.season!),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vm, required this.season});
  final SeasonViewModel vm;
  final SeasonCurrent season;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.activeButtonColor,
      onRefresh: vm.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _HeaderCard(season: season),
          const SizedBox(height: 16),
          if (season.myProgress != null) _ProgressCard(progress: season.myProgress!),
          const SizedBox(height: 16),
          Text(
            'НАГРАДЫ СЕЗОНА',
            style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
          ),
          const SizedBox(height: 8),
          if (season.rewards.isEmpty)
            _empty('Награды этого сезона ещё не объявлены')
          else
            ...season.rewards.map(_RewardTile.new),
        ],
      ),
    );
  }

  Widget _empty(String label) => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.inputBorderColor, width: 1),
        ),
        child: Text(
          label,
          style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
          textAlign: TextAlign.center,
        ),
      );
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.season});
  final SeasonCurrent season;

  @override
  Widget build(BuildContext context) {
    final period = (season.dateStart != null && season.dateEnd != null)
        ? '${_fmt(season.dateStart!)} — ${_fmt(season.dateEnd!)}'
        : '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            season.labelRu ?? 'Текущий сезон',
            style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
          ),
          if (period.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              period,
              style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final l = dt.toLocal();
    return '${l.day.toString().padLeft(2, '0')}.${l.month.toString().padLeft(2, '0')}.${l.year}';
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});
  final MySeasonProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: progress.qualifiedForDraw == true
              ? AppColors.activeButtonColor
              : AppColors.inputBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Мой рейтинг', '★ ${progress.ratingBalance ?? 0}'),
          _row('Текущий уровень', '${progress.currentLevel ?? 0}'),
          if (progress.drawMinLevel != null)
            _row('Минимум для розыгрыша', '${progress.drawMinLevel}'),
          if (progress.drawThresholdPoints != null)
            _row('Порог баллов', '${progress.drawThresholdPoints}'),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                progress.qualifiedForDraw == true ? Icons.check_circle : Icons.lock_outline,
                color: progress.qualifiedForDraw == true
                    ? AppColors.errorMessagePositive
                    : AppColors.secondaryTextColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  progress.qualifiedForDraw == true
                      ? 'Вы участвуете в розыгрыше'
                      : 'Пока не квалифицировались',
                  style: Style.ablation14w900.copyWith(
                    color: progress.qualifiedForDraw == true
                        ? AppColors.errorMessagePositive
                        : AppColors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
              ),
            ),
            Text(
              value,
              style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
            ),
          ],
        ),
      );
}

class _RewardTile extends StatelessWidget {
  const _RewardTile(this.reward);
  final SeasonReward reward;

  @override
  Widget build(BuildContext context) {
    final rank = (reward.rankFrom == reward.rankTo || reward.rankTo == null)
        ? '#${reward.rankFrom ?? '-'}'
        : '#${reward.rankFrom}–#${reward.rankTo}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.inputBorderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.activeButtonColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                rank,
                style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reward.description ?? _labelType(reward.rewardType, reward.rewardValue),
                style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelType(String? t, int? v) {
    switch (t) {
      case 'rating':
        return '★ ${v ?? '-'}';
      case 'creator_points':
        return '${v ?? '-'} очков';
      case 'frame':
        return 'Рамка';
      case 'product':
        return 'Товар';
      default:
        return t ?? '—';
    }
  }
}
