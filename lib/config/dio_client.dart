import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/routing/levelup_router.dart';
import 'package:level_up/utils/result.dart';

class DioClient {
  static Future<Dio> getDioClient(ILocalStorage localStorage) async {
    Map<String, String> headers = {};

    headers['X-Requested-With'] = 'XMLHttpRequest';

    final client = Dio(BaseOptions(
      baseUrl: 'http://176.123.169.218:8080/api',
      connectTimeout: const Duration(milliseconds: 15000),
      //followRedirects: true,
      validateStatus: (status) => (status ?? 200) < 500,
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: headers,
    ));

    final interceptors = client.interceptors;

    interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final Result<String?> tokenResult = await localStorage.getAccessToken();

      if (tokenResult is Ok<String?> && tokenResult.value != null) {
        options.headers['Authorization'] = 'Bearer ${tokenResult.value}';
      }
      return handler.next(options);
    }));
    interceptors.add(LogInterceptor(request: false, requestBody: true, requestHeader: true, responseBody: true, responseHeader: false, logPrint: (text) => print('$text')));
    interceptors.add(InterceptorsWrapper(onResponse: (response, handler) async {
      if (response.data.toString().toLowerCase().contains('пользователь не найден')) {
        await GetIt.I<IAuthRepository>().deauthorize();
        GoRouter.of(LevelUpRouter.instance.context).go(LevelUpRouter.splashPath);
      }
      return handler.next(response);
    }));

    return client;
  }
}

extension ErrorParsing on Exception {
  String getErrorMessage() {
    if (this is DioException) {
      final dioException = this as DioException;
      return dioException.response?.data['message'] ?? 'Неизвестная ошибка при отправке запроса';
    }
    return toString().replaceAll('Exception:', '');
  }
}
