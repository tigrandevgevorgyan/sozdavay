import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/home/view_model/home_view_model.dart';
import 'package:level_up/ui/home/widgets/banner_button.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/home/widgets/start_training_banner.dart';
import 'package:level_up/ui/home/widgets/statistics_tile_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        context,
        dataRepository: GetIt.I<IDataRepository>(),
        profileRepository: GetIt.I<IProfileRepository>(),
        localStorage: GetIt.I<ILocalStorage>(),
      ),
      child: Consumer<HomeViewModel>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: AppBarTitle(
                onProfileClicked: () => provider.onProfileClicked(context),
                onLogoutClicked: () => provider.logout(context),
              ),
              centerTitle: true,
              backgroundColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: provider.isLoading
                ? Center(child: LevelUpLoader())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CalendarWidget(
                          height: 55,
                          days: provider.getWeekDays(),
                          onDaySelected: (CalendarDayInfo day, int index) {
                            if (!day.isTrainingDay) return;
                            provider.selectDay(index);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 100,
                          child: StartTrainingBanner(
                            imagePath: Assets.startTrainingBanner,
                            text: provider.selectedTrainingName,
                            onClick: () => provider.onStartWorkoutClicked(context),
                            isActive: provider.selectedTrainingName.isNotEmpty,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Text('Статистика и рейтинг', style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor)),
                        ),
                        Expanded(
                          flex: 131,
                          child: StatisticsTileWidget(
                            monthlyValue: provider.perMonth,
                            yearlyValue: provider.perYear,
                            ratingPercent: provider.rating / 3500.0,
                            rating: provider.rating,
                            level: provider.level,
                            onMonthlyClicked: () {
                              provider.onRatingClicked(context);
                            },
                            onYearlyClicked: () {
                              provider.onRatingClicked(context);
                            },
                            onRatingClicked: () {
                              provider.onRatingClicked(context);
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        Expanded(
                          flex: 100,
                          child: BannerButton(
                            imagePath: Assets.measurementsBanner,
                            text: 'Замеры',
                            onClick: () => provider.onMeasurementsClicked(context),
                          ),
                        ),
                        SizedBox(height: 4),
                        Expanded(
                          flex: 100,
                          child: BannerButton(
                            imagePath: Assets.chatBanner,
                            text: 'Чат с тренером',
                            onClick: provider.onChatClicked,
                          ),
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

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key, required this.onLogoutClicked, required this.onProfileClicked});

  final Function() onProfileClicked;
  final Function() onLogoutClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onProfileClicked,
          child: Image.asset(Assets.settingsIcon, height: 24),
        ),
        Image.asset(Assets.logo, height: 40),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onLogoutClicked,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset(Assets.logoutIcon, height: 24),
          ),
        ),
      ],
    );
  }
}
