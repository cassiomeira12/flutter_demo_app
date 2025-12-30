class InstallationEntity {
  final String appName;
  final String appVersion;
  final String appIdentifier;
  final List<String> channels;
  final String? installationId;
  final String? deviceToken;
  final String? gcmSenderId;
  final String deviceBrand;
  final String deviceType;
  final String deviceOsVersion;
  final String timeZone;
  final String? localeIdentifier;
  final String platform;
  final String? ip;

  InstallationEntity({
    required this.appName,
    required this.appVersion,
    required this.appIdentifier,
    required this.channels,
    required this.installationId,
    required this.deviceToken,
    required this.gcmSenderId,
    required this.deviceBrand,
    required this.deviceType,
    required this.deviceOsVersion,
    required this.timeZone,
    required this.localeIdentifier,
    required this.platform,
    required this.ip,
  });

  InstallationEntity copyWith({
    String? appVersion,
    List<String>? channels,
    String? deviceToken,
    String? deviceOsVersion,
    String? timeZone,
    String? localeIdentifier,
    String? platform,
    String? ip,
  }) {
    return InstallationEntity(
      appName: appName,
      appVersion: appVersion ?? this.appVersion,
      appIdentifier: appIdentifier,
      channels: channels ?? this.channels,
      installationId: installationId,
      deviceToken: deviceToken ?? this.deviceToken,
      gcmSenderId: gcmSenderId,
      deviceBrand: deviceBrand,
      deviceType: deviceType,
      deviceOsVersion: deviceOsVersion ?? this.deviceOsVersion,
      timeZone: timeZone ?? this.timeZone,
      localeIdentifier: localeIdentifier ?? this.localeIdentifier,
      platform: platform ?? this.platform,
      ip: ip ?? this.ip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'appVersion': appVersion,
      'appIdentifier': appIdentifier,
      'channels': channels,
      'installationId': installationId,
      'deviceToken': deviceToken,
      'GCMSenderId': gcmSenderId,
      'deviceBrand': deviceBrand,
      'deviceType': deviceType,
      'deviceOsVersion': deviceOsVersion,
      'timeZone': timeZone,
      'localeIdentifier': localeIdentifier,
      'platform': platform,
      'ip': ip,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
