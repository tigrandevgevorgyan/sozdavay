import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/assets/assets.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/home/view_model/home_view_model.dart';
import 'package:level_up/ui/home/widgets/banner_button.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/home/widgets/level_progress_bar.dart';
import 'package:level_up/ui/home/widgets/start_training_banner.dart';
import 'package:level_up/ui/home/widgets/statistics_tile_widget.dart';
import 'package:level_up/ui/rating/widgets/top3_rating_widget.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/workout_repository/workout_repository.dart';

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
        workoutRepository: GetIt.I<IWorkoutRepository>(),
      ),
      child: Consumer<HomeViewModel>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: AppBarTitle(
                onProfileClicked: () async {
                  await provider.openProfileIfUnlocked(context);
                },
                onNotificationsClicked: () => GoRouter.of(context)
                    .push(LevelUpRouter.homePath + LevelUpRouter.notificationsPath),
                showSettings: provider.canEditSettings,
              ),
              centerTitle: true,
              backgroundColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: provider.isLoading
                ? Center(child: LevelUpLoader())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        LevelProgressBar(level: provider.ratingLevel),
                        SizedBox(height: 20),
                        CalendarWidget(
                          height: 55,
                          days: provider.getWeekDays(),
                          onDaySelected: (CalendarDayInfo day, int index) {
                            if (!day.isTrainingDay) return;
                            provider.selectDay(index);
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 140,
                          child: StartTrainingBanner(
                            imagePath: provider.trainingImage,
                            text: provider.selectedTrainingName,
                            onClick: () => provider.onStartWorkoutClicked(context),
                            isActive: provider.selectedTrainingName.isNotEmpty,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 8),
                          child: Text('Статистика и рейтинг', style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor)),
                        ),
                        SizedBox(
                          height: 184,
                          child: StatisticsTileWidget(
                            monthlyValue: provider.perMonth,
                            yearlyValue: provider.perSeason,
                            ratingPercent: provider.seasonLevelRating / 3500.0,
                            rating: provider.seasonRating,
                            level: provider.seasonLevel,
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
                        if (provider.topRatings.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'РЕЙТИНГ ${provider.topRatingsLabel.toUpperCase()}',
                                    style: Style.ablation18w900.copyWith(color: AppColors.primaryTextColor),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => provider.onRatingClicked(context),
                                  child: Text(
                                    'ТОП 100',
                                    style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => provider.onRatingClicked(context),
                            behavior: HitTestBehavior.translucent,
                            child: SizedBox(
                              height: 180,
                              child: Top3RatingWidget(
                                firstPlace: provider.topRatings.isNotEmpty
                                    ? PersonsScores(provider.topRatings[0].name, provider.topRatings[0].totalRating)
                                    : null,
                                secondPlace: provider.topRatings.length > 1
                                    ? PersonsScores(provider.topRatings[1].name, provider.topRatings[1].totalRating)
                                    : null,
                                thirdPlace: provider.topRatings.length > 2
                                    ? PersonsScores(provider.topRatings[2].name, provider.topRatings[2].totalRating)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: BannerButton(
                            imagePath: provider.measurementsImage,
                            text: 'Замеры',
                            onClick: () => provider.onMeasurementsClicked(context),
                          ),
                        ),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 140,
                          child: BannerButton(
                            imagePath: provider.chatImage,
                            text: 'Чат с тренером',
                            onClick: provider.onChatClicked,
                          ),
                        ),
                        SizedBox(height: 16),
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
  const AppBarTitle({
    super.key,
    required this.onNotificationsClicked,
    required this.onProfileClicked,
    required this.showSettings,
  });

  final Function() onProfileClicked;
  final Function() onNotificationsClicked;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showSettings
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onProfileClicked,
                child: Image.asset(Assets.settingsIcon, height: 24),
              )
            : const SizedBox(width: 24, height: 24),
        Image.asset(
          Assets.logo,
          height: 40,
          width: 57,
          fit: BoxFit.contain,
        ),
        // Logout icon replaced with notification bell per Gohar's Home design
        // (Figma 16:183). Logout itself lives in Profile screen now.
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onNotificationsClicked,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryTextColor,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
