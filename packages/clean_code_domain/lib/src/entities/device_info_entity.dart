import 'package:clean_code_domain/clean_code_domain.dart';

class DeviceInfoEntity extends ParserToJson {
  final String brand;
  final bool isPhysicalDevice;
  final String model;
  final String osVersion;
  final String? localeName;
  final String? deviceId;
  final String platform;

  DeviceInfoEntity({
    required this.brand,
    required this.isPhysicalDevice,
    required this.model,
    required this.osVersion,
    required this.localeName,
    required this.deviceId,
    required this.platform,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'isPhysicalDevice': isPhysicalDevice,
      'model': model,
      'osVersion': osVersion,
      'localeName': localeName,
      'deviceId': deviceId,
      'platform': platform,
    };
  }
}
