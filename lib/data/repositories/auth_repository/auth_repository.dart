import 'package:dio/dio.dart';
import 'package:level_up/data/services/auth/auth_service.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/utils/result.dart';

abstract class IAuthRepository {
  String? get accessToken;

  Future<Result<void>> requestCode(String phoneNumber);

  Future<Result<AccessTokenResponse>> signIn(String phoneNumber, String code);

  Future<Result<void>> logout();

  Future<Result<void>> deauthorize();
}

class AuthRepository extends IAuthRepository {
  final AuthService _authService;
  final ILocalStorage _localStorage;

  AuthRepository(this._authService, this._localStorage);

  String? _token;

  @override
  String? get accessToken => _token;

  @override
  Future<Result<void>> requestCode(String phoneNumber) async {
    try {
      await _authService.auth(phoneNumber);
      return Result.ok(Object());
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<AccessTokenResponse>> signIn(String phoneNumber, String code) async {
    try {
      final result = await _authService.authConfirm(phoneNumber, code, 'android', '1.0');
      _token = result.accessToken;
      if (_token == null) {
        return Result.error(Exception(result.message ?? ' Неизвестная ошибка'));
      }
      await _localStorage.saveAccessToken(_token!);
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authService.logout();
      _token = null;
      await _localStorage.clearAccessToken();
      return Result.ok(Object());
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deauthorize() async {
    try {
      _token = null;
      await _localStorage.clearAccessToken();
      return Result.ok(Object());
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
