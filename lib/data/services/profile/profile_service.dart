import 'package:dio/dio.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_service.g.dart';

@RestApi()
abstract class ProfileService {
  factory ProfileService(Dio dio, {String? baseUrl}) = _ProfileService;

  @GET('/profile')
  Future<UserProfileExtendedResponse> getProfile();

  @POST('/profile/measurements')
  Future<UserProfileShortResponse> updateMeasurements(@Field() String measurements);

  @POST('/profile/records')
  Future<UserProfileShortResponse> updateRecords(@Field() String records);

  @POST('/profile')
  Future<UserProfileShortResponse> updateProfile({
    @Field() required String name,
    @Field() String? nickname,
    @Field() required int sex,
    @Field() int category = 1,
    @Field() required int days,
    @Field() required int experience,
    @Field() required int goal,
    @Field() int? priority,
  });
}
