import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/home/view_model/home_view_model.dart';
import 'package:level_up/ui/home/widgets/banner_button.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/home/widgets/statistics_tile_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(context, profileRepository: GetIt.I<IProfileRepository>()),
      child: Consumer<HomeViewModel>(builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: AppBarTitle(),
            centerTitle: true,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: provider.isLoading
              ? Center(child: LevelUpLoader())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CalendarWidget(
                          height: 55,
                          days: provider.getWeekDays(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Text('Ноги и пресс', style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor)),
                        ),
                        BannerButton(imagePath: Assets.startTrainingBanner, text: 'НАЧАТЬ ТРЕНИРОВКУ', onClick: () {}),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Text('Статистика и рейтинг', style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor)),
                        ),
                        StatisticsTileWidget(
                          height: 158,
                          monthlyValue: 2,
                          yearlyValue: 12,
                          ratingPercent: 20,
                          rating: 414,
                          level: "Новичок",
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
                        SizedBox(height: 4),
                        BannerButton(imagePath: Assets.measurementsBanner, text: 'Замеры', onClick: () => provider.onMeasurementsClicked(context)),
                        SizedBox(height: 4),
                        BannerButton(imagePath: Assets.chatBanner, text: 'Чат с тренером', onClick: () {}),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(Assets.settingsIcon, height: 24),
        Image.asset(Assets.logo, height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image.asset(Assets.logoutIcon, height: 24),
        ),
      ],
    );
  }
}
