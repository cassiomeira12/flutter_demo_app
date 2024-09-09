import 'package:flutter/material.dart';

import '../colors/app_color.dart';

class DarkTheme {
  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.dark,
      textTheme: TextTheme(
        titleLarge: TextStyle(color: AppColors.light),
      ),
      iconTheme: IconThemeData(
        color: AppColors.light,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.light,
      ),
      // indicatorColor: AppColors.statusWarning,
      // iconButtonTheme: IconButtonThemeData(
      //   style: ButtonStyle(
      //     backgroundColor: WidgetStateProperty.all<AppColor>(
      //       AppColors.statusWarning,
      //     ),
      //   ),
      // ),
    );
  }
}
