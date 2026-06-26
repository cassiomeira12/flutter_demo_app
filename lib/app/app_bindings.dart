import 'package:admin/admin.dart';
import 'package:analytics/analytics.dart';
import 'package:app_purchase/app_purchase.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:deeplink/deeplink.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/feature_flag.dart';
import 'package:flutter_demo_app/domain/domain.dart';
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
  Future<void> dependencies() async {
    await CoreModuleBindings().injectDependencies();

    // await FirebaseInitializeModuleBindings().injectDependencies();

    if (!kDebugMode) {
      await CrashlyticsModuleBindings().injectDependencies();
      await AnalyticsModuleBindings().injectDependencies();
    }

    if (!Log.isIntegrationTest) {
      await FeatureFlagModuleBindings().injectDependencies();
    }

    /// Replace inside custom App Bindings
    // -----------------------------------
    AppBinding.lazyReplace<ChangePasswordUseCase>(
      () => FortressChangePasswordUseCaseImpl(
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
        credentialRepository: AppBinding.find(),
      ),
    );
    AppBinding.lazyReplace<DeleteUserUseCase>(
      () => FortressDeleteUserUseCaseImpl(
        userService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        credentialRepository: AppBinding.find(),
      ),
    );
    AppBinding.lazyReplace<LogoutUseCase>(
      () => FortreesLogoutUseCaseImpl(
        logoutService: AppBinding.find(),
        credentialRepository: AppBinding.find(),
      ),
    );
    // -----------------------------------

    // await AppsFlyerModuleBindings().injectDependencies();
    // await PushNotificationsModuleBindings().injectDependencies();
    // await PushMessagingModuleBindings().injectDependencies();
    await DeeplinkModuleBindings().injectDependencies();

    SplashModuleBindings().injectDependencies();
    WebAppModuleBindings().injectDependencies();
    OnboardingModuleBindings().injectDependencies();
    NotificationsModuleBindings().injectDependencies();
    ForceUpdateModuleBindings().injectDependencies();
    LoginModuleBindings().injectDependencies();
    AdminModuleBindings().injectDependencies();
    HomeModuleBindings().injectDependencies();
    SettingsModuleBindings().injectDependencies();
    UserAccountModuleBindings().injectDependencies();
    SecurityModuleBindings().injectDependencies();
    WebViewModuleBindings().injectDependencies();
    AppPurchaseModuleBindings().injectDependencies();
  }
}
