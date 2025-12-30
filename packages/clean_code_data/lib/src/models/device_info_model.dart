import 'package:clean_code_domain/clean_code_domain.dart';

class DeviceInfoModel extends DeviceInfoEntity {
  DeviceInfoModel({
    required super.brand,
    required super.isPhysicalDevice,
    required super.model,
    required super.osVersion,
    required super.localeName,
    required super.deviceId,
    required super.platform,
  });

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

  @override
  String toString() {
    return toMap().toString();
  }
}
