import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/common_widgets/options_dialog.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';
import '../../../data/app_preferences.dart';
import '../../../data/repositories/data_repository/data_repositry.dart';
import '../../../data/services/data/models/main_response.dart';
import '../../workout/widgets/workout_show_dialog.dart';

class ProfilePreferencesViewModel extends ChangeNotifier {
  final IProfileRepository profileRepository;
  final IDataRepository dataRepository;
  final bool hasWorkoutPlan;
  final bool isFirstLogin;
  final bool isAfterLogin;

  static const String _lockKey = 'lock_changes';
  // bool _lockChanges = false;
  // bool get lockChanges => _lockChanges;
  // bool get isEditingLocked => _lockChanges;

  final levelDialogContent = PreferencesOptionsDialogContent('Ваш Уровень сложности');

  final goalDialogContent = PreferencesOptionsDialogContent('ЦЕль');

  final priorityDialogContent = PreferencesOptionsDialogContent('Место тренировки');

  final trainingWeeklyDialogContent = PreferencesOptionsDialogContent('кол-во тренировок в неделю');

  final categoriesDialogContent = PreferencesOptionsDialogContent('Выберите ваш пол');

  final FocusNode nameFocusNode = FocusNode();

  List<GoalWithPriorities> _allGoals = [];

  List<IdNamePairWithPriority> _allPriorities = [];

  ProfilePreferencesViewModel(BuildContext context, {required this.isAfterLogin, required this.profileRepository, required this.hasWorkoutPlan, required this.dataRepository, required this.isFirstLogin}) {
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

  bool _shouldBlockFocus = false;

  bool get shouldBlockFocus => _shouldBlockFocus;

  DateTime? _paidUntil;

  DateTime? get paidUntil => _paidUntil;

 //  Future<void> _loadLockPreference() async {
 // //   final appPrefs = GetIt.I<AppPreferences>();
 //    //_lockChanges =false ;
 //    // do not notify here eagerly to avoid rebuild during constructor; UI will rebuild on next notify
 //  }

  // Future<void> setLockChanges(bool value) async {
  //   _lockChanges = value;
  //   await GetIt.I<AppPreferences>().setEditingLocked(value);
  //   notifyListeners();
  // }

  void blockFocus() {
    _shouldBlockFocus = true;
  }

  void allowFocus() {
    _shouldBlockFocus = false;
  }

  bool get isPriorityAvailable {
    final goal = goalDialogContent.getById(_goalSelection);
    return goal?.isPriorityAvailable == true;
  }

  void onGenderWeightClicked(BuildContext context) async {
    blockFocus();
    final result = await OptionsDialog.showDialog(context, categorySelection != null ? [categorySelection!] : [], categoriesDialogContent.title, categoriesDialogContent.optionsValues);
    if (result != null) {
      _categorySelection = categoriesDialogContent.getIdByValue(result.first);
      debugPrint('================= [onGenderWeightClicked] selected sex = $_categorySelection (${result.first}) =================');

      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 100));
    allowFocus();
  }

