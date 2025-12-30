import 'package:clean_code_domain/clean_code_domain.dart';

abstract class DeviceInfoService {
  Future<DeviceInfoEntity> getDeviceInfo();
}
