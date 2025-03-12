import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/data/repositories/auth_repository/auth_repository.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/core/ui/level_up_button.dart';
import 'package:level_up/ui/core/ui/level_up_text_field.dart';
import 'package:level_up/ui/signin/view_model/signin_view_model.dart';
import 'package:level_up/utils/phone_mask_formatter.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignInViewModel(authRepository: GetIt.I<IAuthRepository>()),
      child: Consumer<SignInViewModel>(builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Assets.logo),
                    SizedBox(height: 12),
                    LevelUpTextField(
                      controller: provider.phoneController,
                      hintText: 'Введите номер телефона',
                      focusedHintText: '000 000 00 00',
                      keyboardType: TextInputType.number,
                      maxLength: 13,
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Text("+7", style: Style.ablation15w900),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+0-9]')), PhoneMaskFormatter()],
                    ),
                    SizedBox(height: 12),
                    LevelUpTextField(
                      controller: provider.codeController,
                      hintText: 'Введите код-пароль',
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                    ),
                    SizedBox(height: 16),
                    LevelUpButton(
                      isEnabled: provider.isScreenReady,
                      text: "войти",
                      buttonStyle: LevelUpButtonStyle.defaultStyle(ButtonHeight.tall),
                      onClick: () => provider.onSignInClick(context),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
