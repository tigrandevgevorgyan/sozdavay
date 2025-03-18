import 'package:dio/dio.dart';
import 'package:level_up/data/services/profile/models/user_profile_response.dart';
import 'package:level_up/data/services/profile/profile_service.dart';
import 'package:level_up/utils/result.dart';

abstract class IProfileRepository {
  Future<Result<UserProfileExtendedResponse>> getProfile();

  Future<Result<UserProfileExtendedResponse>> reloadProfile();

  Future<Result<UserProfileShortResponse>> updateProfile(String sex, int days, int experience, int goals, int? priority);

  Future<Result<UserProfileShortResponse>> updateMeasurements(String measurements);

  Future<Result<UserProfileShortResponse>> updateRecords(String records);
}

class ProfileRepositoryImpl extends IProfileRepository {
  final ProfileService _profileService;

  UserProfileExtendedResponse? _profileResponse;

  ProfileRepositoryImpl({required ProfileService profileService}) : _profileService = profileService;

  @override
  Future<Result<UserProfileExtendedResponse>> getProfile() async {
    if (_profileResponse != null) {
      return Future.value(Result.ok(_profileResponse!));
    }
    return reloadProfile();
  }

  @override
  Future<Result<UserProfileExtendedResponse>> reloadProfile() async {
    try {
      final result = await _profileService.getProfile();
      _profileResponse = result;
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserProfileShortResponse>> updateProfile(String sex, int days, int experience, int goals, int? priority) async {
    try {
      UserProfileShortResponse result;
      if (priority == null) {
        result = await _profileService.updateProfile(sex, days, experience, goals);
      } else {
        result = await _profileService.updateProfile(sex, days, experience, goals, priority);
      }
      if (_profileResponse != null) {
        _profileResponse!.data = result.data;
      }
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserProfileShortResponse>> updateRecords(String records) async {
    try {
      final result = await _profileService.updateRecords(records);
      if (_profileResponse != null) {
        _profileResponse!.data = result.data;
      }
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<UserProfileShortResponse>> updateMeasurements(String measurements) async {
    try {
      final result = await _profileService.updateMeasurements(measurements);
      if (_profileResponse != null) {
        _profileResponse!.data = result.data;
      }
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
