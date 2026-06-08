import 'package:clean_code_domain/clean_code_domain.dart';
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
    required this._localStorageUseCase,
    required this._checkBiometricsUseCase,
    required this._authenticateBiometricUseCase,
    required this._logoutUseCase,
    required this._appSecurityManager,
  });

  final isLoading = ValueNotifier<bool>(true);
  final hasSupportedBiometrics = ValueNotifier<bool>(false);
  final biometric = ValueNotifier<bool>(false);

  final blurProtect = ValueNotifier<bool>(false);

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
    isLoading.dispose();
    hasSupportedBiometrics.dispose();
    biometric.dispose();
    blurProtect.dispose();
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
