import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/clan.dart';
import 'package:level_up/ui/clans/view_model/clans_view_model.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/common_widgets/level_up_text_field.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:provider/provider.dart';

class ClanDetailScreen extends StatelessWidget {
  const ClanDetailScreen({super.key, required this.clanId});
  final int clanId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClanDetailViewModel>(
      create: (_) => ClanDetailViewModel(repo: GetIt.I<IGamificationRepository>(), clanId: clanId),
      child: Consumer<ClanDetailViewModel>(
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
                vm.clan?.name ?? 'Клан',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : vm.clan == null
                    ? Center(
                        child: Text(
                          'Клан не найден',
                          style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                        ),
                      )
                    : _Body(vm: vm, clan: vm.clan!),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vm, required this.clan});
  final ClanDetailViewModel vm;
  final Clan clan;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.activeButtonColor,
      onRefresh: vm.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Header(clan: clan),
          const SizedBox(height: 16),
          _TreasuryCard(
            balance: clan.treasuryBalance,
            isMember: clan.isMember,
            onContribute: () => _showContributeDialog(context, vm),
          ),
          const SizedBox(height: 16),
          _Section(title: 'УЧАСТНИКИ (${clan.members?.length ?? 0}/${clan.slotsTotal})'),
          if (clan.members != null)
            ...clan.members!.map((m) => _MemberTile(member: m)),
          if (clan.members == null || clan.members!.isEmpty)
            _emptyPanel('Участники не загружены'),
          const SizedBox(height: 16),
          _Section(title: 'АКТИВНЫЕ БУСТЕРЫ'),
          if (clan.activeBoosters != null && clan.activeBoosters!.isNotEmpty)
            ...clan.activeBoosters!.map((b) => _BoosterActivationTile(activation: b))
          else
            _emptyPanel('Нет активных бустеров'),
          if (clan.availableBoosterDefinitions != null &&
              clan.availableBoosterDefinitions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _Section(title: 'ДОСТУПНЫЕ БУСТЕРЫ'),
            ...clan.availableBoosterDefinitions!.map(
              (b) => _BoosterDefinitionTile(
                definition: b,
                canBuy: clan.isLeader,
                onBuy: clan.isLeader ? () => vm.buyBoosterCard(b.id) : null,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _ActionButtons(vm: vm, clan: clan),
          if (vm.error != null) ...[
            const SizedBox(height: 12),
            Text(
              vm.error!,
              style: Style.outfit14w300.copyWith(color: AppColors.timerDoneOrangeColor),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyPanel(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.inputBorderColor, width: 1),
        ),
        child: Text(
          label,
          style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
        ),
      );

  void _showContributeDialog(BuildContext context, ClanDetailViewModel vm) {
    final controller = TextEditingController();
    showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundContentColor,
        title: Text(
          'Пополнить казну',
          style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
        ),
        content: LevelUpTextField(
          controller: controller,
          hintText: 'Сумма (минимум 50)',
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Отмена',
              style: Style.outfit14w400.copyWith(color: AppColors.secondaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              final v = int.tryParse(controller.text);
              if (v == null || v < 50) return;
              Navigator.pop(ctx, v);
            },
            child: Text(
              'Пополнить',
              style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive),
            ),
          ),
        ],
      ),
    ).then((amount) {
      if (amount != null) vm.contribute(amount);
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.clan});
  final Clan clan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.inputBackgroundColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: clan.iconUrl != null && clan.iconUrl!.isNotEmpty
                ? Image.network(clan.iconUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.groups, color: AppColors.secondaryTextColor, size: 32))
                : Icon(Icons.groups, color: AppColors.secondaryTextColor, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clan.name,
                  style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
                ),
                if (clan.description != null && clan.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    clan.description!,
                    style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '★ ${clan.ratingCached}',
                  style: Style.outfit15w400.copyWith(color: AppColors.errorMessagePositive),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreasuryCard extends StatelessWidget {
  const _TreasuryCard({
    required this.balance,
    required this.isMember,
    required this.onContribute,
  });
  final int balance;
  final bool isMember;
  final VoidCallback onContribute;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              color: AppColors.errorMessagePositive, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'КАЗНА',
                  style: Style.ablation12w900.copyWith(color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '★ $balance',
                  style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
                ),
              ],
            ),
          ),
          if (isMember)
            TextButton(
              onPressed: onContribute,
              child: Text(
                'Пополнить',
                style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive),
              ),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
        ),
      );
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});
  final ClanMember member;

  @override
  Widget build(BuildContext context) {
    final isLeader = member.role == 'leader';
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
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.inputBackgroundColor,
              backgroundImage: member.customer?.avatarUrl != null
                  ? NetworkImage(member.customer!.avatarUrl!)
                  : null,
              child: member.customer?.avatarUrl == null
                  ? Icon(Icons.person_outline, color: AppColors.secondaryTextColor, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.customer?.displayName ?? 'Участник #${member.customerId}',
                    style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
                  ),
                  Text(
                    'вклад: ★ ${member.totalRatingContributed}',
                    style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                  ),
                ],
              ),
            ),
            if (isLeader)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.activeButtonColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Лидер',
                  style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BoosterActivationTile extends StatelessWidget {
  const _BoosterActivationTile({required this.activation});
  final ClanBoosterActivation activation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.activeButtonColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.flash_on, color: AppColors.errorMessagePositive),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Активный бустер',
                style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            if (activation.expiresAt != null)
              Text(
                'до ${_fmt(activation.expiresAt!)}',
                style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
              ),
          ],
        ),
      ),
    );
  }

  String _fmt(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final l = dt.toLocal();
    return '${l.day.toString().padLeft(2, '0')}.${l.month.toString().padLeft(2, '0')} ${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

class _BoosterDefinitionTile extends StatelessWidget {
  const _BoosterDefinitionTile({
    required this.definition,
    required this.canBuy,
    required this.onBuy,
  });
  final ClanBoosterDefinition definition;
  final bool canBuy;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.inputBorderColor, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    definition.name,
                    style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
                  ),
                  Text(
                    'Карта: ★ ${definition.cardCostRating}  ·  Активация: ★ ${definition.activationCostRating}',
                    style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                  ),
                ],
              ),
            ),
            if (canBuy)
              TextButton(
                onPressed: onBuy,
                child: Text(
                  'Купить',
                  style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.vm, required this.clan});
  final ClanDetailViewModel vm;
  final Clan clan;

  @override
  Widget build(BuildContext context) {
    if (clan.isMember) {
      if (clan.isLeader) {
        return Text(
          'Вы лидер этого клана',
          style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
          textAlign: TextAlign.center,
        );
      }
      return LevelUpButton(
        text: vm.busy ? '...' : 'Покинуть клан',
        buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
        onClick: () => vm.leave(),
      );
    }
    return LevelUpButton(
      text: vm.busy ? '...' : 'Вступить в клан',
      buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
      onClick: () => vm.join(),
    );
  }
}
