import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetInstallationAppUseCase
    extends BaseUseCaseAsync<InstallationEntity> {}

class GetInstallationAppUseCaseImpl implements GetInstallationAppUseCase {
  final AppInstallationService _appInstallationService;

  GetInstallationAppUseCaseImpl({required this._appInstallationService});

  @override
  Future<InstallationEntity> call() {
    return _appInstallationService.getInstallation();
  }
}
