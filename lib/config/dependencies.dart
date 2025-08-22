import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/data/repositories/workout_repository/workout_repository.dart';
import 'package:level_up/data/services/auth/auth_service.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/data/services/profile/profile_service.dart';
import 'package:level_up/data/services/workout/workout_service.dart';
import '../assets/assets.dart';
import '../brand/brand_config.dart';
import '../data/services/data/data_service.dart';
import '../ui/core/themes/app_colors.dart';
import 'dio_client.dart';

class Dependencies {
  static Future<void> registerDependencies() async {
    final cfg = await BrandConfig.load();
    GetIt.I.registerSingleton<BrandConfig>(cfg);
    AppColors.init(cfg);
    Assets.init(cfg);
    final localStorage = LocalStorageImpl();
    final dioClient = await DioClient.getDioClient(localStorage);
    GetIt.I.registerSingleton<ILocalStorage>(LocalStorageImpl());
    GetIt.I.registerSingleton<IAuthRepository>(AuthRepository(AuthService(dioClient), localStorage));
    GetIt.I.registerSingleton<IProfileRepository>(ProfileRepositoryImpl(profileService: ProfileService(dioClient)));
    GetIt.I.registerSingleton<IDataRepository>(DataRepositoryImpl(dataService: DataService(dioClient)));
    GetIt.I.registerSingleton<IWorkoutRepository>(WorkoutRepositoryImp(workoutService: WorkoutService(dioClient), localStorage));
  }
}
