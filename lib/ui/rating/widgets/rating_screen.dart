import 'package:flutter/material.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/profile_preferences/widgets/options_input_field.dart';
import 'package:level_up/ui/rating/widgets/profile_tile.dart';
import 'package:level_up/ui/rating/widgets/top3_rating_widget.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рейтинг', style: Style.ablation18w900),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Рейтинг по', style: Style.raleway14w400.copyWith(color: AppColors.primaryTextColor)),
              SizedBox(height: 8),
              OptionsInputField(hint: 'Категория', onClick: () {}),
              SizedBox(height: 10),
              OptionsInputField(hint: 'Период', onClick: () {}),
              SizedBox(height: 10),
              ProfileTile(
                name: "Имя Фамилия",
                position: 8,
                score: 5000,
                tierName: 'Легендарный',
                isMyProfile: true,
              ),
              SizedBox(height: 10),
              ProfileTile(
                name: "Имя Фамилия",
                position: 8,
                score: 5000,
                tierName: 'Легендарный',
                isMyProfile: false,
              ),
              SizedBox(height: 10),
              Top3RatingWidget(
                firstPlace: PersonsScores("Александр Петров", 4176),
                secondPlace: PersonsScores("Максим Сидоров", 4176),
                thirdPlace: PersonsScores("Алексей Пономаренко", 4176),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
