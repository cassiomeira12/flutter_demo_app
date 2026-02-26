import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class DataModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<FirebaseInitializeService>(
      FirebaseInitializeServiceFaker(),
      permanent: true,
    );

    AppBinding.put<PushNotificationsService>(
      PushNotificationsServiceFaker(),
      permanent: true,
    );

    AppBinding.put<PushMessagingService>(
      PushMessagingServiceFaker(),
      permanent: true,
    );

    AppBinding.put<OnClickedNotificationCallback>(
      OnClickedNotificationCallbackBase(),
      permanent: true,
    );

    AppBinding.put<OnReceivedNotificationCallback>(
      OnReceivedNotificationCallbackFaker(),
      permanent: true,
    );

    AppBinding.put<AppsFlyerService>(
      AppsFlyerServiceFaker(),
      permanent: true,
    );

    AppBinding.lazyPut<NotificationService>(
      () => NotificationServiceImpl(
        notificationDataSource: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<CountUnreadNotificationsUseCase>(
      () => CountUnreadNotificationsUseCaseImpl(
        notificationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LocalStorageUseCase>(
      () => LocalStorageUseCaseImpl(
        localStorage: AppBinding.find(),
      ),
    );

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

    AppBinding.lazyPut<FileStorageUseCase>(() => FileStorageUseCaseImpl());
    AppBinding.lazyPut<SecureStorageUseCase>(() => SecureStorageUseCaseImpl());

    AppBinding.lazyPut<CacheStorageService>(() {
      if (Platform.isWeb) {
        return CacheLocalStorageServiceImpl(
          localStorageUseCase: AppBinding.find(),
        );
      }
      return CacheFileStorageServiceImpl(fileStorageUseCase: AppBinding.find());
    });
    AppBinding.lazyPut<CacheStorageUseCase>(
      () => CacheStorageUseCaseImpl(cacheStorageService: AppBinding.find()),
    );

    AppBinding.lazyPut<DeviceInfoService>(() => DeviceInfoServiceImpl());
    AppBinding.lazyPut<GetDeviceInfoUseCase>(
      () => GetDeviceInfoUseCaseImpl(deviceInfoService: AppBinding.find()),
    );

    AppBinding.lazyPut<AppInfoService>(() => AppInfoServiceImpl());
    AppBinding.lazyPut<GetAppInfoUseCase>(
      () => GetAppInfoUseCaseImpl(appInfoService: AppBinding.find()),
    );

    await AppBinding.find<GetAppInfoUseCase>().call().then((appInfo) {
      AppBinding.lazyPut<AppInfoEntity>(() => appInfo);
    });

    AppBinding.lazyPut<ClipboardUseCase>(() => ClipboardUseCaseImpl());

    AppBinding.lazyPut<RsaEncryptUseCase>(() => RsaEncryptUseCaseImpl());

    AppBinding.lazyPut<EncryptServerPublicKeyUseCase>(
      () => EncryptServerPublicKeyUseCaseImpl(
        serverRSAPublicKeyBase64: const String.fromEnvironment(
          'serverRSAPublicKeyBase64',
        ),
        rsaEncrypterUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<SecurityEncryptUseCase>(
      () => SecurityEncryptUseCaseImpl(),
    );

    AppBinding.lazyPut<EncryptUserPasswordUseCase>(
      () => EncryptUserPasswordUseCaseImpl(
        encryptKey: const String.fromEnvironment('encrypter_key'),
        getAppInfoUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        securityEncryptUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<UserAuthStorageService>(() {
      if (Platform.isAndroid) {
        return UserAuthSecureStorageImpl(storageUseCase: AppBinding.find());
      }
      return UserAuthLocalStorageServiceImpl(
        localStorageUseCase: AppBinding.find(),
      );
    });

    AppBinding.lazyPut<UserAuthStorageUseCase>(
      () => UserAuthStorageUseCaseImpl(
        userAuthStorageService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        securityEncrypterUseCase: AppBinding.find(),
      ),
    );

    await AppBinding.putAsync<SessionEntity>(() async {
      final userAuthStorage = AppBinding.find<UserAuthStorageUseCase>();
      final String? token = await userAuthStorage.getSessionToken();
      return SessionEntity(token: token);
    }, permanent: true);

    AppBinding.put<UserService>(
      UserServiceImpl(userDataSource: AppBinding.find()),
      permanent: true,
    );

    AppBinding.lazyPut<ChangePasswordUseCase>(
      () => ChangePasswordUseCaseImpl(
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        userAuthStorageUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetOtpCodeUseCase>(() => GetOtpCodeUseCaseImpl());

    AppBinding.lazyPut<AppLocaleService>(
      () => AppLocaleServiceImpl(localStorageUseCase: AppBinding.find()),
    );
    AppBinding.lazyPut<ChangeNativeLocaleUseCase>(
      () => ChangeNativeLocaleUseCaseImpl(
        changeLocaleNativeMethod: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<UpdateLocaleUseCase>(
      () => UpdateLocaleUseCaseImpl(
        appLocaleService: AppBinding.find(),
        changeNativeLocaleUseCase: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<GetCurrentLocaleUseCase>(
      () => GetCurrentLocaleUseCaseImpl(appLocaleService: AppBinding.find()),
    );
    AppBinding.lazyPut<GetDeviceLocaleUseCase>(
      () => GetDeviceLocaleUseCaseImpl(
        getCurrentLocaleUseCase: AppBinding.find(),
        getDeviceInfoUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<OpenUrlService>(() => OpenUrlServiceImpl());
    AppBinding.lazyPut<OpenWebUrlUseCase>(
      () => OpenWebUrlUseCaseImpl(openUrlService: AppBinding.find()),
    );
    AppBinding.lazyPut<OpenAppUseCase>(
      () => OpenAppUseCaseImpl(openUrlService: AppBinding.find()),
    );

    AppBinding.lazyPut<IpAddressLocationService>(
      () => IpAddressLocationServiceImpl(
        ipAddressLocationDataSource: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<GetIpAddressLocationUseCase>(
      () => GetIpAddressLocationUseCaseImpl(
        ipAddressLocationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<AppInstallationService>(
      () => AppInstallationServiceImpl(
        appInstallationDataSource: AppBinding.find(),
        appInfoService: AppBinding.find(),
        deviceInfoService: AppBinding.find(),
        firebaseInitializeService: AppBinding.find(),
        pushMessagingService: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<GetInstallationAppUseCase>(
      () => GetInstallationAppUseCaseImpl(
        appInstallationService: AppBinding.find(),
      ),
    );

    AppBinding.put<UploadInstallationAppUseCase>(
      UploadInstallationAppUseCaseImpl(
        appInstallationService: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.put<ListUserInstallationsUseCase>(
      ListUserInstallationsUseCaseImpl(
        appInstallationService: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.lazyPut<AppPermissionsService>(
      () => AppPermissionsServiceImpl(),
    );
    AppBinding.lazyPut<RequestPermissionUseCase>(
      () => RequestPermissionUseCaseImpl(
        appPermissionService: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<CheckPermissionUseCase>(
      () => CheckPermissionUseCaseImpl(
        appPermissionService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LoginService>(
      () => LoginServiceImpl(loginDataSource: AppBinding.find()),
    );
    AppBinding.lazyPut<LoginUseCase>(
      () => LoginUseCaseImpl(
        loginService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
        getDeviceInfoUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        securityEncrypterUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LogoutService>(
      () => LogoutServiceImpl(logoutDataSource: AppBinding.find()),
    );
    AppBinding.lazyPut<LogoutUseCase>(
      () => LogoutUseCaseImpl(logoutService: AppBinding.find()),
    );

    AppBinding.lazyPut<GetUserDataUseCase>(
      () => GetUserLocalDataUseCaseImpl(
        authStorageUseCase: AppBinding.find(),
        sessionEntity: AppBinding.find(),
      ),
    );
    AppBinding.put<UpdateUserDataUseCase>(
      UpdateUserDataUseCaseImpl(userService: AppBinding.find()),
      permanent: true,
    );

    AppBinding.lazyPut<UpdateUserLocaleUseCase>(
      () => UpdateUserLocaleUseCaseImpl(
        getDeviceLocaleUseCase: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        updateLocaleUseCase: AppBinding.find(),
        updateUserDataUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<WebVisitHistoryService>(
      () => WebVisitHistoryServiceImpl(
        webVisitHistoryDataSource: AppBinding.find(),
      ),
    );
    AppBinding.lazyPut<ListWebVisitHistoryUseCase>(
      () => ListWebVisitHistoryUseCaseImpl(
        webVisitHistoryService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<InternetConnectionService>(
      () => InternetConnectionServiceImpl(),
    );
    AppBinding.create<CheckInternetConnectionUseCase>(
      () => CheckInternetConnectionUseCaseImpl(
        internetConnectionService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<ShareUseCase>(() => ShareUseCaseImpl());

    AppBinding.lazyPut<DynamicIconUseCase>(() => DynamicIconUseCaseImpl());

    AppBinding.lazyPut<AppReviewUseCase>(() => AppReviewUseCaseImpl());
  }
}
