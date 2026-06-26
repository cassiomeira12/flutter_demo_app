import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class DeviceInfoServiceImpl implements DeviceInfoService {
  @override
  Future<DeviceInfoEntity> getDeviceInfo() async {
    try {
      final appInfo = await AppInfoData.get();

      final Map<String, dynamic> deviceInfoData = appInfo.platform.device.data;

      if (appInfo.platform.isAndroid) {
        return await _androidDeviceModel(
          deviceInfoData,
          localeName: appInfo.platform.localeName,
        );
      }

      if (appInfo.platform.isIOS) {
        return await _iosDeviceModel(
          deviceInfoData,
          localeName: appInfo.platform.localeName,
        );
      }

      if (appInfo.platform.isMacOS) {
        return await _macosDeviceModel(
          deviceInfoData,
          localeName: appInfo.platform.localeName,
        );
      }

      if (appInfo.platform.isWeb) {
        final String? browserName = deviceInfoData['browserName']
            ?.toString()
            .replaceFirst('BrowserName.', '');
        return await _webDeviceModel(deviceInfoData, browserName: browserName);
      }

      throw UnimplementedError();
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  Future<DeviceInfoEntity> _androidDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    String? androidDeviceId;
    try {
      androidDeviceId = await const AndroidId().getId();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
    final osVersion = deviceInfoData['version'] ?? {};
    return DeviceInfoEntity(
      platform: 'android',
      brand: deviceInfoData['brand'] ?? 'unknown',
      isPhysicalDevice: deviceInfoData['isPhysicalDevice'] ?? false,
      model: deviceInfoData['model'] ?? 'unknown',
      osVersion: 'Android ${osVersion['release'] ?? 'unknown version'}',
      localeName: localeName,
      deviceId: androidDeviceId,
    );
  }

  Future<DeviceInfoEntity> _iosDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    return DeviceInfoEntity(
      platform: 'ios',
      brand: 'Apple',
      isPhysicalDevice: deviceInfoData['isPhysicalDevice'] ?? false,
      model:
          deviceInfoData['modelName'] ?? deviceInfoData['model'] ?? 'unknown',
      osVersion: 'iOS ${deviceInfoData['systemVersion']}',
      localeName: localeName,
      deviceId: deviceInfoData['identifierForVendor'],
    );
  }

  Future<DeviceInfoEntity> _macosDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    return DeviceInfoEntity(
      platform: 'macos',
      brand: 'Apple',
      isPhysicalDevice: true,
      model:
          deviceInfoData['modelName'] ?? deviceInfoData['model'] ?? 'unknown',
      osVersion: 'MacOS ${deviceInfoData['osRelease']}',
      localeName: localeName,
      deviceId: deviceInfoData['systemGUID'],
    );
  }

  Future<DeviceInfoEntity> _webDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String? browserName,
  }) async {
    final String browserWebId =
        'Browser ${browserName?.capitalizeFirst} ${deviceInfoData['appVersion']}';
    final String deviceId = md5.convert(utf8.encode(browserWebId)).toString();
    return DeviceInfoEntity(
      platform: 'web',
      brand: 'Browser ${browserName?.capitalizeFirst}',
      isPhysicalDevice: false,
      model: deviceInfoData['appVersion'] ?? 'unknown',
      osVersion: deviceInfoData['vendor'] ?? 'unknown',
      localeName: (deviceInfoData['language'] as String?)?.replaceAll('-', '_'),
      deviceId: deviceId,
    );
  }
}
