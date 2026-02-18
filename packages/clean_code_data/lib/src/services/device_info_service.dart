import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class DeviceInfoServiceImpl implements DeviceInfoService {
  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
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
    } catch (error, stacktrace) {
      Log.error('Unexpected Exception', error: error, stackTrace: stacktrace);
      rethrow;
    }
  }

  Future<DeviceInfoModel> _androidDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    return DeviceInfoModel(
      platform: 'android',
      brand: deviceInfoData['brand'] as String,
      isPhysicalDevice: deviceInfoData['isPhysicalDevice'] as bool,
      model: deviceInfoData['model'] as String,
      osVersion: 'Android ${deviceInfoData['version']['release']}',
      localeName: localeName,
      deviceId: await const AndroidId().getId(),
    );
  }

  Future<DeviceInfoModel> _iosDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    return DeviceInfoModel(
      platform: 'ios',
      brand: 'Apple',
      isPhysicalDevice: deviceInfoData['isPhysicalDevice'] as bool,
      model: deviceInfoData['modelName'] ?? deviceInfoData['model'] as String,
      osVersion: 'iOS ${deviceInfoData['systemVersion']}',
      localeName: localeName,
      deviceId: deviceInfoData['identifierForVendor'],
    );
  }

  Future<DeviceInfoModel> _macosDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String localeName,
  }) async {
    return DeviceInfoModel(
      platform: 'macos',
      brand: 'Apple',
      isPhysicalDevice: true,
      model: deviceInfoData['modelName'] ?? deviceInfoData['model'] as String,
      osVersion: 'MacOS ${deviceInfoData['osRelease']}',
      localeName: localeName,
      deviceId: deviceInfoData['systemGUID'],
    );
  }

  Future<DeviceInfoModel> _webDeviceModel(
    Map<String, dynamic> deviceInfoData, {
    required String? browserName,
  }) async {
    final String browserWebId =
        'Browser ${browserName?.capitalizeFirst} ${deviceInfoData['appVersion']}';
    final String deviceId = md5.convert(utf8.encode(browserWebId)).toString();
    return DeviceInfoModel(
      platform: 'web',
      brand: 'Browser ${browserName?.capitalizeFirst}',
      isPhysicalDevice: false,
      model: deviceInfoData['appVersion'] as String,
      osVersion: deviceInfoData['vendor'] as String,
      localeName: (deviceInfoData['language'] as String?)?.replaceAll('-', '_'),
      deviceId: deviceId,
    );
  }
}
