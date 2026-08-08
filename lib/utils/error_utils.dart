import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorUtils {
  static void showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message ?? 'Ошибка при загрузке данных'),
    ));
  }

  /// Extracts a human-readable message from an exception. For DioException
  /// prefers the server's response.data.message / .error fields — otherwise
  /// falls back to Dio's own message. Non-Dio exceptions return their
  /// toString(). Use everywhere instead of `e.toString()` on catch so users
  /// see backend-provided messages like "Insufficient rating balance: need
  /// 200" rather than Dio's opaque "DioException [bad response]: Данные не
  /// найдены".
  static String extract(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        final msg = data['message'] ?? data['error'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
      return e.message ?? 'Ошибка сети';
    }
    return e.toString();
  }
}
