import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class InstallationModel extends InstallationEntity {
  InstallationModel({
    required super.appName,
    required super.appVersion,
    required super.appIdentifier,
    required super.channels,
    required super.installationId,
    required super.deviceToken,
    required super.gcmSenderId,
    required super.deviceBrand,
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
        appName: map['appName'],
        appVersion: map['appVersion'],
        appIdentifier: map['appIdentifier'],
        channels: List.from(map['channels'] ?? []),
        installationId: map['installationId'],
        deviceToken: map['deviceToken'],
        gcmSenderId: map['gcmSenderId'],
        deviceBrand: map['deviceBrand'],
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
        stacktrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
