import 'package:flutter/cupertino.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel({required this.authRepository}) {
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _phoneController.addListener(_checkIsFormValid);
    _codeController.addListener(_checkIsFormValid);
  }

  final IAuthRepository authRepository;

  late TextEditingController _phoneController;
  late TextEditingController _codeController;

  bool _isFormValid = false;

  TextEditingController get phoneController => _phoneController;

  TextEditingController get codeController => _codeController;

  bool get isScreenReady => _isFormValid;

  void onSignInClick(BuildContext context) {
    authRepository.requestCode("+79999999999");
    // GoRouter.of(context).go(LevelUpRouter.signInPath + LevelUpRouter.profilePreferencesPath);
  }

  void _checkIsFormValid() {
    final isFormValid = phoneController.text.length == 13 && codeController.text.length == 4;
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
