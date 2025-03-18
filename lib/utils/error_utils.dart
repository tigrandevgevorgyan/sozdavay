import 'package:flutter/material.dart';

class ErrorUtils {
  static void showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message ?? 'Ошибка при загрузке данных'),
    ));
  }
}
