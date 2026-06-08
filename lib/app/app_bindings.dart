import 'package:admin/admin.dart';
import 'package:analytics/analytics.dart';
import 'package:app_purchase/app_purchase.dart';
import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:deeplink/deeplink.dart';
import 'package:dependency/dependency.dart';
import 'package:feature_flag/feature_flag.dart';
import 'package:flutter_demo_app/data/data.dart';
import 'package:flutter_demo_app/domain/domain.dart';
import 'package:flutter_demo_app/infra/infra.dart';
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
      await FeatureFlagModuleBindings().injectDependencies();
    }

    await AppBinding.replace<LoginDataSource>(
      WorkPointLoginDataSource(http: AppBinding.find()),
    );
    await AppBinding.replace<RefreshTokenDataSource>(
      WorkPointRefreshTokenDataSource(loginDataSource: AppBinding.find()),
    );
    await AppBinding.replace<LogoutDataSource>(WorkPointLogoutDataSource());
    await AppBinding.replace<UpdateUserDataUseCase>(
      WorkPointUpdateUserDataUseCase(),
    );
    await AppBinding.replace<ListUserInstallationsUseCase>(
      WorkPointListUserInstallationUseCase(),
    );
    await AppBinding.replace<UploadInstallationAppUseCase>(
      WorkPointUploadInstallationUseCase(
        appInstallationService: AppBinding.find(),
      ),
    );
    await AppBinding.replace<UserService>(WorkPointUserService());

    final List<Interceptor> httpInterceptors = [
      WorkPointAuthTokenInterceptor(),
    ];
    final httpClient = AppBinding.find<HttpClient>();
    httpClient.addAllInterceptors(httpInterceptors);

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
