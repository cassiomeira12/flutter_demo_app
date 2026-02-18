import 'package:core/core.dart';

class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  final AppInfoService _service;

  GetAppInfoUseCaseImpl({required AppInfoService appInfoService})
    : _service = appInfoService;

  @override
  Future<AppInfoModel> call() async {
    final appInfo = await _service.getAppInfo();
    return appInfo as AppInfoModel;
  }
}
