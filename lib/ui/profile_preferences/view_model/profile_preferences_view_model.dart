import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/common_widgets/options_dialog.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class ProfilePreferencesViewModel extends ChangeNotifier {
  final IProfileRepository profileRepository;
  final bool hasWorkoutPlan;

  final levelDialogContent = PreferencesOptionsDialogContent('Ваш Уровень подготовки');

  final goalDialogContent = PreferencesOptionsDialogContent('ЦЕль');

  final priorityDialogContent = PreferencesOptionsDialogContent('Приоритет в тренировках');

  final trainingWeeklyDialogContent = PreferencesOptionsDialogContent('кол-во тренировок в неделю');
  final categoriesDialogContent = PreferencesOptionsDialogContent('Выберите ваш пол и вес');

  ProfilePreferencesViewModel(BuildContext context, {required this.profileRepository, required this.hasWorkoutPlan}) {
    _nameController = TextEditingController();
    _loadProfileAndOptions(context);
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;

  late TextEditingController _nameController;

  TextEditingController get nameController => _nameController;

  int? _categorySelection;

  String? get categorySelection => categoriesDialogContent.getOptionById(_categorySelection);

  int? _levelSelection;

  String? get levelSelection => levelDialogContent.getOptionById(_levelSelection);

  int? _goalSelection;

  String? get goalSelection => goalDialogContent.getOptionById(_goalSelection);

  int? _prioritySelection;

  String? get prioritySelection => priorityDialogContent.getOptionById(_prioritySelection);

  int? _trainingWeeklySelection;

  String? get trainingWeeklySelection => trainingWeeklyDialogContent.getOptionById(_trainingWeeklySelection);

  String? _error;

  String? get error => _error;

  String _validUntilDate = '';

  String get validUntilDate => _validUntilDate;

  bool get isPriorityAvailable {
    final goal = goalDialogContent.getById(_goalSelection);
    return goal?.isPriorityAvailable == true;
  }

  void onGenderWeightClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, categorySelection, categoriesDialogContent.title, categoriesDialogContent.optionsValues);
    if (result != null) {
      _categorySelection = categoriesDialogContent.getIdByValue(result);
      notifyListeners();
    }
  }

  void onLevelClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, levelSelection, levelDialogContent.title, levelDialogContent.optionsValues);
    if (result != null) {
      _levelSelection = levelDialogContent.getIdByValue(result);
      notifyListeners();
    }
  }

  void onGoalClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, goalSelection, goalDialogContent.title, goalDialogContent.optionsValues);
    if (result != null) {
      _goalSelection = goalDialogContent.getIdByValue(result);
      notifyListeners();
    }
  }

  void onPriorityClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, prioritySelection, priorityDialogContent.title, priorityDialogContent.optionsValues);
    if (result != null) {
      _prioritySelection = priorityDialogContent.getIdByValue(result);
      notifyListeners();
    }
  }

  void onTrainingWeeklyClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, trainingWeeklySelection, trainingWeeklyDialogContent.title, trainingWeeklyDialogContent.optionsValues);
    if (result != null) {
      _trainingWeeklySelection = trainingWeeklyDialogContent.getIdByValue(result);
      notifyListeners();
    }
  }

  void onSaveClicked(BuildContext context) async {
    _error = null;
    notifyListeners();
    if (_categorySelection == null ||
        _trainingWeeklySelection == null ||
        _levelSelection == null ||
        _goalSelection == null ||
        (isPriorityAvailable && _prioritySelection == null)) {
      _error = 'Не все поля заполнены';
      notifyListeners();
      return;
    }
    _isUpdating = true;
    notifyListeners();
    final result = await profileRepository.updateProfile(_categorySelection!, _trainingWeeklySelection!, _levelSelection!, _goalSelection!, _prioritySelection);
    switch (result) {
      case Ok<UserProfileShortResponse>():
        if (context.mounted) {
          GoRouter.of(context).go(LevelUpRouter.homePath);
        }
      case Error<UserProfileShortResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, result.error.getErrorMessage());
        }
    }
    _isUpdating = false;
    notifyListeners();
  }

  void _loadProfileAndOptions(BuildContext context) async {
    final profile = await profileRepository.reloadProfile();
    switch (profile) {
      case Ok<UserProfileExtendedResponse>():
        categoriesDialogContent.setOptions(profile.value.categories);
        levelDialogContent.setOptions(profile.value.experiences);
        goalDialogContent.setOptions(profile.value.goals);
        priorityDialogContent.setOptions(profile.value.priorities);
        trainingWeeklyDialogContent.setOptions(profile.value.days);
        _categorySelection = profile.value.data.category?.id;
        _levelSelection = profile.value.data.experience?.id;
        _goalSelection = profile.value.data.goal?.id;
        _prioritySelection = profile.value.data.priority?.id;
        _trainingWeeklySelection = profile.value.data.days;
        _nameController.text = profile.value.data.name;
        if (profile.value.data.paidUntil != null) {
          DateTime validDateTime = DateFormat("yyyy-MM-dd").parse(profile.value.data.paidUntil!);
          _validUntilDate = DateFormat("dd.MM.yyyy").format(validDateTime);
        } else {
          _validUntilDate = '';
        }
      case Error<UserProfileExtendedResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, profile.error.getErrorMessage());
        }
    }
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class PreferencesOptionsDialogContent {
  final String title;
  List<IdNamePairWithPriority> _options = [];

  PreferencesOptionsDialogContent(this.title);

  List<String> get optionsValues => _options.map((option) => option.name).toList();

  bool hasPriorityById(int? id) {
    return _options.firstWhere((option) => option.id == id, orElse: () => IdNamePairWithPriority(-1, "")).isPriorityAvailable ?? false;
  }

  void setOptions(List<IdNamePairWithPriority> options) {
    _options = options;
  }

  String? getOptionById(int? id) {
    if (id == null) {
      return null;
    }
    return _options.firstWhere((option) => option.id == id, orElse: () => IdNamePairWithPriority(-1, "")).name;
  }

  int? getIdByValue(String value) {
    return _options.firstWhere((option) => option.name == value, orElse: () => IdNamePairWithPriority(-1, "")).id;
  }

  IdNamePairWithPriority? getById(int? id) {
    if (id == null) return null;
    return _options.firstWhere(
          (option) => option.id == id,
      orElse: () => IdNamePairWithPriority(-1, "", isPriorityAvailable: false),
    );
  }
}
