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

  List<int> _selectedCategories = [];

  List<RatingResponse> _ratingInfoList = [];

  String get categoriesDisplayText {

    final selectedNames = _selectedCategories
        .map((id) => _categoryDialogContent.getOptionById(id))
        .whereType<String>()
        .toList();

    if (_selectedCategories.contains(0) || _selectedCategories.isEmpty || selectedNames.isEmpty) {
      return 'Все категории';
    }

    if (selectedNames.length == 1) {
      return selectedNames.first;
    } else {
      return selectedNames.map((name) => _shortenCategoryName(name)).join(', ');
    }
  }

  String _shortenCategoryName(String fullName) {

    String shortened = fullName
        .replaceAll('Женский', 'Ж')
        .replaceAll('Мужской', 'М');

    shortened = shortened.replaceAll(RegExp(r'\s+'), ' ').trim();

    return shortened;
  }

  RatingViewModel(BuildContext context, this.dataRepository, this.profileRepository) {
    _init(context);
  }

  void onCategoryClicked(BuildContext context) async {
    final previouslySelected = _selectedCategories;

    final result = await OptionsDialog.showDialog(
      context,
      previouslySelected
          .map((id) => _categoryDialogContent.getOptionById(id))
          .whereType<String>()
          .toList(),
      _categoryDialogContent.title,
      _categoryDialogContent.optionsValues,
      maxSelected: 3,
      hasAllOption: true,
    );

    if (result != null && result.isNotEmpty) {
      final selected = result
          .map((value) => _categoryDialogContent.getIdByValue(value))
          .whereType<int>()
          .toList();

      _selectedCategories = selected;

      notifyListeners();

      if (context.mounted) {
        _tryLoadFilteredRating(context);
      }
    }
  }

  void onPeriodClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(
        context, periodSelection != null ? [periodSelection!] : [], _periodDialogContent.title, _periodDialogContent.optionsValues, maxSelected: 1);
    if (result != null) {
      _periodSelection = _periodDialogContent.getIdByValue(result.first);
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
        _categorySelection = 0;
        _selectedCategories = [0];
        final periodOptions = result.value.periods
            .map((period) {
          final newName = period.label == 'Год' ? 'Сезон' : period.label;
          return IdNamePairWithPriority(period.id, newName);
        }).toList();

        _periodDialogContent.setOptions(periodOptions);
        _periodSelection = _periodDialogContent.getIdByValue('Сезон');

        _ratingInfoList = [_ratingInfo!];
        _generateLocalRating();
      case Error<RatingResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
    notifyListeners();
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
    _generatedRatings.clear();

    if (_ratingInfoList.isEmpty) return;

    final Map<int, UserRating> uniqueUsers = {};

    for (final response in _ratingInfoList) {
      for (final user in response.rating) {
        uniqueUsers[user.userId] = user;
      }
    }

    final sorted = uniqueUsers.values.toList()
      ..sort((a, b) => b.totalRating.compareTo(a.totalRating));

    int position = 1;

    for (final user in sorted) {
      _generatedRatings.add(
        PersonRating(
          position++,
          user.name,
          user.totalRating,
          user.label,
          user.userId == _myId,
        ),
      );
    }
  }

  Future<void> _tryLoadFilteredRating(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final categoriesToLoad = _selectedCategories.isEmpty ? [0] : _selectedCategories;

    final results = await Future.wait(
      categoriesToLoad.map(
            (categoryId) => dataRepository.getRatingInfoFiltered(
          categoryId,
          _periodSelection ?? 0,
        ),
      ),
    );
    final List<RatingResponse> successful = [];
    for (final result in results) {
      switch (result) {
        case Ok<RatingResponse>():
          successful.add(result.value);
        case Error<RatingResponse>():
          if (context.mounted) {
            ErrorUtils.showError(context, result.error.getErrorMessage());
          }
      }
    }

    if (successful.isNotEmpty) {
      _ratingInfoList = successful;
      _generateLocalRating();
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
