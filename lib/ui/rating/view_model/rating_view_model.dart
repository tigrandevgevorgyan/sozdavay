import 'package:flutter/widgets.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/data/models/rating_response.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/ui/core/common_widgets/options_dialog.dart';
import 'package:level_up/ui/profile_preferences/view_model/profile_preferences_view_model.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class RatingViewModel extends ChangeNotifier {
  final IDataRepository dataRepository;
  final IProfileRepository profileRepository;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  RatingResponse? _ratingInfo;

  final _categoryDialogContent = PreferencesOptionsDialogContent('Выберите категорию');

  final _periodDialogContent = PreferencesOptionsDialogContent('Выберите Период');

  int? _categorySelection;

  String? get categorySelection => _categoryDialogContent.getOptionById(_categorySelection);

  int? _periodSelection;

  String? get periodSelection => _periodDialogContent.getOptionById(_periodSelection);

  int? _myId;

  final List<PersonRating> _generatedRatings = [];

  List<PersonRating> get ratings => List.unmodifiable(_generatedRatings);

  PersonRating? get myRating => _generatedRatings.where((rating) => rating.isMyProfile).firstOrNull;

  RatingViewModel(BuildContext context, this.dataRepository, this.profileRepository) {
    _init(context);
  }

  void onCategoryClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, categorySelection, _categoryDialogContent.title, _categoryDialogContent.optionsValues);
    if (result != null) {
      _categorySelection = _categoryDialogContent.getIdByValue(result);
      notifyListeners();
      if (context.mounted) {
        _tryLoadFilteredRating(context);
      }
    }
  }

  void onPeriodClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, periodSelection, _periodDialogContent.title, _periodDialogContent.optionsValues);
    if (result != null) {
      _periodSelection = _periodDialogContent.getIdByValue(result);
      notifyListeners();
      if (context.mounted) {
        _tryLoadFilteredRating(context);
      }
    }
  }

  void _init(BuildContext context) async {
    await _loadProfile(context);
    if (context.mounted) {
      await _loadRating(context);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadRating(BuildContext context) async {
    final result = await dataRepository.getRatingInfo();
    switch (result) {
      case Ok<RatingResponse>():
        _ratingInfo = result.value;

        final categories = result.value.categories;
        _categoryDialogContent.setOptions(categories);
        _categoryDialogContent.prependAllOption(name: 'Все категории', id: 0);

        _periodDialogContent.setOptions(
          result.value.periods.map((period) => period.toIdNamePair()).toList(),
        );
        _generateLocalRating();
      case Error<RatingResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
  }

  Future<void> _loadProfile(BuildContext context) async {
    final profileResult = await profileRepository.getProfile();
    switch (profileResult) {
      case Ok<UserProfileExtendedResponse>():
        _myId = profileResult.value.data.id;
      case Error<UserProfileExtendedResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, profileResult.error.getErrorMessage());
        }
    }
  }

  void _generateLocalRating() {
    if (_ratingInfo == null) {
      return;
    }
    _generatedRatings.clear();
    int position = 0;
    for (UserRating userRating in _ratingInfo!.rating) {
      ++position;
      _generatedRatings.add(PersonRating(position, userRating.name, userRating.totalRating, userRating.label, userRating.userId == _myId));
    }
  }

  Future<void> _tryLoadFilteredRating(BuildContext context) async {
    if (_categorySelection == null || _periodSelection == null) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    final result = await dataRepository.getRatingInfoFiltered(_categorySelection!, _periodSelection!);
    switch (result) {
      case Ok<RatingResponse>():
        _ratingInfo = result.value;
        _generateLocalRating();
        notifyListeners();
      case Error<RatingResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
    _isLoading = false;
    notifyListeners();
  }
}

class PersonRating {
  final int position;
  final String name;
  final int rating;
  final String tier;
  final bool isMyProfile;

  PersonRating(this.position, this.name, this.rating, this.tier, this.isMyProfile);
}
