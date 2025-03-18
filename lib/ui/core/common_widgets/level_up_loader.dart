import 'package:flutter/material.dart';

class LevelUpLoader extends StatelessWidget {
  const LevelUpLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
