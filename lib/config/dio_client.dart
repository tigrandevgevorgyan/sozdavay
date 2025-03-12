import 'package:dio/dio.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/utils/result.dart';

class DioClient {
  static Future<Dio> getDioClient(ILocalStorage localStorage) async {
    Map<String, String> headers = {};

    final Result<String?> tokenResult = await localStorage.getAccessToken();

    if (tokenResult is Ok<String?> && tokenResult.value != null) {
      headers['Authorization'] = 'Bearer $tokenResult.value';
    }
    headers['X-Requested-With'] = 'XMLHttpRequest';

    final client = Dio(BaseOptions(
      baseUrl: 'https://dashboard.levelup-plan.ru/api',
      connectTimeout: const Duration(milliseconds: 15000),
      //followRedirects: true,
      validateStatus: (status) => status == 200,
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: headers,
    ));

    final interceptors = client.interceptors;

    interceptors.add(LogInterceptor(request: false, requestBody: true, requestHeader: false, responseBody: true, responseHeader: false, logPrint: (text) => print('$text')));

    return client;
  }
}
