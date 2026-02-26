import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart' as material;

class ThemeScheme {
  final ColorScheme colorScheme;

  ThemeScheme({required this.colorScheme});

  ThemeData get theme {
    return ThemeData(
      // unselectedWidgetColor: Colors.red,
      brightness: colorScheme.themeBrightness,
      primaryColor: colorScheme.primary,
      primaryColorLight: colorScheme.primary,
      primaryColorDark: colorScheme.primary,
      colorScheme: material.ColorScheme.light(
        brightness: colorScheme.themeBrightness,
        primary: colorScheme.primary,
        error: colorScheme.error,
      ),
      secondaryHeaderColor: colorScheme.secondary,
      disabledColor: colorScheme.disabledColor,
      hintColor: colorScheme.disabledColor,
      cardColor: colorScheme.primary, // PrimaryButton, FutureButton
      // Bottom Nav Color
      canvasColor: colorScheme.scaffoldBackgroundInverter.withAlpha(
        (255 * .25).toInt(),
      ),
      dividerColor: colorScheme.dividerColor,
      // Foco de widget quando clica Ctrl + Tab
      focusColor: colorScheme.primary.withAlpha((255 * .30).toInt()),
      // Passar mouse em cima
      hoverColor: colorScheme.scaffoldBackgroundInverter.withAlpha(
        (255 * .30).toInt(),
      ),
      // shadowColor: _colorScheme.primary,
      // Efeito quando clica em botão
      splashColor: colorScheme.primary.withAlpha((255 * .20).toInt()),
      // Efeito de splash quando clica no botão
      highlightColor: colorScheme.highlightBackgroundColor,
      scaffoldBackgroundColor: colorScheme.scaffoldBackground,
      iconTheme: _iconThemeData,
      appBarTheme: _appBarTheme,
      tabBarTheme: _tabBarThemeData,
      popupMenuTheme: _popupMenuThemeData,
      drawerTheme: _drawerThemeData,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      bottomNavigationBarTheme: _bottomNavigationBarThemeData,
      progressIndicatorTheme: _progressIndicatorTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      textButtonTheme: _textButtonThemeData,
      outlinedButtonTheme: _outlinedButtonTheme,
      dividerTheme: _dividerTheme,
      datePickerTheme: _datePickerTheme,
      timePickerTheme: _timePickerTheme,
    );
  }

  IconThemeData get _iconThemeData =>
      IconThemeData(color: colorScheme.iconColor);

