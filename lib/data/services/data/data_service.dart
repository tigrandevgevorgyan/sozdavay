import 'package:dio/dio.dart';
import 'package:level_up/data/services/data/models/rating_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'models/main_response.dart';
import 'models/refresh_response.dart';

part 'data_service.g.dart';

@RestApi()
abstract class DataService {
  factory DataService(Dio dio, {String? baseUrl}) = _DataService;

  @GET('/main')
  Future<MainResponse> getMainScreenInfo();

  @POST('/rating')
  Future<RatingResponse> getRating();

  @POST('/rating')
  Future<RatingResponse> getRatingFiltered(@Body() String rawJson);

  @GET('/refresh')
  Future<RefreshResponse> checkRefresh();
}
