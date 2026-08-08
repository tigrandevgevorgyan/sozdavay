import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:level_up/brand/brand_config.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/ui/clans/widgets/clans_list_screen.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/home/widgets/home_screen.dart';
import 'package:level_up/ui/profile/widgets/profile_screen.dart';
import 'package:level_up/ui/shop/widgets/shop_screen.dart';
import 'package:level_up/utils/result.dart';

/// Shell hosting the 5-tab bottom navigation from Gohar's Figma
/// (Магазин / Клан / Главный / Профиль / Телеграм). The first four
/// switch an IndexedStack; Телеграм is a launcher — it opens the coach
/// chat in Telegram and does NOT switch tabs.
class MainTabsShell extends StatefulWidget {
  const MainTabsShell({super.key});

  @override
  State<MainTabsShell> createState() => _MainTabsShellState();
}

class _MainTabsShellState extends State<MainTabsShell> {
  static const int _homeIdx = 2;
  static const int _telegramIdx = 4;

  int _selectedIdx = _homeIdx;
  bool _hasWorkoutPlan = false;

  @override
  void initState() {
    super.initState();
    _resolveWorkoutPlan();
  }

  Future<void> _resolveWorkoutPlan() async {
    try {
      final r = await GetIt.I<IProfileRepository>().getProfile();
      if (!mounted) return;
      if (r is Ok<UserProfileExtendedResponse>) {
        setState(() => _hasWorkoutPlan = r.value.data.planType == 2);
      }
    } catch (_) {
      // Non-fatal: Profile tab still renders, Edit Profile flow is
      // the only place that checks the flag.
    }
  }

  Future<void> _openTelegram() async {
    try {
      final uri = GetIt.I<BrandConfig>().coachChatUrl;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _onTapTab(int i) {
    if (i == _telegramIdx) {
      _openTelegram();
      return;
    }
    if (i != _selectedIdx) setState(() => _selectedIdx = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: _selectedIdx,
        children: [
          const ShopScreen(),
          const ClansListScreen(),
          const HomeScreen(),
          ProfileScreen(hasWorkoutPlan: _hasWorkoutPlan),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _selectedIdx,
        onTap: _onTapTab,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.backgroundContentColor,
      selectedItemColor: AppColors.activeButtonColor,
      unselectedItemColor: AppColors.secondaryTextColor,
      selectedLabelStyle: Style.outfit14w400,
      unselectedLabelStyle: Style.outfit14w400,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Магазин',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Клан',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Главный',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Профиль',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.send_outlined),
          label: 'Телеграм',
        ),
      ],
    );
  }
}
