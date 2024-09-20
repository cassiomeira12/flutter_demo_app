import 'package:flutter/material.dart';

import '../colors/app_color.dart';

class DarkTheme {
  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,
      primaryColorDark: AppColors.primary,
      scaffoldBackgroundColor: AppColors.dark,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: AppColors.light),
      ),
      iconTheme: IconThemeData(
        color: AppColors.neutral,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.light,
      ),
      hintColor: AppColors.muted,
      indicatorColor: AppColors.dark,
      canvasColor: AppColors.neutralGray,
      cardColor: AppColors.secondary,
    );
  }
}
