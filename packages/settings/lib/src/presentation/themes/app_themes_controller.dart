import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:settings/src/domain/domain.dart';

class AppThemesController extends BaseController {
  final ThemeController _themeController;
  final DynamicIconUseCase _dynamicIconUseCase;

  AppThemesController({
    required this._themeController,
    required this._dynamicIconUseCase,
  });

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

  @override
  void onClose() {
    currentAppIcon.close();
    supportsAlternateIcons.close();
    super.onClose();
  }

  void updateCurrentIcon() {
    _dynamicIconUseCase.currentIcon().then((result) {
      if (result is Success<String>) {
        currentAppIcon.value = result.value!;
      }
    });
  }

  Future<void> onChangeTheme(String theme) async {
    try {
      clickTagging(component: 'settings_theme_${theme}_selected_key');
      await _themeController.changeTheme(theme);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  List<DynamicIconEntity> iconsAvailable() =>
      _dynamicIconUseCase.iconsAvailable();

  Future<Result> setIcon(String icon) {
    return _dynamicIconUseCase.changeIcon(icon).whenComplete(updateCurrentIcon);
  }
}
