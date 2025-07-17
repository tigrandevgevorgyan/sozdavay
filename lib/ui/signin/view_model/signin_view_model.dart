import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/utils/result.dart';
import '../../../utils/error_utils.dart';
import '../../profile_preferences/view_model/profile_preferences_view_model.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel({required this.authRepository, required this.profileRepository}) {
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _phoneController.addListener(_checkIsFormValid);
    _codeController.addListener(_checkIsFormValid);
  }

  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;

  late TextEditingController _phoneController;
  late TextEditingController _codeController;

  bool _isFormValid = false;

  TextEditingController get phoneController => _phoneController;

  TextEditingController get codeController => _codeController;

  bool get isScreenReady => _isFormValid;

  String? _message;
  bool _isErrorMessage = true;

  String? get message => _message;
  bool get isErrorMessage => _isErrorMessage;

  bool _isActionInProgress = false;

  bool get isActionInProgress => _isActionInProgress;

  late int _planType;

  int get planType => _planType;

  bool get hasWorkoutPlan {
    return _planType == 2;
  }

  String get _phoneNumber => '+7${phoneController.text.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '')}';

  void onSignInClick(BuildContext context) {
    _message = null;
    _isErrorMessage = true;

    FocusScope.of(context).unfocus();
    _signIn(context);
  }

  void requestCode() async {
    _message = null;
    _isErrorMessage = true;

    if (_phoneController.text.isEmpty) {
      _message = 'Введите номер';
      notifyListeners();
      return;
    }
    if (_phoneNumber.length != 12) {
      _message = 'Введите номер полностью';
      notifyListeners();
      return;
    }
    _isActionInProgress = true;
    notifyListeners();
    final result = await authRepository.requestCode(_phoneNumber);
    switch (result) {
      case Ok<void>():
        _message = 'В течение минуты позвоним и продиктуем код';
        _isErrorMessage = false;
        break;
      case Error<void>():
        _message = result.error.getErrorMessage();
        break;
    }
    _isActionInProgress = false;
    notifyListeners();
  }

  void _signIn(BuildContext context) async {
    String code = _codeController.text;
    _isActionInProgress = true;
    notifyListeners();
    final result = await authRepository.signIn(_phoneNumber, code);
    switch (result) {
      case Ok<AccessTokenResponse>():
        final profileResult = await profileRepository.getProfile();
        switch (profileResult) {
          case Ok<UserProfileExtendedResponse>():
            final profile = profileResult.value.data;
            _planType = profile.planType;
            final isProfileNotFull = (profile.goal == null || profile.days == null);
            if (context.mounted) {
              if (!hasWorkoutPlan && isProfileNotFull) {
        GoRouter.of(context).go(LevelUpRouter.signInPath + LevelUpRouter.profilePreferencesPath,
              extra: ProfilePreferencesParams(
              hasWorkoutPlan: hasWorkoutPlan,
              isFirstLogin: false,
              isAfterLogin: true,
            ),);
              } else {
                GoRouter.of(context).go(LevelUpRouter.homePath);
              }
            }
            break;
          case Error<UserProfileExtendedResponse>():
            if (context.mounted) {
              ErrorUtils.showError(context, profileResult.error.getErrorMessage());
            }
        }
        break;
      case Error<AccessTokenResponse>():
        _message = result.error.getErrorMessage();
        if (result.error is UserNotFoundError) {
          await authRepository.deauthorize();
          _message = 'Пользователь не найден';
          _phoneController.clear();
          _codeController.clear();
        }
        break;
    }
    _isActionInProgress = false;
    notifyListeners();
  }

  void _checkIsFormValid() {
    final isFormValid = _phoneNumber.length == 12 && (codeController.text.length == 4);
    if (isFormValid != _isFormValid) {
      _isFormValid = isFormValid;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _codeController.dispose();
  }
}
