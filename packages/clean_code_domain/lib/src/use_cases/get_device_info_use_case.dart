import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetDeviceInfoUseCase
    extends BaseUseCaseAsync<DeviceInfoEntity> {}

class GetDeviceInfoUseCaseImpl implements GetDeviceInfoUseCase {
  final DeviceInfoService _deviceInfoService;

  GetDeviceInfoUseCaseImpl({required this._deviceInfoService});

  @override
  Future<DeviceInfoEntity> call() {
    return _deviceInfoService.getDeviceInfo();
  }
}
