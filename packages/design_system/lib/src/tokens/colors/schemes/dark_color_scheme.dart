import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class DarkColorScheme extends ColorScheme {
  final Color _primaryColor;

  DarkColorScheme({required Color color}) : _primaryColor = color;

  @override
  Brightness get themeBrightness => Brightness.dark;

  @override
  Color get primary => _primaryColor;
  @override
  Color get secondary => _primaryColor;
  @override
  Color get tertiary => _primaryColor;

  // Error

  // Background
  @override
  Color get scaffoldBackground => AppColors.scaffoldBackgroundDark;
  @override
  Color get scaffoldBackgroundInverter => AppColors.scaffoldBackgroundDark;
  @override
  Color get highlightBackgroundColor => AppColors.highlightBackgroundColorDark;

  @override
  Color get disabledColor => AppColors.disabledColorDark;
  @override
  Color get dividerColor => AppColors.dividerColorDark;

  // Status Bar
  @override
  Brightness get statusBarBrightness => Brightness.light;

  // AppBar
  @override
  Color get appBarIconColor => AppColors.white;
  @override
  Color get appBarTitleColor => AppColors.white;

  // Icons

  // AppBar

  // Popup Menu
  @override
  Color get popupIconColor => appBarIconColor;

  // Floating Action Button

  // Bottom Navigation
  @override
  Color get bottomNavigationColor => AppColors.bottomNavigationColorDark;

  // Text
  @override
  Color get textColor => AppColors.textColorDark;

  // InputField
  @override
  Color get inputFillColor => const Color(0xFF464646);

  // Button
  @override
  Color get buttonTextColor => AppColors.buttonTextColorDark;

  // Outlined Button
  @override
  Color get outlinedButtonTextColor => AppColors.outlinedButtonTextColorDark;
  @override
  Color get outlinedButtonIconColor => AppColors.outlinedButtonIconColorDark;
}
