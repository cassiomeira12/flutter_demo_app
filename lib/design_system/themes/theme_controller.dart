import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeController {
  static ThemeMode themeMode = ThemeMode.system;
  static ThemeData lightTheme = LightTheme.theme();
  static ThemeData darkTheme = DarkTheme.theme();

  final ValueChanged<ThemeData>? setThemData;
  final ValueChanged<ThemeMode>? setThemMode;

  static Map<String, ThemeData> themes = {
    'system': LightTheme.theme(),
    'light': LightTheme.theme(),
    'dark': DarkTheme.theme(),
  };

  ThemeController({this.setThemData, this.setThemMode}) {
    // themes.addAll(CustomTheme.themes);
    _getTheme();
  }

  void addCustomThemes(List<Map<String, ThemeData>> customThemes) {
    for (var theme in customThemes) {
      themes.addAll(theme);
    }
    _getTheme();
  }

  Future<String> get theme async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('theme_data');
    return data ?? themes.keys.first;
  }

  Future<void> _getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('theme_data');
    if (data != null) {
      setThemMode?.call(data == 'dark' ? ThemeMode.dark : ThemeMode.light);
      if (themes.containsKey(data)) {
        ThemeController.lightTheme = themes[data]!;
      }
      setThemData?.call(lightTheme);
    }
  }

  Future<void> changeTheme(String theme) async {
    var prefs = await SharedPreferences.getInstance();
    if (theme == 'system') {
      ThemeController.lightTheme = LightTheme.theme();
      setThemMode?.call(ThemeMode.system);
      setThemData?.call(lightTheme);
      prefs.remove('theme_data');
      return;
    }
    if (themes[theme] == null) throw Exception();
    setThemMode?.call(theme == 'dark' ? ThemeMode.dark : ThemeMode.light);
    ThemeController.lightTheme = themes[theme]!;
    setThemData?.call(lightTheme);
    prefs.setString('theme_data', theme);
  }
}