  AppBarTheme get _appBarTheme => AppBarTheme(
    elevation: colorScheme.appBarElevation,
    scrolledUnderElevation: colorScheme.appBarElevation,
    shadowColor: colorScheme.appBarColor,
    backgroundColor: colorScheme.appBarColor,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: colorScheme.statusBarColor,
      statusBarBrightness: colorScheme.themeBrightness,
      statusBarIconBrightness: colorScheme.statusBarBrightness,
      systemNavigationBarIconBrightness: colorScheme.themeBrightness,
      systemNavigationBarColor: colorScheme.systemNavigationColor,
      systemNavigationBarDividerColor: colorScheme.bottomNavigationColor,
    ),
    iconTheme: IconThemeData(color: colorScheme.appBarIconColor),
    actionsIconTheme: IconThemeData(color: colorScheme.appBarIconColor),
    titleTextStyle: TextStyle(color: colorScheme.appBarTitleColor),
  );

  TabBarThemeData get _tabBarThemeData =>
      TabBarThemeData(indicatorColor: colorScheme.primary);

  PopupMenuThemeData get _popupMenuThemeData => PopupMenuThemeData(
    iconColor: colorScheme.popupIconColor,
    color: colorScheme.popupBackgroundColor,
  );

  DrawerThemeData get _drawerThemeData => DrawerThemeData(
    backgroundColor: colorScheme.scaffoldBackground,
    shape: const RoundedRectangleBorder(),
    endShape: const RoundedRectangleBorder(),
  );

  FloatingActionButtonThemeData get _floatingActionButtonTheme =>
      FloatingActionButtonThemeData(
        foregroundColor: colorScheme.fabForegroundColor,
        backgroundColor: colorScheme.fabBackgroundColor,
      );

  BottomNavigationBarThemeData get _bottomNavigationBarThemeData =>
      BottomNavigationBarThemeData(
        backgroundColor: colorScheme.bottomNavigationColor,
        selectedItemColor: colorScheme.bottomNavigationSelectedItemColor,
        unselectedItemColor: colorScheme.bottomNavigationUnselectedItemColor,
      );

  ProgressIndicatorThemeData get _progressIndicatorTheme =>
      ProgressIndicatorThemeData(color: colorScheme.primary);

  TextTheme get _textTheme => TextTheme(
    displayLarge: TextStyle(color: colorScheme.textColor),
    displayMedium: TextStyle(color: colorScheme.textColor),
    displaySmall: TextStyle(color: colorScheme.textColor),
    headlineLarge: TextStyle(color: colorScheme.textColor),
    headlineMedium: TextStyle(color: colorScheme.textColor),
    headlineSmall: TextStyle(color: colorScheme.textColor),
    titleLarge: TextStyle(color: colorScheme.textColor),
    titleMedium: TextStyle(color: colorScheme.textColor),
    titleSmall: TextStyle(color: colorScheme.textColor),
    bodyLarge: TextStyle(color: colorScheme.textColor),
    bodyMedium: TextStyle(color: colorScheme.textColor),
    bodySmall: TextStyle(color: colorScheme.textColor),
    // labelLarge: TextStyle(color: AppColors.light),
    labelLarge: TextStyle(color: colorScheme.textColor),
    labelMedium: TextStyle(color: colorScheme.textColor),
    labelSmall: TextStyle(color: colorScheme.textColor),
  );

  InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    isDense: true,
    fillColor: colorScheme.inputFillColor,
    // hoverColor: AppColors.white.withAlpha((255 * .40).toInt()),
    labelStyle: TextStyle(color: colorScheme.textColor),
    hintStyle: TextStyle(
      color: colorScheme.textColor.withAlpha((255 * .40).toInt()),
    ),
    errorStyle: TextStyle(color: colorScheme.error),
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(5),
    //   borderSide: BorderSide(
    //     color: Colors
    //         .red, // _colorScheme.textColor.withAlpha((255 * .50).toInt()),
    //   ),
    // ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: colorScheme.textColor.withAlpha((255 * .20).toInt()),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: colorScheme.primary),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: colorScheme.textColor.withAlpha((255 * .0).toInt()),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: colorScheme.error.withAlpha((255 * .35).toInt()),
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: colorScheme.error),
    ),
    prefixIconColor: colorScheme.textColor.withAlpha((255 * .70).toInt()),
    prefixIconConstraints: const BoxConstraints(minHeight: 32, maxHeight: 32),
    suffixIconColor: colorScheme.textColor.withAlpha((255 * .70).toInt()),
    suffixIconConstraints: const BoxConstraints(minHeight: 32, maxHeight: 32),
  );

  TextButtonThemeData get _textButtonThemeData => TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.all(
        colorScheme.scaffoldBackgroundInverter.withAlpha((255 * .20).toInt()),
      ),
      backgroundColor: WidgetStateProperty.all(
        colorScheme.buttonBackgroundColor,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: AppColors.transparent,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(color: colorScheme.buttonTextColor),
      ),
    ),
  );

  OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: StaticColors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      iconColor: colorScheme.outlinedButtonIconColor.withAlpha(
        (255 * .70).toInt(),
      ),
      textStyle: TextStyle(
        color: colorScheme.outlinedButtonTextColor.withAlpha(
          (255 * .70).toInt(),
        ),
      ),
    ),
  );

  DividerThemeData get _dividerTheme => DividerThemeData(
    color: colorScheme.textColor.withAlpha((255 * .20).toInt()),
  );

  DatePickerThemeData get _datePickerTheme => DatePickerThemeData(
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.all(colorScheme.error),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  );

  TimePickerThemeData get _timePickerTheme => TimePickerThemeData(
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.all(colorScheme.error),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  );
}
