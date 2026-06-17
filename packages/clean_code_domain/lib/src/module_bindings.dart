import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class DomainModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.put<LocalStorageUseCase>(
      LocalStorageUseCaseImpl(
        localStorageService: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.lazyPut<ListUserInstallationsUseCase>(
      () => ListUserInstallationsUseCaseImpl(
        appInstallationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<UploadInstallationAppUseCase>(
      () => UploadInstallationAppUseCaseImpl(
        appInstallationService: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
      ),
    );

    AppBinding.put<UpdateUserDataUseCase>(
      UpdateUserDataUseCaseImpl(
        userService: AppBinding.find(),
      ),
      permanent: true,
    );

    AppBinding.lazyPut<CountUnreadNotificationsUseCase>(
      () => CountUnreadNotificationsUseCaseImpl(
        notificationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<FileStorageUseCase>(
      () => FileStorageUseCaseImpl(
        fileStorageService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<SecureStorageUseCase>(
      () => SecureStorageUseCaseImpl(
        secureStorageService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<CacheStorageUseCase>(
      () => CacheStorageUseCaseImpl(
        cacheStorageService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetDeviceInfoUseCase>(
      () => GetDeviceInfoUseCaseImpl(
        deviceInfoService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetAppInfoUseCase>(
      () => GetAppInfoUseCaseImpl(
        appInfoService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<ClipboardUseCase>(
      () => ClipboardUseCaseImpl(
        clipboardService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<RsaEncryptUseCase>(
      () => RsaEncryptUseCaseImpl(
        asymmetricEncryptionService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<EncryptServerPublicKeyUseCase>(
      () => EncryptServerPublicKeyUseCaseImpl(
        securityEnv: AppBinding.find(),
        rsaEncrypterUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<SecurityEncryptUseCase>(
      () => SecurityEncryptUseCaseImpl(
        symmetricEncryptionService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<EncryptUserPasswordUseCase>(
      () => EncryptUserPasswordUseCaseImpl(
        securityEnv: AppBinding.find(),
        getAppInfoUseCase: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        securityEncryptUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<UserAuthStorageUseCase>(
      () => UserAuthStorageUseCaseImpl(
        userAuthStorageService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        securityEncrypterUseCase: AppBinding.find(),
      ),
    );

    await AppBinding.putAsync<SessionEntity>(() async {
      String? token;
      try {
        final userAuthStorage = AppBinding.find<UserAuthStorageUseCase>();
        token = await userAuthStorage.getSessionToken();
      } catch (_) {}
      return SessionEntity(token: token);
    }, permanent: true);

    AppBinding.lazyPut<GetOtpCodeUseCase>(
      () => GetOtpCodeUseCaseImpl(
        otpCodeService: AppBinding.find(),
      ),
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
      () => GetCurrentLocaleUseCaseImpl(
        appLocaleService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetDeviceLocaleUseCase>(
      () => GetDeviceLocaleUseCaseImpl(
        getCurrentLocaleUseCase: AppBinding.find(),
        getDeviceInfoUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<OpenWebUrlUseCase>(
      () => OpenWebUrlUseCaseImpl(
        openUrlService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<OpenAppUseCase>(
      () => OpenAppUseCaseImpl(
        openUrlService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetIpAddressLocationUseCase>(
      () => GetIpAddressLocationUseCaseImpl(
        ipAddressLocationService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetInstallationAppUseCase>(
      () => GetInstallationAppUseCaseImpl(
        appInstallationService: AppBinding.find(),
      ),
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

    AppBinding.lazyPut<LoginUseCase>(
      () => LoginUseCaseImpl(
        loginService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        userService: AppBinding.find(),
        encryptUserPasswordUseCase: AppBinding.find(),
        deviceInfoEntity: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        securityEncrypterUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<LogoutUseCase>(
      () => LogoutUseCaseImpl(
        logoutService: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetUserLocalDataUseCase>(
      () => GetUserLocalDataUseCase(
        authStorageUseCase: AppBinding.find(),
        sessionEntity: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<GetUserRemoteDataUseCase>(
      () => GetUserRemoteDataUseCase(
        userService: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        sessionEntity: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<UpdateUserLocaleUseCase>(
      () => UpdateUserLocaleUseCaseImpl(
        getDeviceLocaleUseCase: AppBinding.find(),
        authStorageUseCase: AppBinding.find(),
        updateLocaleUseCase: AppBinding.find(),
        updateUserDataUseCase: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<ShareUseCase>(
      () => ShareUseCaseImpl(
        shareService: AppBinding.find(),
      ),
    );

    AppBinding.create<CheckInternetConnectionUseCase>(
      () => CheckInternetConnectionUseCaseImpl(
        internetConnectionService: AppBinding.find(),
      ),
    );
  }
}
