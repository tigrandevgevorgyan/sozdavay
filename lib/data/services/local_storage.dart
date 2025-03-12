import 'package:level_up/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalStorage {
  Future<Result<String?>> getAccessToken();

  Future<Result<void>> saveAccessToken(String token);

  Future<Result<void>> clearAccessToken();
}

class LocalStorageImpl extends ILocalStorage {
  static const _tokenKey = 'access_token';

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      return Result.ok(sp.getString(_tokenKey));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> saveAccessToken(String token) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString(_tokenKey, token);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> clearAccessToken() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.remove(_tokenKey);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
