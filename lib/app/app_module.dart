import 'package:analytics/analytics.dart';
import 'package:app_purchase/app_purchase.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';
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

abstract class AppModule {
  static List<AppRouterPage> routes = [
    ...SplashModuleRoutes().pages,
    ...WebAppModuleRoutes().pages,
    // ...FirebaseInitializeModuleRoutes().pages,
    // ...AppsFlyerModuleRoutes().pages,
    ...AnalyticsModuleRoutes().pages,
    ...CrashlyticsModuleRoutes().pages,
    ...NotificationsModuleRoutes().pages,
    // ...PushNotificationsModuleRoutes().pages,
    // ...PushMessagingModuleRoutes().pages,
    ...OnboardingModuleRoutes().pages,
    ...ForceUpdateModuleRoutes().pages,
    ...LoginModuleRoutes().pages,
    ...HomeModuleRoutes().pages,
    ...SettingsModuleRoutes().pages,
    ...UserAccountModuleRoutes().pages,
    ...SecurityModuleRoutes().pages,
    ...WebViewModuleRoutes().pages,
    ...CredentialsModule.pages,
    ...CredentialModule.pages,
    ...CameraScannerModule.routes,
  ];

  static void setupHomePages() {
    HomePage.initialIndex = 0;
    HomePage.navigatorItems = [
      NavigatorItem(
        routeName: AppRouter.credentials.name,
        bottomItem: NavigatorBottom(
          title: 'home'.tr,
          selectedIcon: const FlutterIcon(
            Icons.home,
            size: IconSize.medium,
          ),
        ),
      ),
      NavigatorItem(
        routeName: AppRouter.settings.name,
        bottomItem: NavigatorBottom(
          customKey: 'settings_menu_item_key',
          title: 'settings'.tr,
          selectedIcon: const FlutterIcon(
            Icons.settings,
            size: IconSize.medium,
          ),
        ),
      ),
    ];
  }
}
