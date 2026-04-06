import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppThemesController extends BaseController {
  final ThemeController _themeController;
  final DynamicIconUseCase _dynamicIconUseCase;

  AppThemesController({
    required ThemeController themeController,
    required DynamicIconUseCase dynamicIconUseCase,
  }) : _themeController = themeController,
       _dynamicIconUseCase = dynamicIconUseCase;

  String get currentThemeData => _themeController.currentThemeData;

  RxString currentAppIcon = RxString('');
  RxBool supportsAlternateIcons = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _dynamicIconUseCase.supportsAlternateIcons().then((result) {
      if (result is Success<bool>) {
        supportsAlternateIcons.value = result.value == true;
      }
    });
    updateCurrentIcon();
  }

  void updateCurrentIcon() {
    _dynamicIconUseCase.currentIcon().then((result) {
      if (result is Success<String>) {
        currentAppIcon.value = result.value!;
      }
    });
  }

  void onChangeTheme(String theme) {
    clickTagging(component: 'settings_theme_${theme}_selected_key');
    _themeController.changeTheme(theme);
  }

  List<DynamicIcon> iconsAvailable() => _dynamicIconUseCase.iconsAvailable();

  Future<Result> setIcon(String icon) {
    return _dynamicIconUseCase.changeIcon(icon).whenComplete(updateCurrentIcon);
  }
}
