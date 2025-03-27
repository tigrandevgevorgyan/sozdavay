import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/services/local_storage.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/splash/view_model/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(context, GetIt.I<ILocalStorage>()),
      child: Consumer<SplashViewModel>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Image(image: AssetImage(Assets.logo)),
            ),
          );
        },
      ),
    );
  }
}
