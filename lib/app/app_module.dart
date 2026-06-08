import 'package:admin/admin.dart';
import 'package:analytics/analytics.dart';
import 'package:app_purchase/app_purchase.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:firebase_initialize/firebase_initialize.dart';
import 'package:flutter_demo_app/presentation/initial_bindings_page.dart';
import 'package:flutter_demo_app/presentation/presentation.dart';
import 'package:force_update/force_update.dart';
import 'package:home/home.dart';
import 'package:login/login.dart';
import 'package:notifications/notifications.dart';
import 'package:onboarding/onboarding.dart';
import 'package:push_messaging/push_messaging.dart';
import 'package:push_notifications/push_notifications.dart';
import 'package:security/security.dart';
import 'package:settings/settings.dart';
import 'package:splash/splash.dart';
import 'package:user_account/user_account.dart';
import 'package:web_app/web_app.dart';
import 'package:webview/webview.dart';

abstract class AppModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.initial.name,
      page: InitialBindingsPage.new,
      transition: Transition.noTransition,
    ),
    ...SplashModuleRoutes().pages,
    ...WebAppModuleRoutes().pages,
    ...FirebaseInitializeModuleRoutes().pages,
    // ...AppsFlyerModuleRoutes().pages,
    ...AnalyticsModuleRoutes().pages,
    ...CrashlyticsModuleRoutes().pages,
    ...NotificationsModuleRoutes().pages,
    ...PushNotificationsModuleRoutes().pages,
    ...PushMessagingModuleRoutes().pages,
    ...OnboardingModuleRoutes().pages,
    ...ForceUpdateModuleRoutes().pages,
    ...LoginModuleRoutes().pages,
    ...AdminModuleRoutes().pages,
    ...HomeModuleRoutes().pages,
    ...SettingsModuleRoutes().pages,
    ...UserAccountModuleRoutes().pages,
    ...SecurityModuleRoutes().pages,
    ...WebViewModuleRoutes().pages,
    ...AppPurchaseModuleRoutes().pages,
    ...CheckPointsModule().pages,
  ];

  static void setupHomePages() {
    HomePage.initialIndex = 0;
    HomePage.navigatorItems = [
      NavigatorItem(
        routeName: AppRouter.checkPoints.name,
        bottomItem: NavigatorBottom(
          title: 'home',
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
          title: 'settings',
          selectedIcon: const FlutterIcon(
            Icons.settings,
            size: IconSize.medium,
          ),
        ),
      ),
    ];
  }
}
