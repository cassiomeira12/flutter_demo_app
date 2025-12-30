import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

abstract class ColorScheme {
  // Theme
  Brightness get themeBrightness => throw UnimplementedError();

  // Primary Color
  Color get primary => throw UnimplementedError();
  // Color get onPrimary => throw UnimplementedError();
  // Color get primaryContainer => throw UnimplementedError();
  // Color get onPrimaryContainer => throw UnimplementedError();
  // Color get inversePrimary => throw UnimplementedError();

  // Secondary Color
  Color get secondary => throw UnimplementedError();
  // Color get onSecondary => throw UnimplementedError();
  // Color get secondaryContainer => throw UnimplementedError();
  // Color get onSecondaryContainer => throw UnimplementedError();

  // Tertiary Color
  Color get tertiary => throw UnimplementedError();
  // Color get onTertiary => throw UnimplementedError();
  // Color get tertiaryContainer => throw UnimplementedError();
  // Color get onTertiaryContainer => throw UnimplementedError();

  // Error
  Color get error => SemanticColors.negative400;

  // Background
  Color get scaffoldBackground => throw UnimplementedError();
  Color get scaffoldBackgroundInverter => throw UnimplementedError();
  Color get highlightBackgroundColor => throw UnimplementedError();

  Color get disabledColor => throw UnimplementedError();
  Color get dividerColor => throw UnimplementedError();

  // Status Bar
  Color get statusBarColor => StaticColors.transparent;

  // AppBar
  Brightness get statusBarBrightness => throw UnimplementedError();
  Color get appBarColor => primary;
  double get appBarElevation => 0.0;
  Color get appBarIconColor => textColor;
  Color get appBarTitleColor => textColor;

  // Icons
  Color get iconColor => NeutralColors.neutral500;

  // Popup Menu
  Color get popupIconColor => textColor;
  Color get popupBackgroundColor =>
      highlightBackgroundColor; // scaffoldBackground;

  // Floating Action Button
  Color get fabForegroundColor => buttonTextColor;
  Color get fabBackgroundColor => primary;

  // Bottom Navigation
  Color get bottomNavigationColor => throw UnimplementedError();
  Color get bottomNavigationSelectedItemColor => primary;
  Color get bottomNavigationUnselectedItemColor => iconColor;
  Brightness get systemNavigationBrightness => themeBrightness;
  Color get systemNavigationColor => bottomNavigationColor;
  Color get systemNavigationDividerColor => bottomNavigationColor;

  // Text
  Color get textColor => throw UnimplementedError();

  // InputField
  Color get inputFillColor => throw UnimplementedError();

  // Button
  Color get buttonBackgroundColor => primary;
  Color get buttonDisabledBackgroundColor =>
      buttonBackgroundColor.withAlpha((255 * .35).toInt());
  Color get buttonTextColor => scaffoldBackground;

  // Outlined Button
  Color get outlinedButtonIconColor => throw UnimplementedError();
  Color get outlinedButtonTextColor => throw UnimplementedError();
}
