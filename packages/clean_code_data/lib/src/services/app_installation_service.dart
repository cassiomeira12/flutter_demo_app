import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AppInstallationServiceImpl
    with
        CreateServiceMixin<InstallationEntity>,
        ListServiceMixin<InstallationEntity>
    implements AppInstallationService {
  final AppInstallationDataSource _appInstallationDataSource;
  final AppInfoService _appInfoService;
  final DeviceInfoService _deviceInfoService;
  final FirebaseInitializeService _firebaseInitializeService;
  final PushMessagingService _pushMessagingService;

  AppInstallationServiceImpl({
    required this._appInstallationDataSource,
    required this._appInfoService,
    required this._deviceInfoService,
    required this._firebaseInitializeService,
    required this._pushMessagingService,
  });

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
        appVersion: appInfo.version,
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
    } on MissingPluginException {
      rethrow;
    } on HttpException catch (error, stackTrace) {
      throw ExceptionHelper.call(error, stackTrace: stackTrace);
    } on BaseException catch (error) {
      Log.baseException(error);
      rethrow;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<InstallationEntity> upload(InstallationEntity installation) async {
    return mixinCreate(
      data: installation.toMap(),
      create: _appInstallationDataSource.create,
      fromMap: InstallationModel.fromMap,
    );
  }

  @override
  Future<List<InstallationEntity>> list(String userId) {
    return mixinList(
      list: () => _appInstallationDataSource.list(userId),
      fromMap: InstallationModel.fromMap,
    );
  }
}
