import 'package:core/core.dart';
import 'package:core/src/security/app_security_manager_impl.dart';
import 'package:dependency/dependency.dart';

class CoreModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<MethodChannel>(
      const MethodChannel('flutter'),
      permanent: true,
    );

    AppBinding.put<MainListener>(
      MainListener(methodChannel: AppBinding.find(), listeners: []),
      permanent: true,
    );

    AppBinding.lazyPut<ChangeLocaleNativeMethod>(
      () => ChangeLocaleNativeMethod(
        methodChannel: AppBinding.find(),
      ),
    );

    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();

    AppBinding.put<AnalyticsLifecycleController>(
      AnalyticsLifecycleController(),
      permanent: true,
    );

    AppBinding.put<FeatureFlagLifecycleController>(
      FeatureFlagLifecycleController(
        appInfoEntity: AppBinding.find(),
        getDeviceInfoUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
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
          EndpointsEnum.listCredential,
        ],
      ),
      ParseServerHeadersInterceptor(
        environment: AppBinding.find(),
      ),
      ParseServerAuthTokenInterceptor(),
      UnauthenticatedInterceptor(
        appSecurityManager: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
      ServerOtpInterceptor(
        encryptServerPublicKeyUseCase: AppBinding.find(),
        getOtpCodeUseCase: AppBinding.find(),
      ),
    ];

    final httpClient = AppBinding.find<HttpClient>();
    httpClient.addAllInterceptors(httpInterceptors);
  }
}
