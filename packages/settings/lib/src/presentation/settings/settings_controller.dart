import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SettingsController extends BaseController {
  final ThemeController _themeController;
  final LogoutUseCase _logoutUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final AppInfoEntity _appInfoEntity;
  final AppSecurityManager _appSecurityManager;

  SettingsController({
    required ThemeController themeController,
    required LogoutUseCase logoutUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UserAuthStorageUseCase userAuthStorageUseCase,
    required UpdateUserLocaleUseCase updateUserLocaleUseCase,
    required AppInfoEntity appInfoEntity,
    required AppSecurityManager appSecurityManager,
  }) : _themeController = themeController,
       _logoutUseCase = logoutUseCase,
       _localStorageUseCase = localStorageUseCase,
       _userAuthStorageUseCase = userAuthStorageUseCase,
       _updateUserLocaleUseCase = updateUserLocaleUseCase,
       _appInfoEntity = appInfoEntity,
       _appSecurityManager = appSecurityManager;

  AppInfoEntity get appInfo => _appInfoEntity;
  UserEntity user = AppBinding.find();

  @override
  String get pageRouteNamed => AppRouter.settings.name;

  String get currentThemeData => _themeController.currentThemeData;

  void onChangeTheme(String theme) {
    clickTagging(component: 'settings_theme_${theme}_selected_key');
    _themeController.changeTheme(theme);
  }

  void onChangeLocale(Locale locale) {
    clickTagging(component: 'settings_language_${locale}_selected_key');
    _updateUserLocaleUseCase.call(user, definedLocale: locale);
  }

  Future<void> onClearCache() async {
    clickTagging(component: 'settings_clear_cache_key');
    await _localStorageUseCase.clearAll();
    await _userAuthStorageUseCase.clearUserData();
    await _userAuthStorageUseCase.clearCredentials();
    await _userAuthStorageUseCase.clearSessionToken();
    await logout();
  }

  Future<void> logout() async {
    try {
      clickTagging(component: 'settings_logout_key');
      logoutTagging();
      await _logoutUseCase.call();
    } catch (_) {
    } finally {
      await _appSecurityManager.clearSettings();
      await _appSecurityManager.init();
      await SessionHelper.clear();
      AppNavigator.backAllAndToNamed(AppRouter.splash);
    }
  }

  void userData() {
    clickTagging(component: 'settings_my_user_data_key');
    AppNavigator.toNamed(AppRouter.user);
  }

  void security() {
    clickTagging(component: 'settings_security_key');
    AppNavigator.toNamed(AppRouter.security, arguments: {'teste': 'teste'});
  }

  void notificationSettings() {
    clickTagging(component: 'settings_notifications_key');
    AppNavigator.toNamed(AppRouter.notificationsSettings);
  }

  void about() {
    clickTagging(component: 'settings_about_key');
    AppNavigator.toNamed(AppRouter.about);
  }
}
