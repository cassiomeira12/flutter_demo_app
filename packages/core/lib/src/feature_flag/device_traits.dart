class DeviceTraits {
  final String brand;
  final String model;
  final String osVersion;
  final String? localeName;
  final String platform;
  final String packageName;
  final String version;
  final String build;
  final bool isWeb;
  final bool debugMode;
  final String deviceId;

  DeviceTraits({
    required this.brand,
    required this.model,
    required this.osVersion,
    required this.localeName,
    required this.platform,
    required this.packageName,
    required this.version,
    required this.build,
    required this.isWeb,
    required this.debugMode,
    required this.deviceId,
  });

  Map<String, String?> toMap() {
    return {
      'brand': brand,
      'model': model,
      'osVersion': osVersion,
      'localeName': localeName,
      'platform': platform,
      'packageName': packageName,
      'version': version,
      'build': build,
      'isWeb': isWeb.toString(),
      'debugMode': debugMode.toString(),
      'deviceId': deviceId,
    };
  }
}
