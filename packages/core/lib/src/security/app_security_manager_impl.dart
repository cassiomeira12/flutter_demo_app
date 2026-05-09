import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppAppSecurityManager extends LifecycleController
    implements AppSecurityManager {
  final LocalStorageUseCase _localStorage;

  AppAppSecurityManager({
    required LocalStorageUseCase localStorageUseCase,
  }) : _localStorage = localStorageUseCase;

  bool _biometricsEnabled = false;
  bool _securityBlocked = false;
  bool _securityBlurProtection = false;

  Timer? _blockAppTimer;
  final Duration awaitBeforeBlockApp = const Duration(seconds: 5);

  @override
  bool get biometricsEnabled => _biometricsEnabled;

  @override
  bool get useBlurProtect => _securityBlurProtection;

  @override
  void onReady() {}

  Future<void> _initBiometricSecurity() async {
    try {
      final bool? enabled = await _localStorage.get<bool>(USE_BIOMETRICS);
      _biometricsEnabled = enabled ?? false;
    } catch (_) {}
  }

  Future<void> _initBlurProtectSecurity() async {
    try {
      final bool? enabled = await _localStorage.get<bool>(USE_BLUR_PROTECT);
      _securityBlurProtection = enabled ?? false;
    } catch (_) {}
  }

  @override
  Future<void> init() async {
    await Future.wait([_initBiometricSecurity(), _initBlurProtectSecurity()]);
  }

  @override
  Future<void> checkIfNeedBlockApp() async {
    final List<String> unblockedRoutes = [AppRouter.blocking.name];
    final bool canBlockRoute = !unblockedRoutes.contains(
      AppNavigator.currentRoute,
    );
    if (canBlockRoute && _biometricsEnabled && !_securityBlocked) {
      _securityBlocked = true;
      await AppNavigator.toNamed(AppRouter.securityBlocked);
    }
  }

  @override
  void unlockApp() {
    _securityBlocked = false;
  }

  @override
  Future<void> clearSettings() async {
    _securityBlocked = false;
    AppSecurityManager.enableBlur.value = false;

    await _localStorage.delete(USE_BIOMETRICS);
    await _localStorage.delete(USE_BLUR_PROTECT);
  }

  @override
  void onAppResumed() {
    if (_securityBlurProtection) {
      AppSecurityManager.enableBlur.value = false;
    }
    if (_blockAppTimer?.isActive ?? false) _blockAppTimer?.cancel();
  }

  @override
  void onAppPaused() {
    if (_securityBlurProtection) {
      AppSecurityManager.enableBlur.value = true;
    }
  }

  @override
  void onAppBackground() {
    _blockAppTimer = Timer(awaitBeforeBlockApp, checkIfNeedBlockApp);
  }
}
