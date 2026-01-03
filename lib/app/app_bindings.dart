import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:deeplink/deeplink.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/feature_flag.dart';
import 'package:force_update/force_update.dart';
import 'package:home/home.dart';
import 'package:login/login.dart';
import 'package:notifications/notifications.dart';
import 'package:onboarding/onboarding.dart';
import 'package:security/security.dart';
import 'package:settings/settings.dart';
import 'package:splash/splash.dart';
import 'package:user_account/user_account.dart';
import 'package:web_app/web_app.dart';
import 'package:webview/webview.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    if (kReleaseMode) {
      CrashlyticsModuleBindings().injectDependencies();
    }

    CoreModuleBindings().injectDependencies();

    if (kReleaseMode) {
      // FirebaseInitializeModuleBindings().injectDependencies();
      AnalyticsModuleBindings().injectDependencies();
    }

    // AppsFlyerModuleBindings().injectDependencies();
    // PushNotificationsModuleBindings().injectDependencies();
    // PushMessagingModuleBindings().injectDependencies();

    if (kReleaseMode) {
      DeeplinkModuleBindings().injectDependencies();
      FeatureFlagModuleBindings().injectDependencies();
    }

    SplashModuleBindings().injectDependencies();
    WebAppModuleBindings().injectDependencies();
    OnboardingModuleBindings().injectDependencies();
    NotificationsModuleBindings().injectDependencies();
    ForceUpdateModuleBindings().injectDependencies();
    LoginModuleBindings().injectDependencies();
    HomeModuleBindings().injectDependencies();
    SettingsModuleBindings().injectDependencies();
    UserAccountModuleBindings().injectDependencies();
    SecurityModuleBindings().injectDependencies();
    WebViewModuleBindings().injectDependencies();
  }
}
