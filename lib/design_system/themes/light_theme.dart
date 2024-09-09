import 'package:flutter/material.dart';

import '../colors/app_color.dart';

class LightTheme {
  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.light,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: AppColors.primary),
      ),
      iconTheme: IconThemeData(
        color: AppColors.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      // buttonTheme: ButtonThemeData(
      //   textTheme: ButtonTextTheme.primary,
      // ),
    );
  }
}
