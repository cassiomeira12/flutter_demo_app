import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetDeviceInfoUseCase
    extends BaseUseCaseAsync<DeviceInfoEntity> {}

class GetDeviceInfoUseCaseImpl implements GetDeviceInfoUseCase {
  final DeviceInfoService _service;

  GetDeviceInfoUseCaseImpl({
    required DeviceInfoService deviceInfoService,
  }) : _service = deviceInfoService;

  @override
  Future<DeviceInfoEntity> call() {
    return _service.getDeviceInfo();
  }
}
