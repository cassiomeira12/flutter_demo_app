import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetAppInfoUseCase extends BaseUseCaseAsync<AppInfoEntity> {}

class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  final AppInfoService _appInfoService;

  GetAppInfoUseCaseImpl({required this._appInfoService});

  @override
  Future<AppInfoEntity> call() {
    return _appInfoService.getAppInfo();
  }
}
