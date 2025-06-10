import 'package:dio/dio.dart';
import 'package:level_up/data/services/data/models/rating_response.dart';
import 'package:level_up/utils/result.dart';
import '../../services/data/data_service.dart';
import '../../services/data/models/main_response.dart';

abstract class IDataRepository {
  Future<Result<MainResponse>> getMainInfo();

  Future<Result<RatingResponse>> getRatingInfoFiltered(int category, int periods);

  Future<Result<RatingResponse>> getRatingInfo();
}

class DataRepositoryImpl extends IDataRepository {
  final DataService dataService;

  DataRepositoryImpl({required this.dataService});

  @override
  Future<Result<MainResponse>> getMainInfo() async {
    try {
      final result = await dataService.getMainScreenInfo();
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(DioException(
        requestOptions: RequestOptions(path: ''),
        error: e,
      ));
    }
  }

  @override
  Future<Result<RatingResponse>> getRatingInfoFiltered(
      int category, int periods) async {
    try {
      String jsonWithTrailingComma = '''
{
  "customer": 0,
  "category": $category,
  "period": $periods,
}''';

      final result = await dataService.getRatingFiltered(jsonWithTrailingComma);
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<RatingResponse>> getRatingInfo() async {
    try {
      final result = await dataService.getRating();
      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(e);
    }
  }
}
