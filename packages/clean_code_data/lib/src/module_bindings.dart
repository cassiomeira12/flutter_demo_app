import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
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

    AppBinding.put<AppsFlyerService>(
      AppsFlyerServiceFaker(),
      permanent: true,
    );

    AppBinding.put<OnReceivedNotificationCallback>(
      OnReceivedNotificationCallbackFaker(),
      permanent: true,
    );

    AppBinding.put<OnClickedNotificationCallback>(
      OnClickedNotificationCallbackBase(),
      permanent: true,
    );

    AppBinding.put<InternetConnectionService>(
      InternetConnectionServiceImpl(),
      permanent: true,
    );

    AppBinding.lazyPut<UserService>(
      () => UserServiceImpl(
        userDataSource: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LocalStorageService>(
      () => LocalStorageServiceImpl(
        localStorage: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<NotificationService>(
      () => NotificationServiceImpl(
        notificationDataSource: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<ClipboardService>(
      () => ClipboardServiceImpl(),
    );

    AppBinding.lazyPut<RsaEncryptService>(
      () => RsaEncryptServiceImpl(),
    );

    AppBinding.lazyPut<FileStorageService>(
      () => FileStorageServiceImpl(),
    );

    AppBinding.lazyPut<CacheStorageService>(() {
      if (Platform.isWeb) {
        return CacheLocalStorageServiceImpl(
          localStorageUseCase: AppBinding.find(),
        );
      }
      return CacheFileStorageServiceImpl(
        fileStorageUseCase: AppBinding.find(),
      );
    });

    AppBinding.lazyPut<DeviceInfoService>(
      () => DeviceInfoServiceImpl(),
    );

    AppBinding.lazyPut<AppInfoService>(
      () => AppInfoServiceImpl(),
    );

    AppBinding.lazyPut<SecurityEncryptService>(
      () => SecurityEncryptServiceImpl(),
    );

    AppBinding.lazyPut<SecureStorageService>(
      () => SecureStorageServiceImpl(),
    );

    AppBinding.lazyPut<OtpCodeService>(
      () => OtpCodeServiceImpl(),
    );

    AppBinding.lazyPut<ShareService>(
      () => ShareServiceImpl(),
    );

    AppBinding.lazyPut<UserAuthStorageService>(() {
      if (Platform.isAndroid) {
        return UserAuthSecureStorageImpl(
          secureStorageUsecase: AppBinding.find(),
          encryptUserPasswordUseCase: AppBinding.find(),
          securityEncrypterUseCase: AppBinding.find(),
        );
      }
      return UserAuthLocalStorageServiceImpl(
        localStorageUseCase: AppBinding.find(),
      );
    });

    AppBinding.lazyPut<AppLocaleService>(
      () => AppLocaleServiceImpl(
        localStorageUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<OpenUrlService>(
      () => OpenUrlServiceImpl(),
    );

    AppBinding.lazyPut<IpAddressLocationService>(
      () => IpAddressLocationServiceImpl(
        ipAddressLocationDataSource: AppBinding.find(),
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

    AppBinding.lazyPut<UploadInstallationAppUseCase>(
      () => UploadInstallationAppUseCaseImpl(
        appInstallationService: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<ListUserInstallationsUseCase>(
      () => ListUserInstallationsUseCaseImpl(
        appInstallationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<AppPermissionsService>(
      () => AppPermissionsServiceImpl(),
    );

    AppBinding.lazyPut<LoginService>(
      () => LoginServiceImpl(
        loginDataSource: AppBinding.find(),
        encryptServerPublicKeyUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LogoutService>(
      () => LogoutServiceImpl(
        logoutDataSource: AppBinding.find(),
      ),
    );
  }
}
