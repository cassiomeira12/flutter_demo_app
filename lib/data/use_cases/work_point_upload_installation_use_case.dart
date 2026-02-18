import 'package:core/core.dart';

class WorkPointUploadInstallationUseCase
    implements UploadInstallationAppUseCase {
  final AppInstallationService _service;

  WorkPointUploadInstallationUseCase({
    required AppInstallationService service,
  }) : _service = service;

  @override
  Future<InstallationEntity> call() {
    return _service.getInstallation();
  }
}
