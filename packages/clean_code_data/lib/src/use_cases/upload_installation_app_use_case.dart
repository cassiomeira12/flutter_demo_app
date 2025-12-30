import 'package:clean_code_domain/clean_code_domain.dart';

class UploadInstallationAppUseCaseImpl implements UploadInstallationAppUseCase {
  final AppInstallationService _service;

  UploadInstallationAppUseCaseImpl({
    required AppInstallationService appInstallationService,
  }) : _service = appInstallationService;

  @override
  Future<void> call() async {
    final InstallationEntity installation = await _service.getInstallation();
    return _service.upload(installation);
  }
}
