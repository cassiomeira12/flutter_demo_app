import 'package:core/core.dart';

class GetDeviceInfoUseCaseImpl implements GetDeviceInfoUseCase {
  final DeviceInfoService _service;

  GetDeviceInfoUseCaseImpl({required DeviceInfoService deviceInfoService})
    : _service = deviceInfoService;

  @override
  Future<DeviceInfoEntity> call() {
    return _service.getDeviceInfo();
  }
}
