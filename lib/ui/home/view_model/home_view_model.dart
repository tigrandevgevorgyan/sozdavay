import 'dart:ui';
import 'package:flutter/material.dart';
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
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/home_banners_assets.dart';
import '../../../data/services/data/models/main_response.dart';
import '../../../utils/misc_utils.dart';
import '../../core/common_widgets/level_up_button.dart';
import '../../core/themes/text_styles.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    BuildContext context,{
    required this.dataRepository,
    required this.profileRepository,
    required this.localStorage,
      }) {
    _init(context);
  }

  final ILocalStorage localStorage;
  final IProfileRepository profileRepository;
  final IDataRepository dataRepository;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  UserProfileExtendedResponse? _profile;
  MainInfo? _mainInfo;

  late int _planType;
  int get planType => _planType;

  DateTime? _paidUntil;

  DateTime? get paidUntil => _paidUntil;

  late bool _isExpiredDate;
  bool get isExpiredDate => _isExpiredDate;

  late final String trainingImage = HomeBannersAssets.getRandomTrainingImage();

  late final String measurementsImage = HomeBannersAssets.getRandomMeasurementsImage();

  late final String chatImage = HomeBannersAssets.getRandomChatImage();


  String get level => _mainInfo?.label ?? '';

  int get rating => _mainInfo?.levelRating ?? 0;

  int get perMonth => _mainInfo?.workout.month ?? 0;

  int get perYear => _mainInfo?.workout.year ?? 0;

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
    // await localStorage.clearSharedPreferences();
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
    final dayIndex = (_selectedDayIndex ?? DateTime.now().weekday - 1) + 1;
    final result = await GoRouter.of(context).push(LevelUpRouter.homePath + LevelUpRouter.workoutPath, extra: dayIndex) as bool?;
    if ((result ?? false) && context.mounted) {
      await _loadMainInfo(context);
      notifyListeners();
    }
  }

  void onRatingClicked(BuildContext context) {
    GoRouter.of(context).go(LevelUpRouter.homePath + LevelUpRouter.ratingPath);
  }

  void onMeasurementsClicked(BuildContext context) {
    final params = TextEditingScreenParams(title: 'Замеры', initialText: _profile?.data.measurements ?? "", onTextUpdated: _updateMeasurements);
    GoRouter.of(context).push(LevelUpRouter.textEditingPath, extra: params);
  }

  void onChatClicked() {
    launchUrl(Uri.parse('http://t.me/Dryk220lbs'));
  }

  void onProfileClicked(BuildContext context) {
    final hasPlan = hasWorkoutPlan;
    GoRouter.of(context).push(
      LevelUpRouter.homePath + LevelUpRouter.profilePreferencesPath,
      extra: hasPlan,
    );
  }

  void logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final result = await GetIt.I<IAuthRepository>().logout();
    _isLoading = false;
    notifyListeners();
    switch (result) {
      case Ok<void>():
        GetIt.I<IProfileRepository>().onLogout();
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

  Future<bool> _loadProfile(BuildContext? context) async {
    final profile = await profileRepository.getProfile();
    switch (profile) {
      case Ok<UserProfileExtendedResponse>():
        _profile = profile.value;
        _planType = _profile!.data.planType;
        if (_profile!.data.paidUntil != null) {
          // _paidUntil = DateFormat("yyyy-MM-dd").parse('2025-06-16');
          _paidUntil = DateFormat("yyyy-MM-dd").parse(_profile!.data.paidUntil!);
          _isExpiredDate = DateTime.now().isAfter(_paidUntil!);
        }
        return true;
      case Error<UserProfileExtendedResponse>():
        if (context != null && context.mounted) {
          ErrorUtils.showError(context, profile.error.getErrorMessage());
          return false;
        }
    }
    return false;
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
                  color: Color(0xFF141414),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF3C3C3C), width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Подписка закончилась', style: Style.ablation18w900.copyWith(color: Colors.white)),
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
    final mainInfo = await dataRepository.getMainInfo();
    switch (mainInfo) {
      case Ok<MainResponse>():
        _mainInfo = mainInfo.value.data;
      case Error<MainResponse>():

        _mainInfo = _emptyMainInfo();
    }
    initSelectedDayIndex();
    notifyListeners();
  }

  MainInfo _emptyMainInfo() {
    return MainInfo(WorkoutStats(0, 0), List.generate(7, (i) => DayInfo(weekDays[i], '', false)), 0, '', 0);
  }
}
