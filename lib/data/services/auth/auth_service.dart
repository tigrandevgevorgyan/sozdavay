import 'package:dio/dio.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/data/services/common_models/is_completed_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String? baseUrl}) = _AuthService;

  @POST('/auth')
  Future<IsCompletedResponse> auth(@Field() String phone);

  @POST('/auth/confirm')
  Future<AccessTokenResponse> authConfirm(@Field() String phone, @Field() String code, @Field('os_type') String osType, @Field('app_version') String appVersion);

  @POST('/logout')
  Future<IsCompletedResponse> logout();
}
