import 'package:core/core.dart';

class AnalyticsLifecycleController extends LifecycleController
    with AnalyticsMixin {
  @override
  void onInit() {
    super.onInit();
    appOpenedTagging();
  }

  @override
  void onAppResumed() {
    appResumedTagging(route: AppNavigator.currentRoute);
  }

  @override
  void onAppPaused() {
    appPausedTagging(route: AppNavigator.currentRoute);
  }

  @override
  void onAppBackground() {
    appBackgroundTagging(route: AppNavigator.currentRoute);
  }

  @override
  void onAppTerminate() {
    appTerminateTagging();
  }
}
