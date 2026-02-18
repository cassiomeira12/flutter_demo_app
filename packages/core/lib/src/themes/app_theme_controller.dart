import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppThemeController implements ThemeController {
  final LocalStorageUseCase _localStorage;
  final ValueChanged<ThemeData>? setThemData;
  final ValueChanged<ThemeMode>? setThemMode;

  String _currentThemeData = 'system';

  AppThemeController({
    required LocalStorageUseCase localStorageUseCase,
    this.setThemData,
    this.setThemMode,
  }) : _localStorage = localStorageUseCase;

  @override
  String get currentThemeData => _currentThemeData;

  @override
  Future<String> get theme async {
    final String? data = await _localStorage.get<String>('theme_data');
    return _currentThemeData = data ?? ThemeManager.instance.themes.keys.first;
  }

  @override
  Future<void> init() async => _getTheme();

  @override
  void addCustomThemes(List<Map<String, ThemeData>> customThemes) {
    for (final theme in customThemes) {
      ThemeManager.instance.themes.addAll(theme);
    }
    _getTheme();
  }

  Future<void> _getTheme() async {
    final String themeName = await theme;
    final ThemeMode themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeName,
      orElse: () => ThemeMode.system,
    );
    setThemMode?.call(themeMode);
    // setThemMode?.call(
    //   ThemeMode.values.firstWhere(
    //     (mode) => mode.name == data,
    //     orElse: () => ThemeMode.system,
    //   ),
    // );
    final ThemeData? appTheme = ThemeManager.instance.themes[themeName];
    //if (ThemeManager.instance.themes.containsKey(data)) {
    // ThemeManager.instance.lightTheme = ThemeManager.instance.themes[data]!;
    //}
    if (appTheme != null) {
      // setThemData?.call(appTheme);
    }
  }

  @override
  Future<void> changeTheme(String theme) async {
    final ThemeMode themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == theme,
      orElse: () => ThemeMode.system,
    );

    // if (themeMode == ThemeMode.system) {
    //   // ThemeManager.instance.lightTheme = LightAppTheme.theme();
    //   setThemMode?.call(ThemeMode.system);
    //   // setThemData?.call(ThemeManager.instance.lightTheme);
    //   await _localStorage.delete('theme_data');
    //   _currentThemeData = theme;
    //   return;
    // }

    final ThemeData? appTheme = ThemeManager.instance.themes[theme];

    if (appTheme == null) throw Exception();

    _currentThemeData = theme;
    setThemMode?.call(themeMode);
    // setThemData?.call(appTheme);
    // setThemData?.call(ThemeManager.instance.lightTheme);

    _localStorage.set<String>('theme_data', theme);
  }
}
