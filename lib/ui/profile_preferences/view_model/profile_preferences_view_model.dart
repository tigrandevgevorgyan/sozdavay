import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/ui/core/ui/options_dialog.dart';

class ProfilePreferencesViewModel extends ChangeNotifier {
  final genderWeightDialogContent = PreferencesOptionsDialogContent(
    'пол и весовая категория',
    ['Женский до 55 кг', 'Женский 55+ кг', 'Мужской до 85 кг', 'Мужской 85+ кг'],
  );

  final levelDialogContent = PreferencesOptionsDialogContent(
    'Ваш Уровень подготовки',
    ['Начинающий', 'Опытный', 'Легендарный'],
  );

  final goalDialogContent = PreferencesOptionsDialogContent(
    'ЦЕль',
    ['Хочу похудеть', 'Поддерживаю форму', 'Набрать вес'],
  );

  final priorityDialogContent = PreferencesOptionsDialogContent(
    'Приоритет в тренировках',
    ['Низ тела', 'Баланс в тренировках', 'Верх тела'],
  );

  final trainingWeeklyDialogContent = PreferencesOptionsDialogContent(
    'кол-во тренировок в неделю',
    ['2 тренировки', '3 тренировки', '4 тренировки'],
  );

  ProfilePreferencesViewModel() {
    _nameController = TextEditingController();
  }

  late TextEditingController _nameController;

  TextEditingController get nameController => _nameController;

  String? _genderWeightSelection;

  String? get genderWeightSelection => _genderWeightSelection;

  String? _levelSelection;

  String? get levelSelection => _levelSelection;

  String? _goalSelection;

  String? get goalSelection => _goalSelection;

  String? _prioritySelection;

  String? get prioritySelection => _prioritySelection;

  String? _trainingWeeklySelection;

  String? get trainingWeeklySelection => _trainingWeeklySelection;

  void onGenderWeightClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, _genderWeightSelection, genderWeightDialogContent.title, genderWeightDialogContent.options);
    if (result != null) {
      _genderWeightSelection = result;
      notifyListeners();
    }
  }

  void onLevelClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, _levelSelection, levelDialogContent.title, levelDialogContent.options);
    if (result != null) {
      _levelSelection = result;
      notifyListeners();
    }
  }

  void onGoalClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, _goalSelection, goalDialogContent.title, goalDialogContent.options);
    if (result != null) {
      _goalSelection = result;
      notifyListeners();
    }
  }

  void onPriorityClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, _prioritySelection, priorityDialogContent.title, priorityDialogContent.options);
    if (result != null) {
      _prioritySelection = result;
      notifyListeners();
    }
  }

  void onTrainingWeeklyClicked(BuildContext context) async {
    final result = await OptionsDialog.showDialog(context, _trainingWeeklySelection, trainingWeeklyDialogContent.title, trainingWeeklyDialogContent.options);
    if (result != null) {
      _trainingWeeklySelection = result;
      notifyListeners();
    }
  }

  void onSaveClicked(BuildContext context) {
    GoRouter.of(context).go(LevelUpRouter.homePath);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class PreferencesOptionsDialogContent {
  final String title;
  final List<String> options;

  PreferencesOptionsDialogContent(this.title, this.options);

  int getIndexOfItem(String item) {
    return options.indexOf(item);
  }
}
