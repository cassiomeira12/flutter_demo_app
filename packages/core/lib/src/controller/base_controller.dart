import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BaseController extends GetxController with AnalyticsMixin {
  static bool SPLASH_ALREADY_EXECUTED = false;

  final String pageRouteNamed = AppNavigator.currentRoute;

  static RxnInt navigatorIndex = RxnInt();

  // static bool _biometricsEnabled = false;
  // static bool securityBlocked = false;
  // static bool securityBlurProtection = false;

  // static RxBool enableBlur = RxBool(false);

  // bool _popCalled = false;

  int? get navigatorIndexValue {
    return navigatorIndex.value;
  }

  @override
  void onInit() {
    setOrientationPortraitOnly();
    super.onInit();
  }

  @override
  void onReady() {
    screenTagging();
    super.onReady();
  }

  @override
  void onClose() {
    backTagging();
    super.onClose();
  }

  // static Future<void> initSecuritySettings() async {
  //   await Future.wait([_initBiometricSecurity(), _initBlurProtectSecurity()]);
  // }

  // static Future<void> _initBiometricSecurity() async {
  //   try {
  //     final localStorage = AppBinding.find<LocalStorageUseCase>();
  //     final bool? enabled = await localStorage.get<bool>(USE_BIOMETRICS);
  //     _biometricsEnabled = enabled ?? false;
  //   } catch (_) {}
  // }

  // static Future<void> _initBlurProtectSecurity() async {
  //   try {
  //     final localStorage = AppBinding.find<LocalStorageUseCase>();
  //     final bool? enabled = await localStorage.get<bool>(USE_BLUR_PROTECT);
  //     securityBlurProtection = enabled ?? false;
  //   } catch (_) {}
  // }

  // static Future<void> clearSecuritySettings(
  //   LocalStorageUseCase localStorage,
  // ) async {
  //   securityBlocked = false;
  //   enableBlur.value = false;

  //   await localStorage.get<bool>(USE_BIOMETRICS);
  //   await localStorage.get<bool>(USE_BLUR_PROTECT);
  // }

  void setOrientationPortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setOrientationLandscapeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setOrientationRotate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void openNotifications() {
    clickTagging(component: 'notifications_bell_icon_key');
    AppNavigator.toNamed(AppRouter.notifications);
  }

  // Future<void> refreshUnCountNotifications() async {
  //   // NotificationManager.instance.refreshUnCountNotifications();
  // }

  void backPage({dynamic result}) {
    AppNavigator.back(result: result);
  }

  // Future<void> checkIfNeedBlockApp() async {
  //   final List<String> unblockedRoutes = [AppRouter.blocking.name];
  //   final bool canBlockRoute = !unblockedRoutes.contains(
  //     AppNavigator.currentRoute,
  //   );
  //   if (canBlockRoute && _biometricsEnabled && !securityBlocked) {
  //     securityBlocked = true;
  //     await AppNavigator.toNamed(AppRouter.securityBlocked);
  //   }
  // }

  @override
  void screenTagging({String? route}) {
    super.screenTagging(route: route ?? pageRouteNamed);
  }

  @override
  void clickTagging({String? route, String? component}) {
    super.clickTagging(route: route ?? pageRouteNamed, component: component);
  }

  @override
  void backTagging({String? route}) {
    super.backTagging(route: route ?? pageRouteNamed);
  }

  @override
  void callbackTagging({String? route}) {
    super.callbackTagging(route: route ?? pageRouteNamed);
  }

  // @override
  // void onAppResumed() {
  //   // appResumedTagging(route: AppNavigator.currentRoute);
  //   // refreshUnCountNotifications();
  // }

  // @override
  // void onAppPaused() {
  //   // appPausedTagging(route: AppNavigator.currentRoute);
  // }

  // @override
  // void onAppBackground() {
  //   // appBackgroundTagging(route: AppNavigator.currentRoute);
  //   //checkIfNeedBlockApp();
  // }

  // bool _appInactive = false;
  // bool _appBackground = false;

  // bool get appInBackground => _appBackground;
  // bool get appInForeground => !_appBackground;

  // static Timer? _onResumedTimer;
  // static Timer? _onInactiveTimer;
  // static Timer? _onHiddenTimer;

  // @override
  // void onResumed() {
  //   // if (_onResumedTimer?.isActive ?? false) _onResumedTimer?.cancel();
  //   // _onResumedTimer = Timer(const Duration(seconds: 1), () {
  //   if (appInBackground) {
  //     _appBackground = false;
  //     _appInactive = false;
  //     onAppResumed();
  //   }

  //   // });
  //   // if (securityBlurProtection) {
  //   //   enableBlur.value = false;
  //   // }
  // }

  // @override
  // void onInactive() {
  //   // if (_onInactiveTimer?.isActive ?? false) _onInactiveTimer?.cancel();
  //   // _onInactiveTimer = Timer(const Duration(seconds: 1), () {
  //   if (!_appInactive) {
  //     onAppPaused();
  //     _appInactive = true;
  //   }
  //   // });
  //   // if (securityBlurProtection) {
  //   //   enableBlur.value = true;
  //   // }
  // }

  // @override
  // void onHidden() {
  //   // if (_onHiddenTimer?.isActive ?? false) _onHiddenTimer?.cancel();
  //   // _onHiddenTimer = Timer(const Duration(seconds: 1), () {
  //   if (appInForeground) {
  //     _appBackground = true;
  //     onAppBackground();
  //   }
  //   // });
  // }

  // @override
  // void onPaused() {}

  // @override
  // void onDetached() {}
}
