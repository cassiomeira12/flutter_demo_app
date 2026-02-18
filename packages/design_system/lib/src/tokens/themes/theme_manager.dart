import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ThemeManager {
  factory ThemeManager() => instance;
  ThemeManager._internal();

  static final ThemeManager instance = ThemeManager._internal();

  late ThemeScheme _light;
  late ThemeScheme _dark;

  late ThemeMode themeMode;

  static Color get primaryEnvColor {
    const String defaultColor = '#FFFFFF';
    const primary = String.fromEnvironment(
      'primary_color',
      defaultValue: defaultColor,
    );
    return primary.toColor();
  }

  void defineColor({
    LightColorScheme? lightColorScheme,
    DarkColorScheme? darkColorScheme,
  }) {
    themeMode = ThemeMode.system;
    _light = ThemeScheme(
      colorScheme: lightColorScheme ?? LightColorScheme(color: primaryEnvColor),
    );
    _dark = ThemeScheme(
      colorScheme: darkColorScheme ?? DarkColorScheme(color: primaryEnvColor),
    );
  }

  ColorScheme get lightColorScheme => _light.colorScheme;
  ColorScheme get darkColorScheme => _dark.colorScheme;

  ThemeData get lightTheme => _light.theme;
  ThemeData get darkTheme => _dark.theme;

  Map<String, ThemeData> get themes => {
    'system': lightTheme,
    'light': lightTheme,
    'dark': darkTheme,
  };
}
