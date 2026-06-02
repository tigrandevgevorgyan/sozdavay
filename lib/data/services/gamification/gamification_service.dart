import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/rating_balance_response.dart';

part 'gamification_service.g.dart';

/// Retrofit interface for the Stream A gamification endpoints (added on the
/// backend across 5 mobile-api(N) commits).
///
/// Only the subset that mobile screens actively consume is covered here.
/// Additional endpoints will be added incrementally as screens land.
///
/// **Important**: after editing this file run:
///   `dart run build_runner build --delete-conflicting-outputs`
/// to regenerate `gamification_service.g.dart`.
@RestApi()
abstract class GamificationService {
  factory GamificationService(Dio dio, {String? baseUrl}) = _GamificationService;

  // ------ Rating ------
  @GET('/rating/balance')
  Future<RatingBalanceResponse> getRatingBalance();
}
