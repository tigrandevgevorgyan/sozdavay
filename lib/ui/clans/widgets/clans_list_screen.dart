import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/clan.dart';
import 'package:level_up/ui/clans/view_model/clans_view_model.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:provider/provider.dart';

class ClansListScreen extends StatelessWidget {
  const ClansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClansListViewModel>(
      create: (_) => ClansListViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<ClansListViewModel>(
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
                'Кланы',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
              actions: [
                if (vm.myClan == null)
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => vm.onCreateClanTap(context),
                  ),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: LevelUpLoader())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          onChanged: vm.onSearchChanged,
                          style: Style.outfit15w400.copyWith(color: AppColors.primaryTextColor),
                          decoration: InputDecoration(
                            hintText: 'Поиск клана',
                            hintStyle: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                            prefixIcon: Icon(Icons.search, color: AppColors.secondaryTextColor),
                            filled: true,
                            fillColor: AppColors.inputBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.inputBorderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.inputBorderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.activeButtonColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.activeButtonColor,
                          onRefresh: vm.refresh,
                          child: vm.items.isEmpty
                              ? ListView(
                                  children: [
                                    const SizedBox(height: 120),
                                    Center(
                                      child: Text(
                                        'Кланы не найдены',
                                        style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                  itemCount: vm.items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, i) {
                                    final c = vm.items[i];
                                    return _ClanTile(
                                      clan: c,
                                      isMine: vm.myClan?.id == c.id,
                                      onTap: () => vm.onOpenClan(context, c.id),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _ClanTile extends StatelessWidget {
  const _ClanTile({required this.clan, required this.isMine, required this.onTap});
  final Clan clan;
  final bool isMine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final slotsLine = clan.slotsUsed != null
        ? '${clan.slotsUsed}/${clan.slotsTotal}'
        : '${clan.slotsTotal} мест';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isMine ? AppColors.activeButtonColor : AppColors.inputBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputBackgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: clan.iconUrl != null && clan.iconUrl!.isNotEmpty
                  ? Image.network(
                      clan.iconUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.groups, color: AppColors.secondaryTextColor),
                    )
                  : Icon(Icons.groups, color: AppColors.secondaryTextColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          clan.name,
                          style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.activeButtonColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Мой',
                            style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '★ ${clan.ratingCached}   ·   $slotsLine',
                    style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.secondaryTextColor, size: 20),
          ],
        ),
      ),
    );
  }
}
