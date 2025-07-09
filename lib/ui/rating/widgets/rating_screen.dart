import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:level_up/data/repositories/data_repository/data_repositry.dart';
import 'package:level_up/data/repositories/profile_service/profile_repository.dart';
import 'package:level_up/ui/core/common_widgets/level_up_loader.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/core/themes/text_styles.dart';
import 'package:level_up/ui/profile_preferences/widgets/options_input_field.dart';
import 'package:level_up/ui/rating/view_model/rating_view_model.dart';
import 'package:level_up/ui/rating/widgets/profile_tile.dart';
import 'package:level_up/ui/rating/widgets/top3_rating_widget.dart';
import 'package:provider/provider.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RatingViewModel>(
      create: (BuildContext context) => RatingViewModel(context, GetIt.I<IDataRepository>(), GetIt.I<IProfileRepository>()),
      child: Consumer<RatingViewModel>(builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: Text('Рейтинг', style: Style.ablation18w900),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: provider.isLoading
              ? Center(child: LevelUpLoader())
              : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        Text('Рейтинг по', style: Style.outfit14w400.copyWith(color: AppColors.primaryTextColor)),
                        SizedBox(height: 8),
                        OptionsInputField(
                          hint: 'Категория',
                          value: provider.categoriesDisplayText,
                          onClick: () => provider.onCategoryClicked(context),
                        ),
                        SizedBox(height: 10),
                        OptionsInputField(
                          hint: 'Период',
                          value: provider.periodSelection,
                          onClick: () => provider.onPeriodClicked(context),
                        ),
                        SizedBox(height: 10),
                        if (provider.myRating != null)
                          ProfileTile(
                            name: provider.myRating!.name,
                            position: provider.myRating!.position,
                            score: provider.myRating!.rating,
                            tierName: provider.myRating!.tier,
                            isMyProfile: true,
                          ),
                        SizedBox(height: 20),
                        if (provider.ratings.isNotEmpty)
                          Top3RatingWidget(
                            firstPlace: provider.ratings.isNotEmpty ? PersonsScores(provider.ratings[0].name, provider.ratings[0].rating) : null,
                            secondPlace: provider.ratings.length > 1 ? PersonsScores(provider.ratings[1].name, provider.ratings[1].rating) : null,
                            thirdPlace: provider.ratings.length > 2 ? PersonsScores(provider.ratings[2].name, provider.ratings[2].rating) : null,
                          ),
                        SizedBox(height: 10),
                        provider.ratings.isEmpty
                            ? Center(
                                child: Text('Ничего не найдено', style: Style.outfit16w400),
                              )
                            : Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.ratings.length,
                                  itemBuilder: (context, index) {
                                    PersonRating currentRating = provider.ratings[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: ProfileTile(
                                        name: currentRating.name,
                                        position: currentRating.position,
                                        score: currentRating.rating,
                                        tierName: currentRating.tier,
                                        isMyProfile: currentRating.isMyProfile,
                                      ),
                                    );
                                  },
                                ),
                            ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
        );
      }),
    );
  }
}
