import 'package:clean_code_domain/clean_code_domain.dart';

class InstallationEntity extends ParserToJson {
  final String? installationId;
  final String appName;
  final String appVersion;
  final String appIdentifier;
  final List<String> channels;
  final String? gcmSenderId;
  final String? deviceToken;
  final String? pushType;
  final String? deviceId;
  final String deviceBrand;
  final String deviceModel;
  final String deviceType;
  final String deviceOsVersion;
  final String timeZone;
  final String? localeIdentifier;
  final String platform;
  final String? ip;

  InstallationEntity({
    required this.installationId,
    required this.appName,
    required this.appVersion,
    required this.appIdentifier,
    required this.channels,
    required this.gcmSenderId,
    required this.deviceToken,
    required this.pushType,
    required this.deviceId,
    required this.deviceBrand,
    required this.deviceModel,
    required this.deviceType,
    required this.deviceOsVersion,
    required this.timeZone,
    required this.localeIdentifier,
    required this.platform,
    required this.ip,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'installationId': installationId,
      'appName': appName,
      'appVersion': appVersion,
      'appIdentifier': appIdentifier,
      'channels': channels,
      'GCMSenderId': gcmSenderId,
      'deviceToken': deviceToken,
      'pushType': pushType,
      'deviceId': deviceId,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'deviceType': deviceType,
      'deviceOsVersion': deviceOsVersion,
      'timeZone': timeZone,
      'localeIdentifier': localeIdentifier,
      'platform': platform,
      'ip': ip,
    };
  }

  bool equals(InstallationEntity other) {
    return installationId == other.installationId &&
        appVersion == other.appVersion &&
        gcmSenderId == other.gcmSenderId &&
        deviceToken == other.deviceToken &&
        pushType == other.pushType &&
        deviceId == other.deviceId &&
        deviceOsVersion == other.deviceOsVersion &&
        timeZone == other.timeZone &&
        localeIdentifier == other.localeIdentifier;
  }
}
