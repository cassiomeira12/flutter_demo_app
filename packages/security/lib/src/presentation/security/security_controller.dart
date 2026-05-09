import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:security/src/domain/domain.dart';

class SecurityController extends LifecycleController {
  final LocalStorageUseCase _localStorageUseCase;
  final CheckBiometricsUseCase _checkBiometricsUseCase;
  final AuthenticateBiometricUseCase _authenticateBiometricUseCase;
  final LogoutUseCase _logoutUseCase;
  final AppSecurityManager _appSecurityManager;

  SecurityController({
    required LocalStorageUseCase localStorageUseCase,
    required CheckBiometricsUseCase checkBiometricsUseCase,
    required AuthenticateBiometricUseCase authenticateBiometricUseCase,
    required LogoutUseCase logoutUseCase,
    required AppSecurityManager appSecurityManager,
  }) : _localStorageUseCase = localStorageUseCase,
       _checkBiometricsUseCase = checkBiometricsUseCase,
       _authenticateBiometricUseCase = authenticateBiometricUseCase,
       _logoutUseCase = logoutUseCase,
       _appSecurityManager = appSecurityManager;

  final RxBool isLoading = RxBool(true);
  final RxBool hasSupportedBiometrics = RxBool(false);
  final RxBool biometric = RxBool(false);

  final RxBool blurProtect = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _checkDeviceSupportedBiometrics();
    biometric.value = _appSecurityManager.biometricsEnabled;
    blurProtect.value = _appSecurityManager.useBlurProtect;
    if (appInForeground) {
      _asyncUnlockApp();
    }
  }

  @override
  void onClose() {
    isLoading.close();
    hasSupportedBiometrics.close();
    biometric.close();
    blurProtect.close();
    super.onClose();
  }

  @override
  void onAppForeground() {
    super.onAppForeground();
    _asyncUnlockApp();
  }

  Future<void> _asyncUnlockApp() async {
    await Future.delayed(const Duration(milliseconds: 500));
    unlockApp();
  }

  Future<void> _checkDeviceSupportedBiometrics() async {
    hasSupportedBiometrics.value = await _checkBiometricsUseCase.call();
    isLoading.value = false;
  }

  Future<bool?> toggleBiometric(bool enabled) async {
    clickTagging(component: 'biometrics_switch_key');

    biometric.value = enabled;

    final bool authenticated = await authenticateBiometric();

    tagging('biometric_unlock_app', parameters: {'unlock': authenticated});

    if (!authenticated) {
      biometric.value = !enabled;
      return null;
    }

    tagging('biometric_security_enabled', parameters: {'enabled': enabled});

    biometric.value = enabled;

    await _localStorageUseCase.set<bool>(USE_BIOMETRICS, enabled);
    await _appSecurityManager.init();

    return enabled;
  }

  Future<bool> authenticateBiometric() {
    return _authenticateBiometricUseCase.call();
  }

  Future<void> unlockApp() async {
    if (appInBackground) return;
    if (AppNavigator.currentRoute != AppRouter.securityBlocked.name) return;
    final bool authenticated = await authenticateBiometric();
    tagging('biometric_unlock_app', parameters: {'unlock': authenticated});
    if (authenticated) {
      backPage();
      await Future.delayed(const Duration(seconds: 2));
      _appSecurityManager.unlockApp();
    }
  }

  Future<void> logout() async {
    try {
      clickTagging(component: 'security_blocked_app_logout_key');
      logoutTagging();

      await _logoutUseCase.call();
    } catch (_) {
    } finally {
      await _appSecurityManager.clearSettings();
      await _appSecurityManager.init();
      _appSecurityManager.unlockApp();
      await SessionHelper.clear();
      AppNavigator.backAllAndToNamed(AppRouter.splash);
    }
  }

  Future<bool?> toggleBlurProtect(bool enabled) async {
    clickTagging(component: 'blur_protect_switch_key');

    blurProtect.value = enabled;

    await _localStorageUseCase.set<bool>(USE_BLUR_PROTECT, enabled);
    await _appSecurityManager.init();

    return enabled;
  }
}
