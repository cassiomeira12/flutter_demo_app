import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class AppColorScheme {
  static ColorScheme of(BuildContext context) {
    final lightTheme = Theme.brightnessOf(context);
    return lightTheme == Brightness.light
        ? ThemeManager.instance.lightColorScheme
        : ThemeManager.instance.darkColorScheme;
  }
}