  void onLevelClicked(BuildContext context) async {
    blockFocus();
    final result = await OptionsDialog.showDialog(context, levelSelection != null ? [levelSelection!] : [], levelDialogContent.title, levelDialogContent.optionsValues);
    if (result != null) {
      _levelSelection = levelDialogContent.getIdByValue(result.first);
      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 100));
    allowFocus();
  }

  void onGoalClicked(BuildContext context) async {
    blockFocus();
    final result = await OptionsDialog.showDialog(context, goalSelection != null ? [goalSelection!] : [], goalDialogContent.title, goalDialogContent.optionsValues);

    if (result != null) {
      _goalSelection = goalDialogContent.getIdByValue(result.first);
      _setPriorityOptions();
      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 100));
    allowFocus();
  }

  void onPriorityClicked(BuildContext context) async {
    blockFocus();
    final result = await OptionsDialog.showDialog(context, prioritySelection != null ? [prioritySelection!] : [], priorityDialogContent.title, priorityDialogContent.optionsValues);
    if (result != null) {
      _prioritySelection = priorityDialogContent.getIdByValue(result.first);
      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 100));
    allowFocus();
  }

  void onTrainingWeeklyClicked(BuildContext context) async {
    blockFocus();
    final result = await OptionsDialog.showDialog(context, trainingWeeklySelection != null ? [trainingWeeklySelection!] : [], trainingWeeklyDialogContent.title, trainingWeeklyDialogContent.optionsValues);
    if (result != null) {
      _trainingWeeklySelection = trainingWeeklyDialogContent.getIdByValue(result.first);
      notifyListeners();
    }
    await Future.delayed(Duration(milliseconds: 100));
    allowFocus();
  }

  void onSaveClicked(BuildContext context) async {
    _error = null;
    // if (_lockChanges) {
    //   _error = 'Изменения запрещены';
    //   notifyListeners();
    //   return;
    // }
    notifyListeners();
    if (hasWorkoutPlan) {
      if (_nameController.text.trim().isEmpty || _categorySelection == null) {
        _error = 'Не все поля заполнены';
        notifyListeners();
        return;
      }
    } else {
      if (_nameController.text.trim().isEmpty ||
          _categorySelection == null ||
          _trainingWeeklySelection == null ||
          _levelSelection == null ||
          _goalSelection == null) {
        _error = 'Не все поля заполнены';
        notifyListeners();
        return;
      }
    }
    _isUpdating = true;
    notifyListeners();
    debugPrint('[onSaveClicked] sending: name=${_nameController.text}, sex=${_categorySelection ?? 1}, days=${_trainingWeeklySelection ?? 0}, experience=${_levelSelection ?? 0}, goal=${_goalSelection ?? 0}, priority=${_prioritySelection}');
    final result = await profileRepository.updateProfile(
      _nameController.text,
      _categorySelection ?? 1,
      _trainingWeeklySelection ?? 0,
      _levelSelection ?? 0,
      _goalSelection ?? 0,
      _prioritySelection,
    );
    switch (result) {
      case Ok<UserProfileShortResponse>():
        if (isAfterLogin) {
          GoRouter.of(context).go(LevelUpRouter.homePath);
        } else {
          GoRouter.of(context).pop(true);
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
    if (nameFocusNode.hasFocus) {
      nameFocusNode.unfocus();
    }
    final profile = await profileRepository.reloadProfile();
    switch (profile) {
      case Ok<UserProfileExtendedResponse>():
        _allGoals = profile.value.goals;
        _allPriorities = profile.value.priorities;

        goalDialogContent.setOptions(_allGoals.map((g) => IdNamePairWithPriority(g.id, g.name, isPriorityAvailable: g.isPriorityAvailable)).toList());
        final _sexSelection = profile.value.data.sex ?? 1;
        debugPrint('[_loadProfileAndOptions] sex from profile = $_sexSelection');

        final _originalCategories = [
          IdNamePairWithPriority(1, 'Мужской', isPriorityAvailable: _sexSelection == 1),
          IdNamePairWithPriority(2, 'Женский', isPriorityAvailable: _sexSelection == 2),
        ];
        final _condensedCategories = _originalCategories;
        categoriesDialogContent.setOptions(_condensedCategories);
        // _categorySelection = profile.value.data.category?.id;
        _categorySelection = _sexSelection;
        // Map detailed category (с весом) к двум вариантам: Мужской/Женский
        if (_categorySelection != null) {
          final selectedOriginal = _originalCategories.firstWhere(
            (c) => c.id == _categorySelection,
            orElse: () => IdNamePairWithPriority(-1, ''),
          );
          final base = selectedOriginal.name.trim().split(' ').first.toLowerCase();
          final mapped = _condensedCategories.firstWhere(
            (c) => c.name.toLowerCase() == (base == 'мужской' ? 'мужской' : base == 'женский' ? 'женский' : ''),
            orElse: () => IdNamePairWithPriority(-1, ''),
          );
          if (mapped.id != -1) {
            _categorySelection = mapped.id;
          }
        }
        levelDialogContent.setOptions(profile.value.experiences);
        trainingWeeklyDialogContent.setOptions(profile.value.days);
        _levelSelection = profile.value.data.experience?.id;
        _goalSelection = profile.value.data.goal?.id;
        _prioritySelection = profile.value.data.priority?.id;
        _trainingWeeklySelection = profile.value.data.days;
        _nameController.text = profile.value.data.name;

        _setPriorityOptions();

        if (profile.value.data.paidUntil != null) {
          _paidUntil = DateFormat("yyyy-MM-dd").parse(profile.value.data.paidUntil!);
           // _paidUntil = DateFormat("yyyy-MM-dd").parse('2025-06-16');
          _validUntilDate = DateFormat("dd.MM.yyyy").format(_paidUntil!);
        } else {
          _validUntilDate = '';
        }
        if (profile.value.isHasActiveWorkout == true) {
          showProfileDialog(context);
        }

      case Error<UserProfileExtendedResponse>():
        if (context.mounted) {
          ErrorUtils.showError(context, profile.error.getErrorMessage());
        }
    }
    _isLoading = false;
    notifyListeners();
  }

  bool get isSubscriptionExpired {
    if (paidUntil == null) return true;
    return DateTime.now().isAfter(paidUntil!);
  }

  void _setPriorityOptions() {
    final selectedGoal = _allGoals.firstWhere(
          (g) => g.id == _goalSelection,
      orElse: () => GoalWithPriorities(-1, '', false, []),
    );
    final allowedIds = selectedGoal.priorities;
    final filtered = _allPriorities.where((p) => allowedIds.contains(p.id)).toList();
    priorityDialogContent.setOptions(filtered);

    if (!allowedIds.contains(_prioritySelection)) {
      _prioritySelection = null;
    }
  }

  void showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        return WorkoutShowDialog(
          title: 'Если изменить настройки, данные в активной тренировке будут удалены',
          confirmText: 'Ок',
          onConfirm: () {
            notifyListeners();
          },
        );
      },
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }
}

class PreferencesOptionsDialogContent {
  final String title;
  List<IdNamePairWithPriority> _options = [];

  PreferencesOptionsDialogContent(this.title);

  String _optionsDebug() {
    return _options
        .map((o) => '${o.id}:${o.name}${(o.isPriorityAvailable ?? false) ? "[P]" : ""}')
        .join(', ');
  }

  List<String> get optionsValues => _options.map((option) => option.name).toList();

  bool hasPriorityById(int? id) {
    return _options.firstWhere((option) => option.id == id, orElse: () => IdNamePairWithPriority(-1, "")).isPriorityAvailable ?? false;
  }

  void prependAllOption({required String name, int id = -1}) {
    _options.insert(0, IdNamePairWithPriority(id, name));
    debugPrint('[PreferencesOptionsDialogContent][$title] prependAllOption(name="$name", id=$id) -> count=${_options.length}; items=${_optionsDebug()}');
  }

  void setOptions(List<IdNamePairWithPriority> options) {
    _options = options;
    debugPrint('[PreferencesOptionsDialogContent][$title] setOptions(count=${_options.length}) -> items=${_optionsDebug()}');
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

class ProfilePreferencesParams {
  final bool hasWorkoutPlan;
  final bool isFirstLogin;
  final bool isAfterLogin;

  ProfilePreferencesParams({required this.isAfterLogin, required this.hasWorkoutPlan, required this.isFirstLogin});
}
