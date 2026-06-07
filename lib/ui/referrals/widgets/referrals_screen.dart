import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/referral.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/referrals/view_model/referrals_view_model.dart';
import 'package:provider/provider.dart';

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReferralsViewModel>(
      create: (_) => ReferralsViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<ReferralsViewModel>(
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
                'Рефералы',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : vm.info == null
                    ? Center(
                        child: Text(
                          vm.error ?? 'Не удалось загрузить',
                          style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                        ),
                      )
                    : _Body(vm: vm, info: vm.info!),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.vm, required this.info});
  final ReferralsViewModel vm;
  final ReferralInfo info;

  @override
  Widget build(BuildContext context) {
    if (info.featureEnabled == false) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Реферальная программа сейчас недоступна.',
            style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.activeButtonColor,
      onRefresh: vm.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _CodeCard(code: info.code, onCopy: vm.copyCode),
          const SizedBox(height: 20),
          if (info.referrer != null) ...[
            Text(
              'ВАС ПРИГЛАСИЛ',
              style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
            ),
            const SizedBox(height: 8),
            _PersonTile(
              avatarUrl: info.referrer!.avatarUrl,
              name: info.referrer!.displayName,
              trailing: null,
            ),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              Text(
                'ВЫ ПРИГЛАСИЛИ',
                style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
              ),
              const Spacer(),
              Text(
                '${info.inviteesCount}',
                style: Style.ablation18w900.copyWith(color: AppColors.errorMessagePositive),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (info.invitees.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.backgroundContentColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.inputBorderColor, width: 1),
              ),
              child: Text(
                'Пока никто не присоединился по вашему коду',
                style: Style.outfit14w300.copyWith(color: AppColors.secondaryTextColor),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...info.invitees.map(
              (i) => _PersonTile(
                avatarUrl: i.avatarUrl,
                name: i.displayName,
                trailing: i.joinedAt != null ? _fmtDate(i.joinedAt!) : null,
              ),
            ),
        ],
      ),
    );
  }

  String _fmtDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final l = dt.toLocal();
    return '${l.day.toString().padLeft(2, '0')}.${l.month.toString().padLeft(2, '0')}.${l.year}';
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.code, required this.onCopy});
  final String? code;
  final Future<void> Function() onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.activeButtonColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'ВАШ КОД',
            style: Style.ablation13w700.copyWith(color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 6),
          Text(
            code ?? '—',
            style: Style.ablation32w900.copyWith(color: AppColors.primaryTextColor),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              await onCopy();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Код скопирован',
                      style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                    ),
                    backgroundColor: AppColors.backgroundContentColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: Icon(Icons.copy, color: AppColors.errorMessagePositive, size: 18),
            label: Text(
              'Копировать',
              style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.avatarUrl, required this.name, required this.trailing});
  final String? avatarUrl;
  final String name;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(Icons.person_outline, color: AppColors.secondaryTextColor, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
              ),
          ],
        ),
      ),
    );
  }
}
