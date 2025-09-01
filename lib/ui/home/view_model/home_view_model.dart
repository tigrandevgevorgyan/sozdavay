import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../assets/home_banners_assets.dart';
import '../../../brand/brand_config.dart';
import '../../../data/repositories/workout_repository/workout_repository.dart';
import '../../../data/services/common_models/is_completed_response.dart';
import '../../../data/services/data/models/main_response.dart';
import '../../../data/services/data/models/refresh_response.dart';
import '../../../data/services/workout/models/workout_response.dart';
import '../../../utils/misc_utils.dart';
import '../../../utils/timer_state_manager.dart';
import '../../core/common_widgets/level_up_button.dart';
import '../../core/themes/text_styles.dart';
import '../../profile_preferences/view_model/profile_preferences_view_model.dart';
import '../../workout/widgets/workout_show_dialog.dart';
import 'package:path_provider/path_provider.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    BuildContext context, {
    required this.workoutRepository,
    required this.dataRepository,
    required this.profileRepository,
    required this.localStorage,
  }) {
    _init(context);
  }

  final ILocalStorage localStorage;
  final IProfileRepository profileRepository;
  final IDataRepository dataRepository;
  final IWorkoutRepository workoutRepository;

  final cfg = GetIt.I<BrandConfig>();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  UserProfileExtendedResponse? _profile;
  MainInfo? _mainInfo;

  Timer? _refreshTimer;
  bool _isTimerActive = false;

  late int _planType;

  int get planType => _planType;

  DateTime? _paidUntil;

  DateTime? get paidUntil => _paidUntil;

  late bool _isExpiredDate;

  bool get isExpiredDate => _isExpiredDate;

  late final String trainingImage = HomeBannersAssets.getRandomTrainingImage();

  late final String measurementsImage = HomeBannersAssets.getRandomMeasurementsImage();

  late final String chatImage = HomeBannersAssets.getRandomChatImage();


  String get seasonLevel => _mainInfo?.seasonLabel ?? '';

  int get rating => _mainInfo?.rating ?? 0;

  int get seasonLevelRating => _mainInfo?.seasonLevelRating ?? 0;

  int get seasonRating => _mainInfo?.seasonRating ?? 0;

  int get perMonth => _mainInfo?.workout.month ?? 0;

  int get perSeason => _mainInfo?.workout.season ?? 0;

  String get trainingName =>
      _mainInfo?.schedule
          .where(
            (day) => day.isActive,
      )
          .firstOrNull
          ?.name ??
      '';

  bool get hasWorkoutPlan {
    return _planType == 2;
  }

  void _init(BuildContext context) async {
    // localStorage.clearSharedPreferences();
    final isSuccess = await _loadProfile(context);
    if (_isExpiredDate) {
      _showFinalDialog(context);
    }
    if (isSuccess && context.mounted) {
      await _loadMainInfo(context);
    }
    _isLoading = false;
    notifyListeners();
  }

  void startRefreshTimer() {
    if (_isTimerActive) return;
    _isTimerActive = true;

    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
          (_) => _checkRefresh(),
    );
  }

  void stopRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _isTimerActive = false;
  }

  Future<void> _checkRefresh() async {
    try {
      final result = await dataRepository.checkRefresh();
      switch (result) {
        case Ok<RefreshResponse>():
          if (result.value.isNeedToRefresh) {
            await _loadMainInfo(null);
            notifyListeners();
          }
        case Error<RefreshResponse>():
          break;
      }
    } catch (_) {}
  }

  Future<T?> retryUntilSuccess<T>(Future<T> Function() request, {
    Duration delay = const Duration(seconds: 3),
    int maxAttempts = 5,
  }) async {
    int attempts = 0;
    while (true) {
      try {
        return await request();
      } catch (_) {
        if (++attempts >= maxAttempts) return null;
        await Future.delayed(delay);
      }
    }
  }

  Future<void> reloadMainInfo(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await _loadMainInfo(context);

    _isLoading = false;
    notifyListeners();
  }

  int? _selectedDayIndex;

  void selectDay(int index) {
    _selectedDayIndex = index;
    notifyListeners();
  }

  void initSelectedDayIndex() {
    _selectedDayIndex = null;

    if (_mainInfo == null) return;

    final activeIndex = _mainInfo!.schedule.indexWhere((d) => d.isActive);
    if (activeIndex != -1) {
      _selectedDayIndex = activeIndex;
    } else {
      final today = DateTime.now();
      final monday = today.subtract(Duration(days: today.weekday - 1));
      for (int i = 0; i < 7; i++) {
        final dayOfWeek = monday.add(Duration(days: i));
        if (dayOfWeek.year == today.year &&
            dayOfWeek.month == today.month &&
            dayOfWeek.day == today.day) {
          _selectedDayIndex = i;
          break;
        }
      }
    }
    notifyListeners();
  }

  List<CalendarDayInfo> getWeekDays() {
    if (_mainInfo == null) {
      return [];
    }

    final List<CalendarDayInfo> result = [];
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final dayOfWeek = monday.add(Duration(days: i));
      final DayInfo dayInfo = _mainInfo!.schedule[i];
      final bool isToday = dayOfWeek.year == today.year && dayOfWeek.month == today.month && dayOfWeek.day == today.day;
      final isSelected = _selectedDayIndex == i;
      final bool isTrainingDay = dayInfo.name?.isNotEmpty ?? false;

      result.add(CalendarDayInfo(dayInfo.day, dayOfWeek.day, isTrainingDay, isToday, isSelected));
    }
    return result;
  }

  String get selectedTrainingName {
    if (_mainInfo == null) return '';

    final schedule = _mainInfo!.schedule;
    final int todayIndex = DateTime.now().weekday - 1;
    final index = _selectedDayIndex ?? todayIndex;

    if (index < 0 || index >= schedule.length) return '';

    final dayInfo = schedule[index];

    return dayInfo.name ?? '';
  }

  void onStartWorkoutClicked(BuildContext context) async {
    stopRefreshTimer();
    final dayIndex = (_selectedDayIndex ?? DateTime.now().weekday - 1) + 1;
    final result = await workoutRepository.loadWorkout(dayIndex: dayIndex);
    switch (result) {
      case Ok<WorkoutResponse>():
        final actualDayIndex = (result.value.day ?? 1) - 1;
        final workoutId = result.value.workoutId ?? 0;
        final currentWorkoutName = actualDayIndex >= 0 && actualDayIndex < (_mainInfo?.schedule.length ?? 0)
            ? (_mainInfo?.schedule[actualDayIndex].name ?? 'тренировка')
            : 'тренировка';
        if (result.value.day != dayIndex) {
          if (context.mounted) {
            deleteWorkoutAndStartNew(context, workoutId, dayIndex);
          }
        } else {
          if (context.mounted) {
            final completed = await GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.workoutPath, extra: dayIndex) as bool?;
            startRefreshTimer();

            if ((completed ?? false) && context.mounted) {
              await _loadMainInfo(context);
              notifyListeners();
            }
          }
        }
      case Error<WorkoutResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  void deleteWorkoutAndStartNew(BuildContext context, int workoutId, int dayIndex) async {
    final result = await workoutRepository.deleteWorkout(workoutId);
    _isLoading = false;
    notifyListeners();
    switch (result) {
      case Ok<IsCompletedResponse>():
        if (context.mounted) {
          final completed = await GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.workoutPath, extra: dayIndex) as bool?;
          startRefreshTimer();

          if ((completed ?? false) && context.mounted) {
            await _loadMainInfo(context);
            notifyListeners();
          }
        }
        break;
      case Error<IsCompletedResponse>():
        break;
    }
  }

  // void _wrongTrainingDialog(BuildContext context, int workoutId, int dayIndex, String workoutName) {
  //   showDialog(
  //     context: context,
  //     builder: (_) =>
  //         WorkoutShowDialog(
  //           title: 'Тренировка "$workoutName" не завершена. Если в ней были записи - они не сохранятся.',
  //           confirmText: 'Продолжить',
  //           onConfirm: () {
  //             deleteWorkoutAndStartNew(context, workoutId, dayIndex);
  //           },
  //           cancelText: 'Назад',
  //           onCancel: () {
  //             Navigator.of(context).pop();
  //             startRefreshTimer();
  //             },
  //         ),
  //   );
  // }

  void onRatingClicked(BuildContext context) {
    stopRefreshTimer();
    GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.ratingPath)
        .then((_) {
      startRefreshTimer();
    });
  }

  void onMeasurementsClicked(BuildContext context) {
    stopRefreshTimer();
    final params = TextEditingScreenParams(title: 'Замеры', initialText: _profile?.data.measurements ?? "", onTextUpdated: _updateMeasurements);
    GoRouter.of(context).push(LevelUpRouter.textEditingPath, extra: params)
        .then((_) {
      startRefreshTimer();
    });
  }

  Future<void> onChatClicked() async {
    final uri = cfg.coachChatUrl;
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  void onProfileClicked(BuildContext context) {
    stopRefreshTimer();
    final hasPlan = hasWorkoutPlan;
    GoRouter.of(context).push(
      LevelUpRouter.homePath + LevelUpRouter.profilePreferencesPath,
      extra: ProfilePreferencesParams(
        hasWorkoutPlan: hasPlan,
        isFirstLogin: false,
        isAfterLogin: false,
      ),
    ).then((result) {
      if (result == true) {
        _loadMainInfo(context);
      }
      startRefreshTimer();
    });
  }


  Future<void> cleanAppStateOnLogout() async {

    await localStorage.clearSharedPreferences();

    final tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }

    try {
      final notificationPlugin = FlutterLocalNotificationsPlugin();
      await notificationPlugin.cancelAll();
    } catch (_) {}

    TimerStateManager.clearAll();
  }


  void logout(BuildContext context) async {
    stopRefreshTimer();
    _isLoading = true;
    notifyListeners();
    final result = await GetIt.I<IAuthRepository>().logout();
    _isLoading = false;
    notifyListeners();
    switch (result) {
      case Ok<void>():
        GetIt.I<IProfileRepository>().onLogout();
        await cleanAppStateOnLogout();
        if (context.mounted) {
          GoRouter.of(context).go(LevelUpRouter.signInPath);
        }
      case Error<void>():
        if (context.mounted) {
          ErrorUtils.showError(context, 'Не удаётся выйти из профиля');
        }
    }
  }

  Future<Result<bool>> _updateMeasurements(String measurements) async {
    final result = await profileRepository.updateMeasurements(measurements);
    switch (result) {
      case Ok<UserProfileShortResponse>():
        if (LevelUpRouter.instance.context.mounted) {
          _loadProfile(LevelUpRouter.instance.context);
        }
        return Result.ok(true);
      case Error<UserProfileShortResponse>():
        return Result.error(result.error);
    }
  }

  Future<bool> _loadProfile(BuildContext context) async {
    final profile = await retryUntilSuccess(() async {
      final response = await profileRepository.getProfile();
      return switch (response) {
        Ok<UserProfileExtendedResponse> r => r.value,
        Error<UserProfileExtendedResponse> e => throw e.error,
      };
    });
    if (profile != null) {
      _profile = profile;
      _planType = profile.data.planType;
      if (profile.data.paidUntil != null) {
        _paidUntil = DateFormat("yyyy-MM-dd").parse(profile.data.paidUntil!);
        _isExpiredDate = DateTime.now().isAfter(_paidUntil!);
      }
      final profileData = profile.data;
      final isProfileNotFull = (profileData.goal == null || profileData.days == null);
      if (context.mounted) {
        if (!hasWorkoutPlan && isProfileNotFull) {
          GoRouter.of(context).go(LevelUpRouter.signInPath + LevelUpRouter.profilePreferencesPath,
            extra: ProfilePreferencesParams(
              hasWorkoutPlan: hasWorkoutPlan,
              isFirstLogin: false,
              isAfterLogin: true,
            ),);
          return false;
        } else {
          return true;
        }
      }
      return true;
    } else {
      if (context != null && context.mounted) {
        ErrorUtils.showError(context, 'Не удалось загрузить профиль');
      }
      return false;
    }
  }

  void _showFinalDialog(BuildContext screenContext) {
    showDialog(
      context: screenContext,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundContentColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF3C3C3C), width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Подписка закончилась',
                          style: Style.ablation18w900.copyWith(color: Colors.white),
                          textAlign: TextAlign.center),
                      SizedBox(height: 8),
                      Text(
                          'Но это легко исправить! Напишите тренеру, чтобы вернуть доступ',
                          style: Style.outfit16w300.copyWith(color: Color(0xFFECECEC)),
                          textAlign: TextAlign.center
                      ),
                      SizedBox(height: 24),
                      LevelUpButton(
                          text: 'Написать',
                          buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.medium),
                          onClick: () {
                            onChatClicked();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadMainInfo(BuildContext? context) async {
    final result = await retryUntilSuccess<MainResponse>(() async {
      final response = await dataRepository.getMainInfo();
      return switch (response) {
        Ok<MainResponse> r => r.value,
        Error<MainResponse> e => throw e.error,
      };
    });

    if (result != null) {
      _mainInfo = result.data;
      startRefreshTimer();
    } else {
      _mainInfo = _emptyMainInfo();
      if (context != null && context.mounted) {
        ErrorUtils.showError(context, 'Не удалось загрузить данные');
      }
    }
    initSelectedDayIndex();
    notifyListeners();
  }

  MainInfo _emptyMainInfo() {
    return MainInfo(WorkoutStats(0, 0, 0), List.generate(7, (i) => DayInfo(weekDays[i], '', false)), 0, '', 0, 0, 0, '');
  }
}