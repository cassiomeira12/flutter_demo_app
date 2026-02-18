import 'package:core/core.dart';

class GetDeviceInfoUseCaseImpl implements GetDeviceInfoUseCase {
  final DeviceInfoService _service;

  GetDeviceInfoUseCaseImpl({required DeviceInfoService deviceInfoService})
    : _service = deviceInfoService;

  @override
  Future<DeviceInfoModel> call() async {
    final deviceInfo = await _service.getDeviceInfo();
    return deviceInfo as DeviceInfoModel;
  }
}
