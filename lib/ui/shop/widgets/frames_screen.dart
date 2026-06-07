import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/avatar_frame.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/shop/view_model/frames_view_model.dart';
import 'package:provider/provider.dart';

class FramesScreen extends StatelessWidget {
  const FramesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FramesViewModel>(
      create: (_) => FramesViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<FramesViewModel>(
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
                'Мои рамки',
                style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
              ),
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    'У вас пока нет рамок. Откройте магазин, чтобы их получить.',
                                    style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: vm.items.length,
                            itemBuilder: (context, i) {
                              return _FrameCard(
                                frame: vm.items[i],
                                onTap: () => vm.equip(vm.items[i]),
                              );
                            },
                          ),
                  ),
          );
        },
      ),
    );
  }
}

class _FrameCard extends StatelessWidget {
  const _FrameCard({required this.frame, required this.onTap});
  final CustomerAvatarFrame frame;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final def = frame.definition;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundContentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: frame.isEquipped ? AppColors.activeButtonColor : AppColors.inputBorderColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputBackgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: def?.imageUrl != null && def!.imageUrl!.isNotEmpty
                  ? Image.network(
                      def.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.collections_bookmark_outlined,
                        color: AppColors.secondaryTextColor,
                        size: 28,
                      ),
                    )
                  : Icon(
                      Icons.collections_bookmark_outlined,
                      color: AppColors.secondaryTextColor,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              def?.name ?? 'Рамка',
              style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (def != null && def.ratingBoostPercent > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '+${def.ratingBoostPercent}% к рейтингу',
                  style: Style.outfit11w300.copyWith(color: AppColors.errorMessagePositive),
                ),
              ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: frame.isEquipped
                    ? AppColors.activeButtonColor
                    : AppColors.inActiveButtonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                frame.isEquipped ? 'Снять' : 'Надеть',
                style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
