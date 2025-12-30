import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'security/app_security_manager_impl.dart';

class CoreModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.put<MethodChannel>(
      const MethodChannel('flutter'),
      permanent: true,
    );

    AppBinding.put<MainListener>(
      MainListener(methodChannel: AppBinding.find(), listeners: []),
      permanent: true,
    );

    AppBinding.lazyPut<ChangeLocaleNativeMethod>(
      () => ChangeLocaleNativeMethod(methodChannel: AppBinding.find()),
    );

    InfraModuleBindings().injectDependencies();
    DataModuleBindings().injectDependencies();
    DomainModuleBindings().injectDependencies();

    AppBinding.put<AnalyticsLifecycleController>(
      AnalyticsLifecycleController(),
      permanent: true,
    );

    AppBinding.put<AppSecurityManager>(
      AppAppSecurityManager(localStorageUseCase: AppBinding.find()),
      permanent: true,
    );

    final List<Interceptor> httpInterceptors = [
      RefreshTokenInterceptor(userAuthStorageUseCase: AppBinding.find()),
      CacheInterceptor(
        cacheStorageUseCase: AppBinding.find(),
        securityEncryptUseCase: AppBinding.find(),
        cacheEndpoints: [
          EndpointsEnum.userData,
          EndpointsEnum.listNotification,
          EndpointsEnum.listUsers,
          EndpointsEnum.graphql,
        ],
      ),
      ParseServerHeadersInterceptor(
        environment: AppBinding.find(),
        getInstallationAppUseCase: AppBinding.find(),
      ),
      ParseServerAuthTokenInterceptor(),
      UnauthenticatedInterceptor(
        authStorageUseCase: AppBinding.find(),
        messagingService: AppBinding.find(),
        appSecurityManager: AppBinding.find(),
      ),
      ServerOtpInterceptor(
        encryptServerPublicKeyUseCase: AppBinding.find(),
        getOtpCodeUseCase: AppBinding.find(),
      ),
    ];

    final httpClient = AppBinding.find<HttpClient>();
    httpClient.addAllInterceptors(httpInterceptors);

    AppBinding.put<ThemeController>(
      AppThemeController(
        localStorageUseCase: AppBinding.find(),
        setThemData: (theme) {
          Get.changeTheme(theme);
          Get.forceAppUpdate();
        },
        setThemMode: (mode) {
          Get.changeThemeMode(mode);
          Get.forceAppUpdate();
        },
      ),
      permanent: true,
    );
  }
}
