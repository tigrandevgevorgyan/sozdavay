import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Инициализируем SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();

  // Регистрируем SharedPreferences как singleton
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);

  // Регистрируем AppPreferences напрямую
  // getIt.registerLazySingleton<AppPreferences>(
  //       () => AppPreferences(sharedPrefs),
  // );
}