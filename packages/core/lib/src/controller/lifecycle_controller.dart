import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LifecycleController extends BaseController
    with WidgetsBindingObserver
    implements LifecycleApp {
  bool _appPaused = false;
  bool get _appResumed => !_appPaused;

  bool _appBackground = false;
  bool get appInBackground => _appBackground;
  bool get appInForeground => !_appBackground;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> refreshUnCountNotifications() async {
    // NotificationManager.instance.refreshUnCountNotifications();
  }

  @override
  void onAppForeground() {}

  @override
  void onAppResumed() {
    refreshUnCountNotifications();
  }

  @override
  void onAppPaused() {}

  @override
  void onAppBackground() {}

  @override
  void onAppTerminate() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _appPaused = false;
        onAppResumed();
        if (appInBackground) {
          _appBackground = false;
          onAppForeground();
        }
      case AppLifecycleState.inactive:
        if (_appResumed) {
          _appPaused = true;
          onAppPaused();
        }
      case AppLifecycleState.hidden:
        if (appInForeground) {
          _appBackground = true;
          onAppBackground();
        }
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        onAppTerminate();
    }
  }
}
