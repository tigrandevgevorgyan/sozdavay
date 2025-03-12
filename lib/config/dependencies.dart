import 'package:get_it/get_it.dart';
import 'package:level_up/config/dio_client.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/services/auth/auth_service.dart';
import 'package:level_up/data/services/local_storage.dart';

class Dependencies {
  static Future<void> registerDependencies() async {
    final localStorage = LocalStorageImpl();
    final dioClient = await DioClient.getDioClient(localStorage);
    GetIt.I.registerSingleton<ILocalStorage>(LocalStorageImpl());
    GetIt.I.registerSingleton<IAuthRepository>(AuthRepository(AuthService(dioClient), localStorage));
  }
}
