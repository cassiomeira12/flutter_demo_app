import 'package:dependency/dependency.dart';

abstract class ThemeController {
  Future<String> get theme;

  String get currentThemeData;

  Future<void> init();

  void addCustomThemes(List<Map<String, ThemeData>> customThemes);

  Future<void> changeTheme(String theme);
}
