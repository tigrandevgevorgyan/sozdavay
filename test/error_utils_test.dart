import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up/utils/error_utils.dart';

void main() {
  group('ErrorUtils.extract', () {
    RequestOptions req() => RequestOptions(path: '/x');

    test('DioException with response.data.message → returns that message', () {
      final e = DioException(
        requestOptions: req(),
        response: Response(
          requestOptions: req(),
          statusCode: 422,
          data: {'success': false, 'message': 'Insufficient rating balance: have 0, need 200.', 'errors': null},
        ),
      );
      expect(ErrorUtils.extract(e), 'Insufficient rating balance: have 0, need 200.');
    });

    test('DioException with response.data.error → returns that', () {
      final e = DioException(
        requestOptions: req(),
        response: Response(requestOptions: req(), statusCode: 400, data: {'error': 'bad name'}),
      );
      expect(ErrorUtils.extract(e), 'bad name');
    });

    test('DioException with no useful body → falls back to e.message', () {
      final e = DioException(
        requestOptions: req(),
        response: Response(requestOptions: req(), statusCode: 500, data: null),
        message: 'connection timeout',
      );
      expect(ErrorUtils.extract(e), 'connection timeout');
    });

    test('DioException with no message → generic сетевая ошибка', () {
      final e = DioException(requestOptions: req());
      expect(ErrorUtils.extract(e), 'Ошибка сети');
    });

    test('Non-Dio exception → toString', () {
      final e = FormatException('bad json');
      expect(ErrorUtils.extract(e), contains('bad json'));
    });

    test('DioException with data.message that is empty string → falls back', () {
      final e = DioException(
        requestOptions: req(),
        response: Response(requestOptions: req(), statusCode: 500, data: {'message': ''}),
        message: 'fallback msg',
      );
      expect(ErrorUtils.extract(e), 'fallback msg');
    });
  });
}
