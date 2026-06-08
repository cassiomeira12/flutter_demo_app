import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetAppInfoUseCase extends BaseUseCaseAsync<AppInfoEntity> {}

class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  final AppInfoService _service;

  GetAppInfoUseCaseImpl({
    required AppInfoService appInfoService,
  }) : _service = appInfoService;

  @override
  Future<AppInfoEntity> call() {
    return _service.getAppInfo();
  }
}
