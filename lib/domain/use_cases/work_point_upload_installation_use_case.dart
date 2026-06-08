import 'package:clean_code_domain/clean_code_domain.dart';

class WorkPointUploadInstallationUseCase
    implements UploadInstallationAppUseCase {
  final AppInstallationService _appInstallationService;

  WorkPointUploadInstallationUseCase({required this._appInstallationService});

  @override
  Future<InstallationEntity> call() {
    return _appInstallationService.getInstallation();
  }
}
