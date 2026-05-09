import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:core/core.dart';
import 'package:core/src/security/app_security_manager_impl.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

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
      () => ChangeLocaleNativeMethod(methodChannel: AppBinding.find()),
    );

    await InfraModuleBindings().injectDependencies();
    await DataModuleBindings().injectDependencies();
    await DomainModuleBindings().injectDependencies();

    await AppBinding.find<GetDeviceInfoUseCase>().call().then((deviceInfo) {
      AppBinding.lazyPut<DeviceInfoEntity>(() => deviceInfo);
    });

    await AppBinding.find<GetAppInfoUseCase>().call().then((appInfo) {
      AppBinding.lazyPut<AppInfoEntity>(() => appInfo);
    });

    await AppBinding.putAsync<ThemeController>(() async {
      return AppThemeController.init(
        localStorageUseCase: AppBinding.find(),
        setThemData: (theme) {
          Get.changeTheme(theme);
          Get.forceAppUpdate();
        },
        setThemMode: (mode) {
          Get.changeThemeMode(mode);
          Get.forceAppUpdate();
        },
      );
    }, permanent: true);

    AppBinding.put<AnalyticsLifecycleController>(
      AnalyticsLifecycleController(),
      permanent: true,
    );

    AppBinding.put<FeatureFlagLifecycleController>(
      FeatureFlagLifecycleController(
        appInfoEntity: AppBinding.find(),
        deviceInfoEntity: AppBinding.find(),
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
        securityEnv: AppBinding.find(),
        cacheEndpoints: [
          EndpointsEnum.userData,
          EndpointsEnum.listNotification,
          EndpointsEnum.listUsers,
          EndpointsEnum.graphql,
          EndpointsEnum.listCurrentPoints,
          EndpointsEnum.totalCurrentMonth,
        ],
      ),
      // ParseServerHeadersInterceptor(
      //   serverEnv: AppBinding.find(),
      // ),
      // ParseServerAuthTokenInterceptor(),
      // UnauthenticatedInterceptor(
      //   appSecurityManager: AppBinding.find(),
      //   localStorageUseCase: AppBinding.find(),
      // ),
      // ServerOtpInterceptor(
      //   encryptServerPublicKeyUseCase: AppBinding.find(),
      //   getOtpCodeUseCase: AppBinding.find(),
      //   securityEnv: AppBinding.find(),
      // ),
    ];

    final httpClient = AppBinding.find<HttpClient>();
    httpClient.addAllInterceptors(httpInterceptors);
  }
}
