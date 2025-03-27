import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up/config/assets.dart';
import 'package:level_up/ui/core/themes/app_colors.dart';
import 'package:level_up/ui/workout/screens/complex_workout_screen.dart';
import 'package:level_up/ui/workout/screens/double_workout_screen.dart';
import 'package:level_up/ui/workout/screens/simple_workout_screen.dart';

class WorkoutBaseScreen extends StatefulWidget {
  const WorkoutBaseScreen({super.key});

  @override
  State<WorkoutBaseScreen> createState() => _WorkoutBaseScreenState();
}

class _WorkoutBaseScreenState extends State<WorkoutBaseScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.backgroundContentColor, toolbarHeight: 0),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _getScreenByIndex(index),
            ),
            BottomBar(
              onLeftArrowClicked: () => _changeIndex(-1),
              onRightArrowClicked: () => _changeIndex(1),
              onHomeClicked: () => GoRouter.of(context).pop(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _getScreenByIndex(int index) {
    switch (index) {
      case 0:
        return SimpleWorkoutScreen();
      case 1:
        return DoubleWorkoutScreen();
      case 2:
        return ComplexWorkoutScreen();
    }
    return SimpleWorkoutScreen();
  }

  void _changeIndex(int increment) {
    setState(() {
      index += increment;
      if (index < 0) {
        index = 0;
      }
      if (index > 2) {
        index = 2;
      }
    });
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.onRightArrowClicked, required this.onLeftArrowClicked, required this.onHomeClicked});

  final Function() onRightArrowClicked;
  final Function() onLeftArrowClicked;
  final Function() onHomeClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      height: 40,
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onLeftArrowClicked,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(Assets.leftArrowIcon),
            ),
          ),
          GestureDetector(
            onTap: onHomeClicked,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(Assets.homeIcon),
            ),
          ),
          GestureDetector(
            onTap: onRightArrowClicked,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(Assets.rightArrowIcon),
            ),
          ),
        ],
      ),
    );
  }
}
