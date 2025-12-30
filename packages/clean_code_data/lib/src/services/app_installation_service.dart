import 'package:core/core.dart';

class AppInstallationServiceImpl
    with
        CreateServiceMixin<InstallationEntity>,
        ListServiceMixin<InstallationEntity>
    implements AppInstallationService {
  final AppInstallationDataSource _dataSource;
  final AppInfoService _appInfoService;
  final DeviceInfoService _deviceInfoService;
  final PushMessagingService _pushMessagingService;

  AppInstallationServiceImpl({
    required AppInstallationDataSource appInstallationDataSource,
    required AppInfoService appInfoService,
    required DeviceInfoService deviceInfoService,
    required PushMessagingService pushMessagingService,
  }) : _dataSource = appInstallationDataSource,
       _appInfoService = appInfoService,
       _deviceInfoService = deviceInfoService,
       _pushMessagingService = pushMessagingService;

  @override
  Future<InstallationEntity> getInstallation() async {
    try {
      final appInfo = await _appInfoService.getAppInfo();
      final deviceInfo = await _deviceInfoService.getDeviceInfo();

      final String installationId =
          '${deviceInfo.deviceId} ${appInfo.packageName}';
      final String? token = await _pushMessagingService.getToken();
      final String appIdentifier = appInfo.packageName;

      final String timeZone = DateTime.now().timeZoneName;

      return InstallationEntity(
        installationId: installationId,
        appName: const String.fromEnvironment('app_name'),
        appVersion: appInfo.version,
        appIdentifier: appIdentifier,
        channels: [appIdentifier],
        deviceToken: token,
        gcmSenderId: const String.fromEnvironment('firebaseMessagingSenderId'),
        deviceBrand: deviceInfo.brand,
        deviceType: deviceInfo.model,
        deviceOsVersion: deviceInfo.osVersion,
        timeZone: 'UTC $timeZone',
        localeIdentifier: deviceInfo.localeName,
        platform: deviceInfo.platform,
        ip: null,
      );
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }

  @override
  Future<void> upload(InstallationEntity installation) async {
    await mixinCreate(
      data: installation.toMap(),
      create: _dataSource.create,
      fromMap: InstallationModel.fromMap,
    );
  }

  @override
  Future<List<InstallationEntity>> list(String userId) {
    return mixinList(
      list: () => _dataSource.list(userId),
      fromMap: InstallationModel.fromMap,
    );
  }
}
