import 'package:dio/dio.dart';
import 'package:level_up/data/services/auth/auth_service.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/utils/result.dart';
import '../../../config/dio_client.dart';
import 'package:level_up/data/services/auth/models/register_options_response.dart';
import 'package:get_it/get_it.dart';

abstract class IAuthRepository {
  String? get accessToken;

  Future<Result<void>> requestCode(String phoneNumber);

  Future<Result<AccessTokenResponse>> signIn(String phoneNumber, String code);

  Future<Result<void>> logout();

  Future<Result<void>> deauthorize();

  Future<Result<bool>> isFirstLogin();

  Future<Result<void>> markFirstLoginShown();

  Future<Result<RegisterOptionsResponse>> getRegisterOptions();

  Future<Result<AccessTokenResponse>> register({
    required String phone,
    required String nickname,
    required String password,
    required String trainingPlace,
    required String trainingGoal,
    required String trainingPerWeek,
    required String gender,
    required String osType,
    required String appVersion,
  });
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
      final result = await _authService.authConfirm(phoneNumber, code, 'iOS', '1.0');
      _token = result.accessToken;
      if (_token == null) {
        return Result.error(Exception(result.message ?? ' Неизвестная ошибка'));
      }
      await _localStorage.saveAccessToken(_token!);
       try {
        final dio = GetIt.I<Dio>();
        dio.options.headers['Authorization'] = 'Bearer $_token';
        print('AFTER REGISTER header = ${dio.options.headers['Authorization']}');
      } catch (_) {
        // If Dio isn't registered in GetIt, ignore
      }
      return Result.ok(result);
    } on UserNotFoundError catch (e) {
      return Result.error(e);
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

  @override
  Future<Result<bool>> isFirstLogin() {
    return _localStorage.isFirstLogin();
  }

  @override
  Future<Result<void>> markFirstLoginShown() {
    return _localStorage.setFirstLoginShown();
  }

  @override
  Future<Result<RegisterOptionsResponse>> getRegisterOptions() async {
    try {
      final result = await _authService.registerOptions();
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<AccessTokenResponse>> register({
    required String phone,
    required String nickname,
    required String password,
    required String trainingPlace,
    required String trainingGoal,
    required String trainingPerWeek,
    required String gender,
    required String osType,
    required String appVersion,
  }) async {
    try {
      final result = await _authService.register(
        phone,
        nickname,
        password,
        trainingPlace,
        trainingGoal,
        trainingPerWeek,
        gender,
        osType,
        appVersion,
      );

      _token = result.accessToken;
      if (_token == null) {
        return Result.error(Exception(result.message ?? 'Неизвестная ошибка'));
      }
      await _localStorage.saveAccessToken(_token!);

      try {
        final dio = GetIt.I<Dio>();
        dio.options.headers['Authorization'] = 'Bearer $_token';
      } catch (_) {
        // If Dio isn't registered in GetIt, ignore
      }

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
