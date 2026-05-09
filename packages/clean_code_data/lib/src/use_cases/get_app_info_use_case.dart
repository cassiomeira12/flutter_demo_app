import 'package:core/core.dart';

class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  final AppInfoService _service;

  GetAppInfoUseCaseImpl({required AppInfoService appInfoService})
    : _service = appInfoService;

  @override
  Future<AppInfoEntity> call() {
    return _service.getAppInfo();
  }
}
