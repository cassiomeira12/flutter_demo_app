import 'package:clean_code_domain/clean_code_domain.dart';

class GetInstallationAppUseCaseImpl implements GetInstallationAppUseCase {
  final AppInstallationService _repository;

  GetInstallationAppUseCaseImpl({
    required AppInstallationService appInstallationService,
  }) : _repository = appInstallationService;

  @override
  Future<InstallationEntity> call() {
    return _repository.getInstallation();
  }
}
