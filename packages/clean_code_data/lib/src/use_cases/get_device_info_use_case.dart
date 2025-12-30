import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class GetDeviceInfoUseCaseImpl implements GetDeviceInfoUseCase {
  final DeviceInfoService _service;

  GetDeviceInfoUseCaseImpl({required DeviceInfoService deviceInfoService})
    : _service = deviceInfoService;

  @override
  Future<DeviceInfoModel> call() async {
    var deviceInfo = await _service.getDeviceInfo();
    deviceInfo = deviceInfo as DeviceInfoModel;
    return deviceInfo;
  }
}
