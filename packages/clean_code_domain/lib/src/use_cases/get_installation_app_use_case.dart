import 'package:clean_code_domain/clean_code_domain.dart';

abstract class GetInstallationAppUseCase
    extends BaseUseCaseAsync<InstallationEntity> {}

class GetInstallationAppUseCaseImpl implements GetInstallationAppUseCase {
  final AppInstallationService _service;

  GetInstallationAppUseCaseImpl({
    required AppInstallationService appInstallationService,
  }) : _service = appInstallationService;

  @override
  Future<InstallationEntity> call() {
    return _service.getInstallation();
  }
}
