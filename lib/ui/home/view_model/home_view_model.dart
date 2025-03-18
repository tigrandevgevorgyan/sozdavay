import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/home/widgets/calendar_widget.dart';
import 'package:level_up/ui/text_editing_screen/text_editing_screen.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(BuildContext context, {required this.profileRepository}) {
    _init(context);
  }

  final IProfileRepository profileRepository;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  UserProfileExtendedResponse? _profile;

  void _init(BuildContext context) {
    _loadProfile(context);
  }

  void _loadProfile(BuildContext? context) async {
    final profile = await profileRepository.getProfile();
    switch (profile) {
      case Ok<UserProfileExtendedResponse>():
        _profile = profile.value;
      case Error<UserProfileExtendedResponse>():
        if (context != null && context.mounted) {
          ErrorUtils.showError(context, profile.error.getErrorMessage());
        }
    }
    _isLoading = false;
    notifyListeners();
  }

  void onRatingClicked(BuildContext context) {
    GoRouter.of(context).go(LevelUpRouter.homePath + LevelUpRouter.ratingPath);
  }

  void onMeasurementsClicked(BuildContext context) {
    final params = TextEditingScreenParams(title: 'Замеры', initialText: _profile?.data.measurements ?? "", onTextUpdated: _updateMeasurements);
    GoRouter.of(context).push(LevelUpRouter.textEditingPath, extra: params);
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

  List<CalendarDayInfo> getWeekDays() {
    final List<CalendarDayInfo> result = [];
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final dayOfWeek = monday.add(Duration(days: i));
      result.add(CalendarDayInfo(_getDayName(dayOfWeek.weekday), dayOfWeek.day, i % 2 == 0, dayOfWeek.day == today.day));
    }
    return result;
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'ВС';
    }
    return '?';
  }
}
