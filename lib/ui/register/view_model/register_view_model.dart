import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/services/auth/models/register_options_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/utils/error_utils.dart';
import 'package:level_up/utils/result.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({required this.authRepository}) {
    phoneController = TextEditingController();
    nicknameController = TextEditingController();
    passwordController = TextEditingController();

    phoneController.addListener(_validate);
    nicknameController.addListener(_validate);
    passwordController.addListener(_validate);

    loadOptions();
  }

  final IAuthRepository authRepository;

  late TextEditingController phoneController;
  late TextEditingController nicknameController;
  late TextEditingController passwordController;

  bool isLoadingOptions = false;
  bool isSubmitting = false;

  String? message;
  bool isErrorMessage = true;

  RegisterOptionsResponse? options;

  TrainingPlaceOption? selectedTrainingPlace;
  TrainingGoalOption? selectedTrainingGoal;
  TrainingPerWeekOption? selectedTrainingPerWeek;
  GenderOption? selectedGender;

  bool isFormValid = false;

  String _errorText(Object e) {
    if (e is DioException) {
      final data = e.response?.data;

      // Many backends put errors in: { "message": "..."} or { "error": "..."}
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is Map && data['error'] != null) {
        return data['error'].toString();
      }

      return e.message ?? 'Ошибка сети';
    }
    return e.toString();
  }

  Future<void> loadOptions() async {
    isLoadingOptions = true;
    notifyListeners();

    final result = await authRepository.getRegisterOptions();
    switch (result) {
      case Ok<RegisterOptionsResponse>():
        options = result.value;
        selectedTrainingPlace = null;
        selectedTrainingGoal = null;
        selectedTrainingPerWeek = null;
        selectedGender = null;

        message = null;
        isErrorMessage = false;
        break;

      case Error<RegisterOptionsResponse>():
        message = _errorText(result.error);
        isErrorMessage = true;
        break;
    }

    isLoadingOptions = false;
    _validate();
  }

  void setTrainingPlace(TrainingPlaceOption? v) {
    selectedTrainingPlace = v;
    _validate();
  }

  void setTrainingGoal(TrainingGoalOption? v) {
    selectedTrainingGoal = v;
    _validate();
  }

  void setTrainingPerWeek(TrainingPerWeekOption? v) {
    selectedTrainingPerWeek = v;
    _validate();
  }

  void setGender(GenderOption? v) {
    selectedGender = v;
    _validate();
  }

  /// Same as sign-in: +7 and 10 digits only (length 12).
  String get _phoneNumber =>
      '+7${phoneController.text.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '')}';

  void _validate() {
    final phoneOk = _phoneNumber.length == 12;
    final nicknameOk = nicknameController.text.trim().isNotEmpty;
    final passwordOk = passwordController.text.trim().length == 4;

    final goalOk = selectedTrainingGoal != null;
    final perWeekOk = selectedTrainingPerWeek != null;
    final genderOk = selectedGender != null;

    // training_place might be empty from backend; we will send "0" then
    final placeOk = true;

    final newValid =
        phoneOk && nicknameOk && passwordOk && goalOk && perWeekOk && genderOk && placeOk;

    if (newValid != isFormValid) {
      isFormValid = newValid;
    }
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    message = null;
    isErrorMessage = true;
    notifyListeners();

    FocusScope.of(context).unfocus();

    if (!isFormValid) {
      message = 'Заполните все поля';
      notifyListeners();
      return;
    }

    isSubmitting = true;
    notifyListeners();

    final phone = _phoneNumber;
    final nickname = nicknameController.text.trim();
    final password = passwordController.text.trim();

    final trainingPlace = (selectedTrainingPlace?.id ?? 0).toString();
    final trainingGoal = selectedTrainingGoal!.id.toString();
    final trainingPerWeek = selectedTrainingPerWeek!.value.toString();
    final gender = selectedGender!.value.toString();

    final result = await authRepository.register(
      phone: phone,
      nickname: nickname,
      password: password,
      trainingPlace: trainingPlace,
      trainingGoal: trainingGoal,
      trainingPerWeek: trainingPerWeek,
      gender: gender,
      osType: 'iOS',
      appVersion: '1.0',
    );

    switch (result) {
      case Ok():
        isSubmitting = false;
        notifyListeners();

        if (context.mounted) {
          GoRouter.of(context).go(LevelUpRouter.homePath);
        }
        break;

      case Error():
        final text = _errorText(result.error);
        message = text;
        isErrorMessage = true;

        isSubmitting = false;
        notifyListeners();

        if (context.mounted) {
          ErrorUtils.showError(context, text);
        }
        break;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    nicknameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
