import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/utils/result.dart';

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

  String? _error;

  String? get error => _error;

  bool _isActionInProgress = false;

  bool get isActionInProgress => _isActionInProgress;

  String get _phoneNumber => '+7${phoneController.text.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '')}';

  void onSignInClick(BuildContext context) {
    FocusScope.of(context).unfocus();
    _error = null;
    _signIn(context);
  }

  void requestCode() async {
    _isActionInProgress = true;
    notifyListeners();
    final result = await authRepository.requestCode(_phoneNumber);
    switch (result) {
      case Ok<void>():
        // _isCodeRequested = true;
        print("12313");
      case Error<void>():
        _error = result.error.getErrorMessage();
    }
    _isActionInProgress = false;
    _checkIsFormValid();
    notifyListeners();
  }

  void _signIn(BuildContext context) async {
    String code = _codeController.text;
    _isActionInProgress = true;
    notifyListeners();
    final result = await authRepository.signIn(_phoneNumber, code);
    switch (result) {
      case Ok<AccessTokenResponse>():
        final firstLoginResult = await authRepository.isFirstLogin();
        bool isFirst = false;

        if (firstLoginResult is Ok<bool>) {
          isFirst = firstLoginResult.value;
        }
        // final testProfile = await profileRepository.getProfile(); //TODO: remove!!!!!!!!!!!!!!!!!!!!!!!!
        if (isFirst) {
          await authRepository.markFirstLoginShown();
          if (context.mounted) {
            GoRouter.of(context).go(LevelUpRouter.signInPath + LevelUpRouter.profilePreferencesPath, extra: false);
          }
        } else {
          if (context.mounted) {
            GoRouter.of(context).go(LevelUpRouter.homePath);
          }
        }
      case Error<AccessTokenResponse>():
        _error = result.error.getErrorMessage();
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
