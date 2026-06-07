import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/gamification/gamification_repository.dart';
import 'package:level_up/data/services/gamification/models/shop_product.dart';
import 'package:level_up/ui/core/common_widgets/level_up_button.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/shop/view_model/shop_view_model.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopViewModel>(
      create: (_) => ShopViewModel(repo: GetIt.I<IGamificationRepository>()),
      child: Consumer<ShopViewModel>(
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
                'Магазин',
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
                                child: Text(
                                  'Товары пока недоступны',
                                  style: Style.outfit15w400.copyWith(color: AppColors.secondaryTextColor),
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
                              childAspectRatio: 0.66,
                            ),
                            itemCount: vm.items.length,
                            itemBuilder: (context, i) {
                              final p = vm.items[i];
                              return _ProductCard(
                                product: p,
                                busy: vm.busy,
                                onBuy: () => _confirmPurchase(context, vm, p),
                              );
                            },
                          ),
                  ),
          );
        },
      ),
    );
  }

  void _confirmPurchase(BuildContext context, ShopViewModel vm, ShopProduct p) {
    final priceText = _formatPrice(p);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundContentColor,
        title: Text(
          'Купить?',
          style: Style.ablation14w900.copyWith(color: AppColors.primaryTextColor),
        ),
        content: Text(
          '${p.name}\nЦена: $priceText',
          style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена',
                style: Style.outfit14w400.copyWith(color: AppColors.secondaryTextColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Купить',
                style: Style.outfit14w400.copyWith(color: AppColors.errorMessagePositive)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) vm.purchase(p.id);
    });
  }

  String _formatPrice(ShopProduct p) {
    final pr = p.pricing;
    if (pr == null) return '—';
    if (pr.moneyRub != null) return '${pr.moneyRub} ₽';
    if (pr.discountedRating != null) return '★ ${pr.discountedRating}';
    if (pr.baseRating != null) return '★ ${pr.baseRating}';
    return '—';
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.busy, required this.onBuy});
  final ShopProduct product;
  final bool busy;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final pr = product.pricing;
    final hasDiscount = pr != null &&
        pr.discountPercent != null &&
        pr.discountPercent! > 0 &&
        pr.baseRating != null &&
        pr.discountedRating != null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundContentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.inputBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.storefront,
                              color: AppColors.secondaryTextColor, size: 32),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.storefront,
                            color: AppColors.secondaryTextColor, size: 32),
                      ),
              ),
              if (hasDiscount)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.timerDoneOrangeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-${pr.discountPercent}%',
                      style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
                    ),
                  ),
                ),
              if (product.vipRequired)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.activeButtonColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'VIP',
                      style: Style.ablation12w900.copyWith(color: AppColors.primaryTextColor),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Style.ablation13w700.copyWith(color: AppColors.primaryTextColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (hasDiscount) ...[
            Text(
              '★ ${pr.baseRating}',
              style: Style.outfit11w300.copyWith(
                color: AppColors.secondaryTextColor,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              '★ ${pr.discountedRating}',
              style: Style.ablation14w900.copyWith(color: AppColors.errorMessagePositive),
            ),
          ] else if (pr != null && pr.moneyRub != null) ...[
            Text(
              '${pr.moneyRub} ₽',
              style: Style.ablation14w900.copyWith(color: AppColors.errorMessagePositive),
            ),
          ] else if (pr != null && pr.baseRating != null) ...[
            Text(
              '★ ${pr.baseRating}',
              style: Style.ablation14w900.copyWith(color: AppColors.errorMessagePositive),
            ),
          ] else
            Text('—', style: Style.outfit11w300.copyWith(color: AppColors.secondaryTextColor)),
          const SizedBox(height: 6),
          LevelUpButton(
            text: busy ? '...' : 'Купить',
            buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
            onClick: onBuy,
          ),
        ],
      ),
    );
  }
}
