import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/battle_pass.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/shop/view_model/battle_pass_view_model.dart';
import 'package:provider/provider.dart';

class BattlePassScreen extends StatelessWidget {
  const BattlePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BattlePassViewModel>(
      create: (_) => BattlePassViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<BattlePassViewModel>(
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
                'Боевой пропуск',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : vm.bp == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'В этом сезоне нет активного боевого пропуска.',
                            style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : _Body(vm: vm),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vm});
  final BattlePassViewModel vm;

  @override
  Widget build(BuildContext context) {
    final bp = vm.bp!;
    return RefreshIndicator(
      color: AppColors.activeButtonColor,
      onRefresh: vm.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Header(bp: bp, isVip: vm.isVip),
          const SizedBox(height: 12),
          _LegendRow(),
          const SizedBox(height: 8),
          for (final tier in bp.tiers)
            _TierRow(
              tier: tier,
              isVip: vm.isVip,
              busy: vm.busy,
              onClaim: (track) => vm.claim(tier.id, track),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.bp, required this.isVip});
  final BattlePass bp;
  final bool isVip;

  @override
  Widget build(BuildContext context) {
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
            bp.name.toUpperCase(),
            style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
          ),
          if (bp.description != null && bp.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              bp.description!,
              style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isVip ? Icons.workspace_premium : Icons.lock_outline,
                size: 18,
                color: isVip ? AppColors.errorMessagePositive : AppColors.secondaryTextColor,
              ),
              const SizedBox(width: 6),
              Text(
                isVip ? 'VIP активен' : (bp.vipUnlockPriceMoneyRub != null
                    ? 'VIP — ${bp.vipUnlockPriceMoneyRub} ₽'
                    : 'VIP недоступен'),
                style: Style.outfit14w400.copyWith(
                  color: isVip ? AppColors.errorMessagePositive : AppColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: Text(
              'БЕСПЛАТНО',
              textAlign: TextAlign.center,
              style: Style.ablation12w900.copyWith(color: AppColors.secondaryTextColor),
            ),
          ),
          Expanded(
            child: Text(
              'VIP',
              textAlign: TextAlign.center,
              style: Style.ablation12w900.copyWith(color: AppColors.errorMessagePositive),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.tier,
    required this.isVip,
    required this.busy,
    required this.onClaim,
  });
  final BattlePassTier tier;
  final bool isVip;
  final bool busy;
  final void Function(String track) onClaim;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.activeButtonColor,
            ),
            child: Text(
              '${tier.level}',
              style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _RewardSlot(
              reward: tier.free,
              locked: false,
              busy: busy,
              onClaim: () => onClaim('free'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _RewardSlot(
              reward: tier.vip,
              locked: !isVip,
              busy: busy,
              onClaim: () => onClaim('vip'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardSlot extends StatelessWidget {
  const _RewardSlot({
    required this.reward,
    required this.locked,
    required this.busy,
    required this.onClaim,
  });
  final BattlePassReward reward;
  final bool locked;
  final bool busy;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final has = reward.rewardType != null;
    if (!has) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.inputBorderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: Text('—',
            style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor)),
      );
    }
    final canClaim = !reward.claimed && !locked;
    return InkWell(
      onTap: canClaim ? (busy ? null : onClaim) : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: reward.claimed
              ? AppColors.activeButtonColor.withValues(alpha: 0.3)
              : AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: canClaim ? AppColors.errorMessagePositive : AppColors.inputBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              reward.claimed
                  ? Icons.check_circle
                  : (locked ? Icons.lock_outline : Icons.card_giftcard),
              color: reward.claimed
                  ? AppColors.errorMessagePositive
                  : (locked ? AppColors.secondaryTextColor : AppColors.primaryTextColor),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _labelType(reward.rewardType),
                    style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (reward.rewardValue != null)
                    Text(
                      '+${reward.rewardValue}',
                      style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelType(String? t) {
    switch (t) {
      case 'rating':
        return 'Рейтинг';
      case 'creator_points':
        return 'Очки';
      case 'frame':
        return 'Рамка';
      case 'product':
        return 'Товар';
      default:
        return t ?? '—';
    }
  }
}
