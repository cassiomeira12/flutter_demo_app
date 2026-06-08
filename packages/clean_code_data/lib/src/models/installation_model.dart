import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class InstallationModel extends InstallationEntity {
  InstallationModel({
    required super.installationId,
    required super.appName,
    required super.appVersion,
    required super.appIdentifier,
    required super.channels,
    required super.gcmSenderId,
    required super.deviceToken,
    required super.pushType,
    required super.deviceId,
    required super.deviceBrand,
    required super.deviceModel,
    required super.deviceType,
    required super.deviceOsVersion,
    required super.timeZone,
    required super.localeIdentifier,
    required super.platform,
    required super.ip,
  });

  factory InstallationModel.fromMap(Map<String, dynamic> map) {
    try {
      return InstallationModel(
        installationId: map['installationId'],
        appName: map['appName'],
        appVersion: map['appVersion'],
        appIdentifier: map['appIdentifier'],
        channels: List.from(map['channels'] ?? []),
        gcmSenderId: map['GCMSenderId'],
        deviceToken: map['deviceToken'],
        pushType: map['pushType'],
        deviceId: map['deviceId'],
        deviceBrand: map['deviceBrand'],
        deviceModel: map['deviceModel'],
        deviceType: map['deviceType'],
        deviceOsVersion: map['deviceOsVersion'],
        timeZone: map['timeZone'],
        localeIdentifier: map['localeIdentifier'],
        platform: map['platform'],
        ip: map['ip'],
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
