import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class SettingsController extends BaseController {
  final ThemeController _themeController;
  final LogoutUseCase _logoutUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final UpdateUserLocaleUseCase _updateUserLocaleUseCase;
  final AppInfoEntity _appInfoEntity;
  final UserEntity _userEntity;
  final AppSecurityManager _appSecurityManager;

  SettingsController({
    required this._themeController,
    required this._logoutUseCase,
    required this._localStorageUseCase,
    required this._userAuthStorageUseCase,
    required this._updateUserLocaleUseCase,
    required this._appInfoEntity,
    required this._userEntity,
    required this._appSecurityManager,
  });

  AppInfoEntity get appInfo => _appInfoEntity;
  UserEntity get user => _userEntity;

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
    final track = CrashlyticsServiceManager.instance.trackOperation(
      name: 'logout-performance-tracking',
    );
    try {
      clickTagging(component: 'settings_logout_key');
      logoutTagging();
      await _logoutUseCase.call();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      track.setStatus(TrackOperationStatus.internalError);
    } finally {
      await _appSecurityManager.clearSettings();
      await _appSecurityManager.init();
      await SessionHelper.clear();
      AppNavigator.backAllAndToNamed(AppRouter.splash);
      track.finish();
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

  void themes() {
    clickTagging(component: 'settings_themes_key');
    AppNavigator.toNamed(AppRouter.themes);
  }

  void about() {
    clickTagging(component: 'settings_about_key');
    AppNavigator.toNamed(AppRouter.about);
  }
}
