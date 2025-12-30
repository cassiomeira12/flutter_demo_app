import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class LightColorScheme extends ColorScheme {
  final Color _primaryColor;

  LightColorScheme({required Color color}) : _primaryColor = color;

  @override
  Brightness get themeBrightness => Brightness.light;

  @override
  Color get primary => _primaryColor;

  @override
  Color get secondary => _primaryColor;
  @override
  Color get tertiary => _primaryColor;

  // Error

  // Background
  @override
  Color get scaffoldBackground => AppColors.scaffoldBackgroundLight;
  @override
  Color get scaffoldBackgroundInverter =>
      AppColors.highlightBackgroundColorLight;
  @override
  Color get highlightBackgroundColor => AppColors.highlightBackgroundColorLight;

  @override
  Color get disabledColor => AppColors.disabledColorLight;
  @override
  Color get dividerColor => AppColors.dividerColorLight;

  // Status Bar
  @override
  Brightness get statusBarBrightness => Brightness.dark;

  // AppBar

  // Icons

  // AppBar

  // Popup Menu

  // Floating Action Button

  // Bottom Navigation
  @override
  Color get bottomNavigationColor => AppColors.bottomNavigationColorLight;

  // Text
  @override
  Color get textColor => AppColors.textColorLight;

  // InputField
  @override
  Color get inputFillColor => AppColors.white;

  // Button
  @override
  Color get buttonTextColor => AppColors.buttonTextColorLight;

  // Outlined Button
  @override
  Color get outlinedButtonTextColor => AppColors.outlinedButtonTextColorLight;
  @override
  Color get outlinedButtonIconColor => AppColors.outlinedButtonIconColorLight;
}
