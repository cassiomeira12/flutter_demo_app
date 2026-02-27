import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppInstallationServiceImpl
    with
        CreateServiceMixin<InstallationEntity>,
        ListServiceMixin<InstallationEntity>
    implements AppInstallationService {
  final AppInstallationDataSource _dataSource;
  final AppInfoService _appInfoService;
  final DeviceInfoService _deviceInfoService;
  final FirebaseInitializeService _firebaseInitializeService;
  final PushMessagingService _pushMessagingService;

  AppInstallationServiceImpl({
    required AppInstallationDataSource appInstallationDataSource,
    required AppInfoService appInfoService,
    required DeviceInfoService deviceInfoService,
    required FirebaseInitializeService firebaseInitializeService,
    required PushMessagingService pushMessagingService,
  }) : _dataSource = appInstallationDataSource,
       _appInfoService = appInfoService,
       _deviceInfoService = deviceInfoService,
       _firebaseInitializeService = firebaseInitializeService,
       _pushMessagingService = pushMessagingService;

  @override
  Future<InstallationEntity> getInstallation() async {
    try {
      final appInfo = await _appInfoService.getAppInfo();
      final deviceInfo = await _deviceInfoService.getDeviceInfo();

      const String appName = String.fromEnvironment('app_name');
      final String? deviceId = deviceInfo.deviceId;
      final String appIdentifier = appInfo.packageName;
      final String installationId = '$deviceId $appIdentifier';
      final String timeZone = DateTime.now().timeZoneName;
      final String emulator = Platform.appleDevice ? 'Simulator' : 'Emulator';
      final String deviceType = Platform.isWeb
          ? 'Web Browser'
          : deviceInfo.isPhysicalDevice
          ? 'Physical Device'
          : emulator;

      final String gcmSenderId = _firebaseInitializeService.messagingSenderId;
      final String? token = await _pushMessagingService.getToken();
      final String pushType = _pushMessagingService.getTokenType();

      final String encodedInstallationId = md5
          .convert(utf8.encode(installationId))
          .toString();

      return InstallationEntity(
        installationId: encodedInstallationId,
        appName: appName,
        appVersion: appInfo.versionOnly,
        appIdentifier: appIdentifier,
        channels: [],
        gcmSenderId: gcmSenderId,
        deviceToken: token,
        pushType: pushType,
        deviceId: deviceId,
        deviceBrand: deviceInfo.brand,
        deviceModel: deviceInfo.model,
        deviceType: deviceType,
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
  Future<InstallationEntity> upload(InstallationEntity installation) async {
    return mixinCreate(
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
