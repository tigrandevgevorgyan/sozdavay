import 'package:dio/dio.dart';
import 'package:level_up/data/services/auth/models/access_token_response.dart';
import 'package:level_up/data/services/common_models/is_completed_response.dart';
import 'package:retrofit/retrofit.dart';
import 'models/register_options_response.dart';

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

  @GET('/register-options')
  Future<RegisterOptionsResponse> registerOptions();

  @POST('/register')
  Future<AccessTokenResponse> register(
    @Field() String phone,
    @Field() String nickname,
    @Field() String password,
    @Field('training_place') String trainingPlace,
    @Field('training_goal') String trainingGoal,
    @Field('training_per_week') String trainingPerWeek,
    @Field() String gender,
    @Field('os_type') String osType,
    @Field('app_version') String appVersion,
  );
}
